<#
.SYNOPSIS
Bitbucket scripts.

.DESCRIPTION
Bitbucket scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Set-BambooSecrets
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$UrlBase,
        [Parameter(Mandatory=$true)]
        [string]$Token
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bamboo.secrets')
    Add-Content $SecretFile "$UrlBase"
    Add-Content $SecretFile "$Token"
}

function Get-BambooUrl
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bamboo.secrets')

    if (-Not (Test-Path -Path $SecretFile)) {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BambooSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    return $(Get-Content $SecretFile -First 1)
}

function Get-BambooToken
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bamboo.secrets')

    if (-Not (Test-Path -Path $SecretFile)) {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BambooSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    return $(Get-Content $SecretFile -First 2)[-1]
}
