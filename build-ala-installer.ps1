#Requires -Version 5.1
<#
  Build the ALA Windows installer end-to-end.

  This script:
    1) Builds the portable ALA app into dist\ALA
    2) Verifies a portable Python bundle exists in .\portable-python
    3) Invokes Inno Setup to produce installer\output\ALA_Setup.exe

  Usage:
    powershell -ExecutionPolicy Bypass -File .\build-ala-installer.ps1
    powershell -ExecutionPolicy Bypass -File .\build-ala-installer.ps1 -ISCCPath "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
#>

param(
    [string]$ISCCPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    [switch]$SkipPortableBuild
)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Write-Step($msg) {
    Write-Host ""
    Write-Host ("==> " + $msg) -ForegroundColor Cyan
}

function Write-Percent($pct, $msg) {
    Write-Host ("[{0}%] {1}" -f $pct, $msg) -ForegroundColor DarkGray
}

function Fail($msg) {
    Write-Host ""
    Write-Host ("ERROR: " + $msg) -ForegroundColor Red
    exit 1
}

if (-not $SkipPortableBuild) {
    Write-Percent 10 "Starting portable ALA app build"
    Write-Step "Building portable ALA app"
    & powershell -ExecutionPolicy Bypass -File .\build-windows-portable.ps1
    if ($LASTEXITCODE -ne 0) { Fail "Portable app build failed." }
}

$portablePython = Join-Path $PSScriptRoot "portable-python"
if (-not (Test-Path $portablePython)) {
    Write-Percent 30 "Preparing portable Python bundle"
    Write-Step "Preparing portable Python bundle"
    & powershell -ExecutionPolicy Bypass -File .\prepare-portable-python.ps1
    if ($LASTEXITCODE -ne 0) { Fail "Portable Python preparation failed." }
}

$launcher = Join-Path $PSScriptRoot "dist\ALA\ALA.exe"
if (-not (Test-Path $launcher)) {
    Fail "Missing dist\ALA\ALA.exe. Run the portable build first."
}

$iss = Join-Path $PSScriptRoot "installer\ALA_Setup.iss"
if (-not (Test-Path $iss)) {
    Fail "Missing installer\ALA_Setup.iss."
}

if (-not (Test-Path $ISCCPath)) {
    Fail "Inno Setup compiler not found at: $ISCCPath"
}

Write-Percent 70 "Compiling installer"
Write-Step "Compiling Inno Setup installer"
& $ISCCPath $iss
if ($LASTEXITCODE -ne 0) { Fail "Inno Setup compilation failed." }

Write-Percent 100 "Installer ready"
Write-Host ""
Write-Host "Installer build complete." -ForegroundColor Green
Write-Host "Output: installer\output\ALA_Setup.exe" -ForegroundColor Green
