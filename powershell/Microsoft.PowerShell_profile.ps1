#!/usr/bin/env powershell
$profileDir         = Split-Path -Parent $profile

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# If (-Not ($env:ConEmuANSI) -And -Not ($env:RELOADED_TRUE)) {
#   #Write-Host "$PID.pid"
#   $env:RELOADED_TRUE = 1
#   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
#   $newProcess.Arguments = "-nologo"
#   [System.Diagnostics.Process]::Start($newProcess)
#   Stop-Process -Id $PID
# }

Get-ChildItem "$(Join-Path $profileDir "Autoload")\*.ps1" | ForEach-Object{.$_}

# Loading Cmder Profile
If (Get-Command cmder.exe -ErrorAction SilentlyContinue | Test-Path) {
  $cmder_home = Get-Command cmder.exe | Select-Object -ExpandProperty Definition | Split-Path
  If (Test-Path (Join-Path $cmder_home "vendor\profile.ps1"   ))  { . (Join-Path $cmder_home "vendor\profile.ps1")      }
}

#Set-Location "~/workspace/my/dotfiles/"
Write-Host "Welcome Home:"(Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$env:USERNAME'").FullName
