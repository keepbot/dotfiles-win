#!/usr/bin/env powershell
$profileDir         = Split-Path -Parent $profile

If (-Not ($env:ConEmuANSI) -And -Not ($env:RELOADED_TRUE)) {
  #Write-Host "$PID.pid"
  $env:RELOADED_TRUE = 1
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
  $newProcess.Arguments = "-nologo"
  [System.Diagnostics.Process]::Start($newProcess)
  Stop-Process -Id $PID
}

# Load Functions
If (Test-Path (Join-Path $profileDir "functions.ps1"          ))  { . (Join-Path $profileDir "functions.ps1"          ) }

# Set Colors
If (Test-Path (Join-Path $profileDir "colors.ps1"             ))  { . (Join-Path $profileDir "colors.ps1"             ) }

# Set Environmet
If (Test-Path (Join-Path $profileDir "environment.ps1"        ))  { . (Join-Path $profileDir "environment.ps1"        ) }

# Set Aliases
If (Test-Path (Join-Path $profileDir "aliases.ps1"            ))  { . (Join-Path $profileDir "aliases.ps1"            ) }

# Load Modules
If (Test-Path (Join-Path $profileDir "modules.ps1"            ))  { . (Join-Path $profileDir "modules.ps1"            ) }

# Loading Cmder Profile
If (Test-Path "c:\tools\cmdermini\vendor\profile.ps1"          )  {. "c:\tools\cmdermini\vendor\profile.ps1"            }

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Get-ChildItem "$(Join-Path $profileDir "Scripts\Autoload")\*.ps1" | ForEach-Object{.$_}

#Set-Location "~/workspace/my/dotfiles/"
Write-Host "Welcome Home:"(Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$env:USERNAME'").FullName
