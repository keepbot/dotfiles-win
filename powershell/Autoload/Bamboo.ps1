<#
.SYNOPSIS
Bamboo scripts.

.DESCRIPTION
Bamboo scripts.
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
        [string]$ServerUrl,
        [Parameter(Mandatory=$true)]
        [string]$Token,
        [Parameter(Mandatory=$true)]
        [string]$Username,
        [Parameter(Mandatory=$true)]
        [string]$Pass
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bamboo.secrets')
    Add-Content $SecretFile "$ServerUrl"
    Add-Content $SecretFile "$Token"
    Add-Content $SecretFile "$Username"
    Add-Content $SecretFile "$Pass"
}

function Get-BambooRESTUrlBase
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bamboo.secrets')

    if (-Not (Test-Path -Path $SecretFile)) {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BambooSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $ServerUrl = $(Get-Content $SecretFile -First 1)
    return "https://${ServerUrl}/rest/api/latest/"
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

function Get-BambooCreds
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bamboo.secrets')

    if (-Not (Test-Path -Path $SecretFile)) {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BambooSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $Username = $(Get-Content $SecretFile -First 4)[2]
    $Password = $(Get-Content $SecretFile -First 4)[3]
    return "${Username}:${Password}"
}


function Invoke-BambooLink
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Link,
        [string] $Method        = 'GET',
        [switch] $ShowRequestUri,
        [string] $OutFile       = 'None'
    )

    $CredentialsPair = Get-BambooCreds
    $EncodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($CredentialsPair))

    $Headers    = @{
        'Authorization' = "Basic $EncodedCredentials"
        'Content-Type'=('application/json')

    };

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: ${Link}" -ForegroundColor Yellow
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    if ($OutFile -eq 'None')
    {
        $Response = Invoke-WebRequest -Headers ${Headers} -Uri ${Link} -Method "${Method}"
    }
    else
    {
        $Response = Invoke-WebRequest -Headers ${Headers} -Uri ${Link} -Method "${Method}" -OutFile ${OutFile}
    }

    return $Response
}

function Invoke-BambooLink-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Link,
        [string] $Method            = 'GET',
        [string[]] $CurlArgs        = @('-s'),
        [switch] $VerboseOutput,
        [switch] $ShowRequestUri
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $CredentialsPair = Get-BambooCreds
    # $EncodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($CredentialsPair))
    # $Headers    = "Authorization: Basic ${EncodedCredentials}; Content-Type: application/json"
    $Headers    = "Content-Type: application/json"

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: ${Link}" -ForegroundColor Yellow
    }

    $Response = (curl.exe -k -u $CredentialsPair -X ${Method} -H ${Headers} ${Link} ${CurlArgs})
    return $Response
}

function Invoke-BambooREST
{
    [CmdletBinding()]
    param
    (
        [string] $Path,
        [string] $Method        = 'GET',
        [switch] $ShowRequestUri
    )

    $UrlBase    = Get-BambooRESTUrlBase
    $Token      = Get-BambooToken
    $Headers    = @{
        'Authorization'=("Bearer {0}" -f $Token)
        'Content-Type'=('application/json')

    };

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: ${UrlBase}${Path}" -ForegroundColor Yellow
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Headers ${Headers} -Uri ${UrlBase}${Path} -Method "${Method}"
    return $Response
}

function Invoke-BambooREST-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $Path,
        [string] $Method            = 'GET',
        [string[]] $CurlArgs        = @('-s'),
        [switch] $VerboseOutput,
        [switch] $ShowRequestUri
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $UrlBase    = Get-BambooRESTUrlBase
    $Token      = Get-BambooToken
    $Headers    = "Authorization: Bearer ${Token}; Content-Type: application/json"

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: ${UrlBase}${Path}" -ForegroundColor Yellow
    }

    $Response = (curl.exe -k -X ${Method} -H ${Headers} ${UrlBase}${Path} ${CurlArgs})
    return $Response
}
