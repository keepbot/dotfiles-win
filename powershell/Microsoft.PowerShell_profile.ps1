#!/usr/bin/env powershell
$profileDir         = Split-Path -Parent $profile

# Loading Cmder Profile
If (Test-Path (Join-Path $HOME ".bin\cmder\vendor\profile.ps1"))  { . (Join-Path $HOME ".bin\cmder\vendor\profile.ps1") }

# Set Colors
If (Test-Path (Join-Path $profileDir "colors.ps1"             ))  { . (Join-Path $profileDir "colors.ps1"             ) }

# Set Environmet
If (Test-Path (Join-Path $profileDir "environment.ps1"        ))  { . (Join-Path $profileDir "environment.ps1"        ) }

# Set Aliases
If (Test-Path (Join-Path $profileDir "aliases.ps1"            ))  { . (Join-Path $profileDir "aliases.ps1"            ) }

# Load functions
If (Test-Path (Join-Path $profileDir "functions.ps1"          ))  { . (Join-Path $profileDir "functions.ps1"          ) }

$list_of_modules = @(
"OData"
"posh-docker"
"posh-git"
"PSReadline"
)

foreach ($module in $list_of_modules) {
  Import-Module $module
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Set-Location ~
Write-Host "Welcome Home:"(Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$env:USERNAME'").FullName
