#Requires -Version 5.1
<#
  Build a portable Windows distribution for ALA.

  This variant is resilient when static/icon.ico has not been uploaded yet.
  If the icon exists, PyInstaller will use it. Otherwise it will build without
  a custom icon and continue normally.
#>

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Write-Step($msg) { Write-Host ""; Write-Host ("==> " + $msg) -ForegroundColor Cyan }
function Fail($msg) {
    Write-Host ""
    Write-Host ("ERROR: " + $msg) -ForegroundColor Red
    exit 1
}

Write-Step "Checking for Python"
$pyExe = $null
if (Test-Path ".\.venv\Scripts\python.exe") {
    $pyExe = (Resolve-Path ".\.venv\Scripts\python.exe").Path
} else {
    foreach ($c in @("py", "python")) {
        $cmd = Get-Command $c -ErrorAction SilentlyContinue
        if ($cmd) { $pyExe = $cmd.Source; break }
    }
    if ($pyExe -like "*WindowsApps*python.exe") {
        $pyCmd = Get-Command py -ErrorAction SilentlyContinue
        if ($pyCmd) { $pyExe = $pyCmd.Source }
    }
}
if (-not $pyExe) { Fail "Python not found on PATH. Install Python 3.11+ first." }
Write-Host ("Using Python: " + $pyExe)

Write-Step "Installing build dependencies"
& $pyExe -m pip install --upgrade pip --quiet
& $pyExe -m pip install -r requirements.txt pyinstaller pystray Pillow
if ($LASTEXITCODE -ne 0) { Fail "Dependency install failed." }

Write-Step "Building portable exe bundle"
Remove-Item -Recurse -Force build, dist -ErrorAction SilentlyContinue

$dataArgs = @(
    "--add-data", "static;static",
    "--add-data", "scripts;scripts",
    "--add-data", "mcp_servers;mcp_servers",
    "--add-data", "services/hwfit/data;services/hwfit/data",
    "--add-data", "config;config",
    "--add-data", ".env.example;.env.example"
)

$iconArgs = @()
$iconPath = Join-Path $PSScriptRoot "static\icon.ico"
if (Test-Path $iconPath) {
    $iconArgs = @("--icon=$iconPath")
    Write-Host "Using icon: $iconPath" -ForegroundColor DarkGray
} else {
    Write-Host "Icon not found at static\\icon.ico - building without a custom icon." -ForegroundColor Yellow
}

& $pyExe -m PyInstaller --noconfirm --clean --onedir --noconsole --name ALA @iconArgs @dataArgs launcher.py
if ($LASTEXITCODE -ne 0) { Fail "PyInstaller build failed." }

Write-Host ""
Write-Host "Build complete." -ForegroundColor Green
Write-Host "Portable app folder: $PSScriptRoot\dist\ALA" -ForegroundColor Green
