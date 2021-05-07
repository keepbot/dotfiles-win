<#
.SYNOPSIS
Confluence scripts.

.DESCRIPTION
Confluence scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Set-ConfluenceSecrets
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
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.confluence.secrets')
    Add-Content $SecretFile "$ServerUrl"
    Add-Content $SecretFile "$Token"
    Add-Content $SecretFile "$Username"
    Add-Content $SecretFile "$Pass"
}

function Get-ConfluenceUrlBase
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.confluence.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-ConfluenceSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $ServerUrl = $(Get-Content $SecretFile -First 1)
    return "https://${ServerUrl}"
}

function Get-ConfluenceRESTUrlBase
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.confluence.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-ConfluenceSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $ServerUrl = $(Get-Content $SecretFile -First 1)
    return "https://${ServerUrl}/rest/api/"
}

function Get-ConfluenceToken
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.confluence.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-ConfluenceSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    return $(Get-Content $SecretFile -First 2)[-1]
}

function Get-ConfluenceCreds
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.confluence.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-ConfluenceSecrets' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $Username = $(Get-Content $SecretFile -First 4)[2]
    $Password = $(Get-Content $SecretFile -First 4)[3]
    return "${Username}:${Password}"
}

function Invoke-ConfluenceLink
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

    $CredentialsPair = Get-ConfluenceCreds
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

function Invoke-ConfluenceREST
{
    [CmdletBinding()]
    param
    (
        [string] $Path,
        [string] $Method        = 'GET',
        [switch] $ShowRequestUri
    )

    $UrlBase                = Get-ConfluenceRESTUrlBase
    $CredentialsPair        = Get-ConfluenceCreds
    $EncodedCredentials     = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($CredentialsPair))

    $Headers    = @{
        'Authorization' = "Basic $EncodedCredentials"
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

function ConfluenceGetAllSpaces
{
    [CmdletBinding()]
    param
    (
        [string] $Path,
        [string] $Method        = 'GET',
        [switch] $ShowRequestUri
    )

    $UrlBase                = Get-ConfluenceUrlBase
    $CredentialsPair        = Get-ConfluenceCreds
    $EncodedCredentials     = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($CredentialsPair))

    $Headers    = @{
        'Authorization' = "Basic $EncodedCredentials"
        'Content-Type'=('application/json')

    };

    $FinalPath = "${UrlBase}/rest/api/${Path}"

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: ${FinalPath}" -ForegroundColor Yellow
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Method "${Method}" -Headers ${Headers} -Uri "${FinalPath}?per_page=100"

    $HasNext = $true
    $NextUrl   = "${FinalPath}?per_page=100"
    while ($HasNext)
    {
        # Write-Host "NEXT URI: ${NextUrl}" -ForegroundColor Yellow
        try
        {
            $RequestAnswer = Invoke-RestMethod -Method "${Method}" -Headers ${Headers} -Uri ${NextUrl}
        }
        catch
        {
            Write-Host `
                "Error: Gitlab group not found. Exiting..." `
                -ForegroundColor Red
            return
        }

        if ($RequestAnswer._links.next)
        {
            $NextUrl   = "${UrlBase}$($RequestAnswer._links.next)"
        }
        else
        {
            $HasNext = $false
        }

        # $Spaces = $RequestAnswer.results | ConvertFrom-Json
        $Spaces = $RequestAnswer.results
        Write-Output ${Spaces}
        # foreach ($space in $Spaces)
        # {
        #     # Write-Output ("{0}`t{1}" -f $subgroup.name,$subgroup.id)
        #     Write-Output ${space}
        # }
    }
#    return $Response
}
