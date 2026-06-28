#Requires -Version 5.1
<#
  Download and stage a portable Python bundle for ALA.

  This uses the official Windows embeddable package from python.org and
  extracts it into .\portable-python so the installer can bundle it.

  Usage:
    powershell -ExecutionPolicy Bypass -File .\prepare-portable-python.ps1
    powershell -ExecutionPolicy Bypass -File .\prepare-portable-python.ps1 -PythonVersion 3.11.9
#>

param(
    [string]$PythonVersion = "3.11.9",
    [string]$Architecture = "amd64"
)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Write-Step($msg) {
    Write-Host ""
    Write-Host ("==> " + $msg) -ForegroundColor Cyan
}

function Fail($msg) {
    Write-Host ""
    Write-Host ("ERROR: " + $msg) -ForegroundColor Red
    exit 1
}

$bundleDir = Join-Path $PSScriptRoot "portable-python"
$zipName = "python-$PythonVersion-embed-$Architecture.zip"
$downloadUrl = "https://www.python.org/ftp/python/$PythonVersion/$zipName"
$zipPath = Join-Path $env:TEMP $zipName

Write-Step "Downloading portable Python $PythonVersion"
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

Write-Step "Extracting portable Python"
if (Test-Path $bundleDir) {
    Remove-Item -Recurse -Force $bundleDir
}
New-Item -ItemType Directory -Path $bundleDir | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $bundleDir -Force

# The embeddable distro ships with _pth locking imports down. For this project,
# the bundled ALA.exe is frozen, so the Python bundle is mainly for completeness
# and future extensibility. Keep the default isolation intact.

Write-Host ""
Write-Host "Portable Python staged at: $bundleDir" -ForegroundColor Green
