function Set-BitbucketOAuthCreds {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Client_id,
        [Parameter(Mandatory=$true)]
        [string]$Secret
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bitbucket.secrets')
    Add-Content $SecretFile "$Client_id"
    Add-Content $SecretFile "$Secret"
}

function Get-BitbucketOAuthToken {
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bitbucket.secrets')

    if (-Not (Test-Path -Path $SecretFile)) {
        Write-Host "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BitbucketOAuthCreds' for initialization. Exiting..." -ForegroundColor Red
        return
    }

    # $UriAuth    = 'https://bitbucket.org/site/oauth2/authorize'
    $UriToken   = 'https://bitbucket.org/site/oauth2/access_token'
    $Client_id  = $(Get-Content $SecretFile -First 1)
    $Secret     = $(Get-Content $SecretFile -First 2)[-1]

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Client_id,$Secret)))
    Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri $UriToken -Method Post -Body @{grant_type='client_credentials'}
}

function Invoke-BitbucketAPI {
    [CmdletBinding()]
    param (
        [string]$RequestPath,
        [string]$Type           = '/pullrequests',
        [string]$UriSuffix      = 'repositories/ormcornd/orthoplatform',
        [string]$APIVersion     = '2.0',
        [string]$Method         = 'GET'
    )
    $Token = Get-BitbucketOAuthToken
    Write-Host "Request URI: https://api.bitbucket.org/2.0/$UriSuffix$Type$RequestPath" -ForegroundColor Yellow
    $Response = Invoke-RestMethod -Headers @{Authorization=("Bearer {0}" -f $Token.access_token)} -Uri "https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath" -Method $Method
    return $Response
}

function Get-BitbucketPR {
    [CmdletBinding()]
    param (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI -RequestPath "/$PR"
    return $Response
}

function Get-BitbucketUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AccountID
    )
    $Response = Invoke-BitbucketAPI -Type "/$AccountID" -UriSuffix 'users'
    return $Response
}

function Get-BitbucketWikiPage {
    [CmdletBinding()]
    param (
        [string]$WikiPage = 'Code Reviewers'
    )
    $Response = Invoke-BitbucketAPI -RequestPath "/$WikiPage" -Type '/wiki' -APIVersion '1.0'
    return $Response
}
