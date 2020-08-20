<#
.SYNOPSIS
AWS scripts.

.DESCRIPTION
AWS scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function aws_see_env_vars()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $AccessKey,
        [Parameter(Mandatory=$true)]
        [string] $SecretKey,
        [string] $Region = 'us-east-1'

    )
    $Env:AWS_ACCESS_KEY_ID      = "$AccessKey"
    $Env:AWS_SECRET_ACCESS_KEY  = "$SecretKey"
    $Env:AWS_DEFAULT_REGION     = "$Region"
}
