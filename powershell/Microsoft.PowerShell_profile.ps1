#!/usr/bin/env powershell
Set-ExecutionPolicy RemoteSigned

$list_of_modules = @(
    "posh-git"
    "posh-docker"
)

Write-Host "Initialization of PowerShell profile. Be patient. It's hurt only first time..."

foreach ($module in $list_of_modules) {
	if (Get-Module -ListAvailable -Name $module ) {
        Write-Host "Module $module already exist"
    } else {
        Install-Module -Scope CurrentUser $module
        Write-Host "Module $module succesfully installed"
    }

    Import-Module $module
}

# Set-Location ~
Write-Host "Welcome Home: %USERNAME%"
