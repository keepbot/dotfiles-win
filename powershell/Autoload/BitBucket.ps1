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

${function:git-ssh-bb}  = { (Get-Content .gitmodules).replace('https://bitbucket.org/', 'git@bitbucket.org:') | Set-Content .gitmodules }
${function:git-ssh-bbr} = { (Get-Content .gitmodules).replace('git@bitbucket.org:', 'https://bitbucket.org/') | Set-Content .gitmodules }

function Set-BitbucketOAuthCreds
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Client_id,
        [Parameter(Mandatory=$true)]
        [string]$Secret
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bitbucket.secrets')
    Set-Content $SecretFile "$Client_id"
    Add-Content $SecretFile "$Secret"
}

function Get-BitbucketOAuthToken
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bitbucket.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BitbucketOAuthCreds' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    # $UriAuth    = 'https://bitbucket.org/site/oauth2/authorize'
    $UriToken   = 'https://bitbucket.org/site/oauth2/access_token'
    $Client_id  = $(Get-Content $SecretFile -First 1)
    $Secret     = $(Get-Content $SecretFile -First 2)[-1]

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Client_id,$Secret)))
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $OAuthToken = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri $UriToken -Method Post -Body @{grant_type='client_credentials'}
    return $OAuthToken
}

function Get-BitbucketOAuthTokenCurl
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.bitbucket.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BitbucketOAuthCreds' for initialization. Exiting..." -ForegroundColor Red
        return
    }

    # $UriAuth    = 'https://bitbucket.org/site/oauth2/authorize'
    $UriToken   = 'https://bitbucket.org/site/oauth2/access_token'
    $Client_id  = $(Get-Content $SecretFile -First 1)
    $Secret     = $(Get-Content $SecretFile -First 2)[-1]

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Client_id,$Secret)))
    $Response = (curl.exe -k -X POST -H "Authorization: Basic ${base64AuthInfo})" $UriToken -d "grant_type=client_credentials" -s) | ConvertFrom-Json
    return $Response.access_token
}

function Invoke-BitbucketAPIUri
{
    [CmdletBinding()]
    param
    (
        [string] $Uri,
        [string] $Method        = 'GET',
        [switch] $ShowRequestUri
    )

    $Token = Get-BitbucketOAuthToken
    $Headers = @{
        'Authorization'=("Bearer {0}" -f $Token.access_token)
        'Content-Type'=('application/json')

    };

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: $Uri" -ForegroundColor Yellow
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Headers $Headers -Uri $Uri -Method $Method
    return $Response
}

function Invoke-BitbucketAPIUri-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $Uri,
        [string] $Method            = 'GET',
        [string[]] $CurlArgs        = @('-s'),
        [switch] $VerboseOutput,
        [switch] $ShowRequestUri
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $Token = Get-BitbucketOAuthTokenCurl
    $Headers = "Authorization: Bearer ${Token}; Content-Type: application/json"

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: $Uri" -ForegroundColor Yellow
    }

    $Response = (curl.exe -k -X ${Method} -H ${Headers} ${Uri} ${CurlArgs})
    return $Response
}

function Invoke-BitbucketAPI-Simple
{
    [CmdletBinding()]
    param
    (
        [string] $Request,
        [string] $APIVersion        = '2.0',
        [string] $Method            = 'GET'
    )

    $Token = Get-BitbucketOAuthToken
    $Headers = @{
        'Authorization'=("Bearer {0}" -f $Token.access_token)
        'Content-Type'=('application/json')

    };

    $Uri = "https://api.bitbucket.org/$APIVersion/$Request"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-BitbucketAPIUri -Uri $Uri -Method $Method -ShowRequestUri
    return $Response
}

function Invoke-BitbucketAPI-Simple-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $Request,
        [string] $APIVersion        = '2.0',
        [string] $Method            = 'GET',
        [string[]] $CurlArgs        = @('-s'),
        [switch] $VerboseOutput
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $Uri = "https://api.bitbucket.org/$APIVersion/$Request"
    $Response = Invoke-BitbucketAPIUri-Curl -Uri $Uri -Method $Method -CurlArgs $CurlArgs -ShowRequestUri
    return $Response
}

function Invoke-BitbucketAPI
{
    [CmdletBinding()]
    param
    (
        [string]$RequestPath,
        [string]$Type           = '/pullrequests',
        [string]$UriSuffix      = 'repositories/ormcornd/orthoplatform',
        [string]$APIVersion     = '2.0',
        [string]$Method         = 'GET'
    )

    $Uri = "https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-BitbucketAPIUri -Uri $Uri -Method $Method -ShowRequestUri
    return $Response
}

function Invoke-BitbucketAPI-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $RequestPath,
        [string] $Type              = '/pullrequests',
        [string] $UriSuffix         = 'repositories/ormcornd/orthoplatform',
        [string] $APIVersion        = '2.0',
        [string] $Method            = 'GET',
        [string[]] $CurlArgs        = @('-s'),
        [switch] $VerboseOutput
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $Uri = "https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath"

    $Response = Invoke-BitbucketAPIUri-Curl -Uri $Uri -Method $Method -CurlArgs $CurlArgs -ShowRequestUri
    return $Response
}

function Get-BitbucketPR
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI -RequestPath "/$PR"
    return $Response
}

function Get-BitbucketPR-Curl
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI-Curl -RequestPath "/$PR"
    return $Response
}

function Get-BitbucketPRComments
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI -RequestPath "/$PR/comments"
    return $Response
}

function Get-BitbucketPRDiff
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    # $DiffLink = (Invoke-BitbucketAPI -RequestPath "/$PR").links.diff.href
    # $Response = Invoke-BitbucketURI $DiffLink
    # try
    # {
    #     $Response = Invoke-BitbucketAPI -RequestPath "/$PR/diff"
    # }
    # catch
    # {
    #     # Dig into the exception to get the Response details.
    #     # Note that value__ is not a typo.
    #     # Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
    #     # Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    #     $_.Exception.Response | FL
    # }

    try
    {
        $Response = Invoke-BitbucketAPI -RequestPath "/$PR/diff"
    }
    catch
    {
        $_.Exception.Response.Headers | Format-List
        if (($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "302"))
        {
            $Response = Invoke-BitbucketAPIUri $_.Exception.Response.Headers.Location.AbsoluteUri
        }
        else
        {
            throw $_
        }
    }
    return $Response
}

function Get-BitbucketUser
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$AccountID
    )
    $Response = Invoke-BitbucketAPI -Type "/$AccountID" -UriSuffix 'users'
    return $Response
}

function Get-BitbucketUser-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$AccountID
    )
    $Response = Invoke-BitbucketAPI-Curl -Type "/$AccountID" -UriSuffix 'users'
    return $Response
}

function Get-BitbucketTeamMembers
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :


    $Response = Invoke-BitbucketAPI -Type "/${Team}/members?pagelen=100" -UriSuffix 'teams'
    return $Response
}

function Get-BitbucketTeamMembers-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :


    $Response = Invoke-BitbucketAPI-Curl -Type "/${Team}/members?pagelen=100" -UriSuffix 'teams'
    return $Response
}

function Show-BitbucketTeamMembers
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :


    $Response = Get-BitbucketTeamMembers "${Team}"
    return $Response.values | Format-Table -Property display_name,has_2fa_enabled,nickname,account_id,account_status,uuid -AutoSize
}

function Show-BitbucketTeamMembers-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :

    $Response = Get-BitbucketTeamMembers-Curl "${Team}"
    # $Response = Get-BitbucketTeamMembers-Curl "${Team}" -VerboseOutput | ConvertFrom-Json
    # return $Response.values | Format-Table -Property display_name,has_2fa_enabled,nickname,account_id,account_status,uuid -AutoSize
}

function Get-BitbucketWikiPage
{
    # DEPRECATED API
    [CmdletBinding()]
    param
    (
        [string]$WikiPage = 'Code Reviewers'
    )
    # https://bitbucket.org/ormcornd/orthoplatform/wiki/Protected_branches
    $Response = Invoke-BitbucketAPI -RequestPath "/$WikiPage" -Type '/wiki' -APIVersion '1.0'
    return $Response
}

if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:list_bb_user_repos} = {
        Write-Host "Listing all Bitbucket repos of $($args[0])" -ForegroundColor Magenta
        $repoList = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        $count = 0
        do
        {
            foreach ($repo in $repoList.values)
            {
                $count += 1
                Write-Host "$count.`t" -NoNewLine
                Write-Host "$($repo.full_name)" -ForegroundColor Cyan
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketAPIUri "$($repoList.next)"))
    }

    ${function:get_bb_user_repos_https} = {
        Write-Host "Get all Bitbucket repos of $($args[0]) via HTTPS"
        $repoList = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        do
        {
            foreach ($repo in $repoList.values)
            {
                $response = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($repo.full_name)"
                git.exe clone --recurse-submodules $(($response.links.clone | Where-Object {$_.name -eq 'https'}).href)
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketAPIUri "$($repoList.next)"))
    }

    ${function:get_bb_user_repos_ssh} = {
        Write-Host "Get all Bitbucket repos of $($args[0]) via SSH"
        $repoList = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        do
        {
            foreach ($repo in $repoList.values)
            {
                $response = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($repo.full_name)"
                git.exe clone --recurse-submodules $(($response.links.clone | Where-Object {$_.name -eq 'ssh'}).href)
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketAPIUri "$($repoList.next)"))
    }
}
