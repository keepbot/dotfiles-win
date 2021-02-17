#!/usr/bin/env powershell

$dotfilesProfileDir = Join-Path $PSScriptRoot "powershell"
$dotfilesModulesDir = Join-Path $dotfilesProfileDir "Modules"
$dotfilesScriptsDir = Join-Path $dotfilesProfileDir "Scripts"
$profileDir         = Split-Path -Parent $profile

# $OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
# $PSDefaultParameterValues['*:Encoding'] = 'utf8'
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# If (-Not ($env:ConEmuANSI) -And -Not ($env:RELOADED_TRUE)) {
#   #Write-Host "$PID.pid"
#   $env:RELOADED_TRUE = 1
#   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
#   $newProcess.Arguments = "-nologo"
#   [System.Diagnostics.Process]::Start($newProcess)
#   Stop-Process -Id $PID
# }

Get-ChildItem "$(Join-Path $PSScriptRoot "Autoload")\*.ps1" | ForEach-Object { . $_ }

$PrivatePSAutoladFolder = $(Join-Path $Env:USERPROFILE "OneDrive\bin\ps_autoload")
If (Test-Path $PrivatePSAutoladFolder)
{
    Get-ChildItem "$PrivatePSAutoladFolder\*.ps1" | ForEach-Object { . $_ }
}

# Loading Cmder Profile
# If (Get-Command cmder.exe -ErrorAction SilentlyContinue | Test-Path) {
#   $cmder_home = Get-Command cmder.exe | Select-Object -ExpandProperty Definition | Split-Path
#   If (Test-Path (Join-Path $cmder_home "vendor\profile.ps1"   ))  { . (Join-Path $cmder_home "vendor\profile.ps1")      }
# }

#Set-Location "~/workspace/my/dotfiles/"

# Invovoke ANSI 256 Color Console
# AnsiColors256
AnsiConsole

# Write-Host "Welcome Home:"(Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$env:USERNAME'").FullName
# Write-Host "Welcome Home: $(Split-Path (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName).UserName -Leaf)"
