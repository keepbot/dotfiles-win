#!/usr/bin/env powershell
$profileDir         = Split-Path -Parent $profile

# Loading Cmder Profile
If (Test-Path (Join-Path $HOME ".bin\cmder\vendor\profile.ps1"))  { . (Join-Path $HOME ".bin\cmder\vendor\profile.ps1") }

# Set Colors
If (Test-Path (Join-Path $profileDir "colors.ps1"             ))  { . (Join-Path $profileDir "colors.ps1"             ) }

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Set-Location ~
Write-Host "Welcome Home: %USERNAME%"
