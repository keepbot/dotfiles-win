<#
.SYNOPSIS
Package scripts.

.DESCRIPTION
Package scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Remove-WAPP
{
    if ($args.Count -ne 1)
    {
        Write-Host "Usage: rm-wapp <package_mask>"
    }
    else
    {
        Get-AppxPackage *$($args[0].ToString())* | Remove-AppxPackage
    }
}

function Get-WAPP
{
    if ($args.Count -ne 1)
    {
        Write-Host "Usage: get-wapp <package_mask>"
    }
    else
    {
        Get-AppxPackage *$($args[0].ToString())*
    }
}

function Install-WAPP
{
    Get-AppxPackage *$($args[0].ToString())* | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}

function Install-WAPP-All
{
    Get-AppxPackage -AllUsers| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}
