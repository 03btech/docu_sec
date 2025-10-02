# DocuSec Backend Management Script
# Quick commands for managing the backend server

param(
    [Parameter(Position=0)]
    [ValidateSet('start', 'stop', 'restart', 'logs', 'status', 'update', 'cleanup', 'backup', 'ip', 'help')]
    [string]$Command = 'help'
)

$ComposeFile = "docker-compose.backend.yml"

function Show-Help {
    Write-Host ""
    Write-Host "DocuSec Backend Management Commands" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\manage_backend.ps1 <command>" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  start    - Start backend services" -ForegroundColor White
    Write-Host "  stop     - Stop backend services" -ForegroundColor White
    Write-Host "  restart  - Restart backend services" -ForegroundColor White
    Write-Host "  logs     - View live logs" -ForegroundColor White
    Write-Host "  status   - Show service status" -ForegroundColor White
    Write-Host "  update   - Rebuild and update backend" -ForegroundColor White
    Write-Host "  cleanup  - Remove all containers and data (WARNING!)" -ForegroundColor White
    Write-Host "  backup   - Backup database" -ForegroundColor White
    Write-Host "  ip       - Show server IP address" -ForegroundColor White
    Write-Host "  help     - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\manage_backend.ps1 start" -ForegroundColor Gray
    Write-Host "  .\manage_backend.ps1 logs" -ForegroundColor Gray
    Write-Host "  .\manage_backend.ps1 status" -ForegroundColor Gray
    Write-Host ""
}

function Start-Services {
    Write-Host "Starting backend services..." -ForegroundColor Yellow
    docker-compose -f $ComposeFile start
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Services started successfully" -ForegroundColor Green
        Start-Sleep -Seconds 3
        Get-Status
    } else {
        Write-Host "✗ Failed to start services" -ForegroundColor Red
    }
}

function Stop-Services {
    Write-Host "Stopping backend services..." -ForegroundColor Yellow
    docker-compose -f $ComposeFile stop
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Services stopped successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to stop services" -ForegroundColor Red
    }
}

function Restart-Services {
    Write-Host "Restarting backend services..." -ForegroundColor Yellow
    docker-compose -f $ComposeFile restart
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Services restarted successfully" -ForegroundColor Green
        Start-Sleep -Seconds 3
        Get-Status
    } else {
        Write-Host "✗ Failed to restart services" -ForegroundColor Red
    }
}

function Show-Logs {
    Write-Host "Showing live logs (Press Ctrl+C to exit)..." -ForegroundColor Yellow
    Write-Host ""
    docker-compose -f $ComposeFile logs -f
}

function Get-Status {
    Write-Host ""
    Write-Host "Service Status:" -ForegroundColor Cyan
    docker-compose -f $ComposeFile ps
    Write-Host ""
    
    # Check if backend is responding
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/" -TimeoutSec 5 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ Backend API is responding: http://localhost:8000" -ForegroundColor Green
            Write-Host "✓ API Documentation: http://localhost:8000/docs" -ForegroundColor Green
        }
    } catch {
        Write-Host "⚠ Backend API is not responding on http://localhost:8000" -ForegroundColor Yellow
    }
}

function Update-Services {
    Write-Host "Updating backend services..." -ForegroundColor Yellow
    Write-Host "This will rebuild the Docker image with latest code changes..." -ForegroundColor Cyan
    Write-Host ""
    
    docker-compose -f $ComposeFile up -d --build backend
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ Update completed successfully" -ForegroundColor Green
        Start-Sleep -Seconds 5
        Get-Status
    } else {
        Write-Host "✗ Update failed" -ForegroundColor Red
    }
}

function Remove-Everything {
    Write-Host ""
    Write-Host "WARNING: This will remove all containers, volumes, and data!" -ForegroundColor Red
    Write-Host "This action cannot be undone!" -ForegroundColor Red
    Write-Host ""
    
    $confirmation = Read-Host "Are you sure? Type 'yes' to continue"
    
    if ($confirmation -eq 'yes') {
        Write-Host "Removing everything..." -ForegroundColor Yellow
        docker-compose -f $ComposeFile down -v
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Cleanup completed" -ForegroundColor Green
        } else {
            Write-Host "✗ Cleanup failed" -ForegroundColor Red
        }
    } else {
        Write-Host "Cleanup cancelled" -ForegroundColor Yellow
    }
}

function Backup-Database {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = "backup_$timestamp.sql"
    
    Write-Host "Creating database backup..." -ForegroundColor Yellow
    Write-Host "Backup file: $backupFile" -ForegroundColor Cyan
    
    docker exec docusec-postgres pg_dump -U docusec_user docu_security_db > $backupFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Backup created successfully: $backupFile" -ForegroundColor Green
        
        $fileSize = (Get-Item $backupFile).Length / 1KB
        Write-Host "  File size: $([math]::Round($fileSize, 2)) KB" -ForegroundColor Gray
    } else {
        Write-Host "✗ Backup failed" -ForegroundColor Red
    }
}

function Show-IPAddress {
    Write-Host ""
    Write-Host "Server Network Information:" -ForegroundColor Cyan
    Write-Host ""
    
    # Get local IP addresses
    $ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | 
                   Where-Object {$_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*"} |
                   Select-Object IPAddress, InterfaceAlias
    
    if ($ipAddresses) {
        Write-Host "Available IP Addresses:" -ForegroundColor Yellow
        foreach ($ip in $ipAddresses) {
            Write-Host "  $($ip.IPAddress) ($($ip.InterfaceAlias))" -ForegroundColor White
        }
        
        $primaryIP = $ipAddresses[0].IPAddress
        Write-Host ""
        Write-Host "Frontend Configuration:" -ForegroundColor Yellow
        Write-Host "  API_BASE_URL = `"http://${primaryIP}:8000`"" -ForegroundColor Green
    } else {
        Write-Host "No network interfaces found" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Local Access:" -ForegroundColor Yellow
    Write-Host "  http://localhost:8000" -ForegroundColor White
    Write-Host "  http://localhost:8000/docs (API Documentation)" -ForegroundColor White
    Write-Host ""
}

# Main script logic
switch ($Command) {
    'start'   { Start-Services }
    'stop'    { Stop-Services }
    'restart' { Restart-Services }
    'logs'    { Show-Logs }
    'status'  { Get-Status }
    'update'  { Update-Services }
    'cleanup' { Remove-Everything }
    'backup'  { Backup-Database }
    'ip'      { Show-IPAddress }
    'help'    { Show-Help }
    default   { Show-Help }
}
