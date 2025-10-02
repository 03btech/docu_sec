# Setup Script for YOLOv8 Security Monitoring
# Run this script to install all required dependencies

Write-Host "=================================" -ForegroundColor Cyan
Write-Host "YOLOv8 Security Monitoring Setup" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check Python installation
Write-Host "Checking Python installation..." -ForegroundColor Yellow
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
    Write-Host "ERROR: Python not found. Please install Python 3.8+ first." -ForegroundColor Red
    exit 1
}

$pythonVersion = python --version
Write-Host "✓ Found: $pythonVersion" -ForegroundColor Green
Write-Host ""

# Navigate to frontend directory
$frontendPath = Join-Path $PSScriptRoot "frontend"
if (Test-Path $frontendPath) {
    Set-Location $frontendPath
    Write-Host "✓ Changed to frontend directory" -ForegroundColor Green
} else {
    Write-Host "ERROR: Frontend directory not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing required packages..." -ForegroundColor Yellow
Write-Host ""

# Install core dependencies
Write-Host "[1/5] Installing PyQt6..." -ForegroundColor Cyan
python -m pip install PyQt6 --quiet

Write-Host "[2/5] Installing YOLOv8 (ultralytics)..." -ForegroundColor Cyan
python -m pip install ultralytics --quiet

Write-Host "[3/5] Installing OpenCV..." -ForegroundColor Cyan
python -m pip install opencv-python --quiet

Write-Host "[4/5] Installing PyTorch..." -ForegroundColor Cyan
# Check if CUDA is available
$cudaAvailable = $false
try {
    $nvidiaSmi = nvidia-smi 2>$null
    if ($LASTEXITCODE -eq 0) {
        $cudaAvailable = $true
    }
} catch {
    $cudaAvailable = $false
}

if ($cudaAvailable) {
    Write-Host "  ✓ CUDA detected - Installing GPU-enabled PyTorch" -ForegroundColor Green
    python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118 --quiet
} else {
    Write-Host "  ℹ No CUDA detected - Installing CPU-only PyTorch" -ForegroundColor Yellow
    python -m pip install torch torchvision --quiet
}

Write-Host "[5/5] Installing additional dependencies..." -ForegroundColor Cyan
python -m pip install requests Pillow PyMuPDF python-docx qtawesome matplotlib mss --quiet

Write-Host ""
Write-Host "✓ All dependencies installed successfully!" -ForegroundColor Green
Write-Host ""

# Download YOLOv8 model (pre-download to avoid first-run delay)
Write-Host "Downloading YOLOv8 model..." -ForegroundColor Yellow
python -c "from ultralytics import YOLO; model = YOLO('yolov8n.pt'); print('✓ Model downloaded')" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ YOLOv8 model downloaded (~6MB)" -ForegroundColor Green
} else {
    Write-Host "⚠ Model will be downloaded on first use" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To test the camera:" -ForegroundColor Cyan
Write-Host "  python -c `"from utils.camera_utils import check_camera_available; print(check_camera_available())`"" -ForegroundColor White
Write-Host ""
Write-Host "To run the application:" -ForegroundColor Cyan
Write-Host "  cd frontend" -ForegroundColor White
Write-Host "  python main.py" -ForegroundColor White
Write-Host ""

# Test camera
Write-Host "Testing camera availability..." -ForegroundColor Yellow
$cameraTest = python -c "import sys; sys.path.insert(0, '.'); from utils.camera_utils import check_camera_available; is_avail, msg = check_camera_available(); print(f'{is_avail}|{msg}')" 2>$null
if ($cameraTest) {
    $parts = $cameraTest -split '\|'
    if ($parts[0] -eq "True") {
        Write-Host "✓ Camera detected and working!" -ForegroundColor Green
        Write-Host "  $($parts[1])" -ForegroundColor Gray
    } else {
        Write-Host "⚠ Camera test failed:" -ForegroundColor Yellow
        Write-Host "  $($parts[1])" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  Please check:" -ForegroundColor Yellow
        Write-Host "    - Camera is connected" -ForegroundColor White
        Write-Host "    - Camera permissions in Windows Settings > Privacy > Camera" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "For documentation, see: YOLOV8_MONITORING.md" -ForegroundColor Cyan
Write-Host ""
