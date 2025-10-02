# Git Repository Setup Script for DocuSec
# This script helps you initialize and push your project to GitHub

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "DocuSec Git Repository Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if a command exists
function Test-Command {
    param($Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}

# Step 1: Check if Git is installed
Write-Host "[1/8] Checking Git installation..." -ForegroundColor Yellow

if (-not (Test-Command git)) {
    Write-Host "ERROR: Git is not installed!" -ForegroundColor Red
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

Write-Host "Success: Git is installed" -ForegroundColor Green
$gitVersion = git --version
Write-Host "  Version: $gitVersion" -ForegroundColor Gray

# Step 2: Check if already a git repository
Write-Host ""
Write-Host "[2/8] Checking repository status..." -ForegroundColor Yellow

if (Test-Path ".git") {
    Write-Host "Warning: This is already a Git repository" -ForegroundColor Yellow
    $reinit = Read-Host "Do you want to reinitialize? This will preserve your commit history (yes/no)"
    
    if ($reinit -ne "yes") {
        Write-Host "Setup cancelled" -ForegroundColor Yellow
        exit 0
    }
} else {
    Write-Host "Success: Not a Git repository yet" -ForegroundColor Green
}

# Step 3: Initialize Git repository
Write-Host ""
Write-Host "[3/8] Initializing Git repository..." -ForegroundColor Yellow

if (-not (Test-Path ".git")) {
    git init
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success: Git repository initialized" -ForegroundColor Green
    } else {
        Write-Host "Error: Failed to initialize Git repository" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Success: Repository already initialized" -ForegroundColor Green
}

# Step 4: Configure Git user (if not configured)
Write-Host ""
Write-Host "[4/8] Checking Git configuration..." -ForegroundColor Yellow

$gitUserName = git config user.name 2>$null
$gitUserEmail = git config user.email 2>$null

if (-not $gitUserName) {
    Write-Host "Git user name not configured" -ForegroundColor Cyan
    $userName = Read-Host "Enter your name"
    git config user.name "$userName"
    Write-Host "Success: User name set: $userName" -ForegroundColor Green
} else {
    Write-Host "Success: User name: $gitUserName" -ForegroundColor Green
}

if (-not $gitUserEmail) {
    Write-Host "Git user email not configured" -ForegroundColor Cyan
    $userEmail = Read-Host "Enter your email"
    git config user.email "$userEmail"
    Write-Host "Success: User email set: $userEmail" -ForegroundColor Green
} else {
    Write-Host "Success: User email: $gitUserEmail" -ForegroundColor Green
}

# Step 5: Review .gitignore
Write-Host ""
Write-Host "[5/8] Reviewing .gitignore..." -ForegroundColor Yellow

if (Test-Path ".gitignore") {
    Write-Host "Success: .gitignore file exists" -ForegroundColor Green
    Write-Host "  The following will be excluded:" -ForegroundColor Gray
    Write-Host "  - All .md files (documentation)" -ForegroundColor Gray
    Write-Host "  - .env files (secrets)" -ForegroundColor Gray
    Write-Host "  - __pycache__ and *.pyc (Python cache)" -ForegroundColor Gray
    Write-Host "  - uploaded_files/ (user uploads)" -ForegroundColor Gray
    Write-Host "  - *.pt, *.pth (ML models)" -ForegroundColor Gray
    Write-Host "  - Database dumps and backups" -ForegroundColor Gray
    Write-Host "  - Docker volumes" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Included:" -ForegroundColor Gray
    Write-Host "  - README.md (kept for GitHub)" -ForegroundColor Gray
} else {
    Write-Host "Warning: .gitignore file not found!" -ForegroundColor Yellow
    Write-Host "  Please create one before proceeding" -ForegroundColor Yellow
    exit 1
}

# Step 6: Show files to be added
Write-Host ""
Write-Host "[6/8] Checking files to be added..." -ForegroundColor Yellow

# Add all files respecting .gitignore
git add .

# Show status
Write-Host ""
Write-Host "Files to be committed:" -ForegroundColor Cyan
git status --short

Write-Host ""
$fileCount = (git status --short | Measure-Object).Count
Write-Host "Total files to commit: $fileCount" -ForegroundColor Cyan

Write-Host ""
$proceed = Read-Host "Do you want to proceed with these files? (yes/no)"

if ($proceed -ne "yes") {
    Write-Host "Setup cancelled. Run 'git status' to see what would be added." -ForegroundColor Yellow
    exit 0
}

# Step 7: Create initial commit
Write-Host ""
Write-Host "[7/8] Creating initial commit..." -ForegroundColor Yellow

$commitMessage = Read-Host "Enter commit message (or press Enter for default)"

if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Initial commit - DocuSec Document Security System"
}

git commit -m "$commitMessage"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Success: Initial commit created" -ForegroundColor Green
} else {
    Write-Host "Warning: Commit failed or nothing to commit" -ForegroundColor Yellow
}

# Step 8: Set up remote repository
Write-Host ""
Write-Host "[8/8] Setting up remote repository..." -ForegroundColor Yellow
Write-Host ""

Write-Host "To push to GitHub, you need to:" -ForegroundColor Cyan
Write-Host "1. Create a new repository on GitHub (https://github.com/new)" -ForegroundColor White
Write-Host "2. Do not initialize it with README, .gitignore, or license" -ForegroundColor White
Write-Host "3. Copy the repository URL" -ForegroundColor White
Write-Host ""

$setupRemote = Read-Host "Do you want to add a remote repository now? (yes/no)"

if ($setupRemote -eq "yes") {
    $remoteUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/docusec.git)"
    
    if (-not [string]::IsNullOrWhiteSpace($remoteUrl)) {
        # Check if remote already exists
        $existingRemote = git remote get-url origin 2>$null
        
        if ($existingRemote) {
            Write-Host "Remote 'origin' already exists: $existingRemote" -ForegroundColor Yellow
            $updateRemote = Read-Host "Do you want to update it? (yes/no)"
            
            if ($updateRemote -eq "yes") {
                git remote set-url origin $remoteUrl
                Write-Host "Success: Remote URL updated" -ForegroundColor Green
            }
        } else {
            git remote add origin $remoteUrl
            Write-Host "Success: Remote repository added" -ForegroundColor Green
        }
        
        Write-Host ""
        $pushNow = Read-Host "Do you want to push to GitHub now? (yes/no)"
        
        if ($pushNow -eq "yes") {
            Write-Host ""
            Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
            
            # Get current branch name
            $branchName = git rev-parse --abbrev-ref HEAD
            
            git push -u origin $branchName
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Success: Successfully pushed to GitHub!" -ForegroundColor Green
            } else {
                Write-Host "Error: Push failed" -ForegroundColor Red
                Write-Host "You may need to authenticate with GitHub" -ForegroundColor Yellow
                Write-Host "Try: gh auth login (if GitHub CLI is installed)" -ForegroundColor Yellow
                Write-Host "Or set up SSH keys: https://docs.github.com/en/authentication" -ForegroundColor Yellow
            }
        }
    }
} else {
    Write-Host ""
    Write-Host "You can add a remote repository later with:" -ForegroundColor Cyan
    Write-Host "  git remote add origin YOUR-REPOSITORY-URL" -ForegroundColor White
    Write-Host "  git push -u origin main" -ForegroundColor White
}

# Summary
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Git Repository Status:" -ForegroundColor Cyan
git status --short --branch

Write-Host ""
Write-Host "Useful Git Commands:" -ForegroundColor Cyan
Write-Host "  git status              - Check repository status" -ForegroundColor White
Write-Host "  git add FILENAME        - Stage specific file" -ForegroundColor White
Write-Host "  git add .               - Stage all changes" -ForegroundColor White
Write-Host "  git commit -m 'msg'     - Commit staged changes" -ForegroundColor White
Write-Host "  git push                - Push to remote repository" -ForegroundColor White
Write-Host "  git pull                - Pull from remote repository" -ForegroundColor White
Write-Host "  git log --oneline       - View commit history" -ForegroundColor White
Write-Host "  git branch              - List branches" -ForegroundColor White
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Review files: git status" -ForegroundColor White
Write-Host "2. Create GitHub repository if not done" -ForegroundColor White
Write-Host "3. Add remote: git remote add origin YOUR-REPO-URL" -ForegroundColor White
Write-Host "4. Push code: git push -u origin main" -ForegroundColor White
Write-Host ""

Write-Host "Important Notes:" -ForegroundColor Yellow
Write-Host "- All .md documentation files are excluded (except README.md)" -ForegroundColor Gray
Write-Host "- .env files are excluded (keep your secrets safe!)" -ForegroundColor Gray
Write-Host "- ML models (*.pt) are excluded (too large for Git)" -ForegroundColor Gray
Write-Host "- Upload folders are excluded" -ForegroundColor Gray
Write-Host "- Database dumps are excluded" -ForegroundColor Gray
Write-Host ""
