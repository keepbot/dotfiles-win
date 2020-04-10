${function:git-ssh-bb}  = { (Get-Content .gitmodules).replace('https://bitbucket.org/', 'git@bitbucket.org:') | Set-Content .gitmodules }
${function:git-ssh-bbr} = { (Get-Content .gitmodules).replace('git@bitbucket.org:', 'https://bitbucket.org/') | Set-Content .gitmodules }

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
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Uri $UriToken -Method Post -Body @{grant_type='client_credentials'}
}

function Invoke-BitbucketAPI-Simple {
    [CmdletBinding()]
    param (
        [string]$Request,
        [string]$Body           = $Null,
        [string]$APIVersion     = '2.0',
        [string]$Method         = 'GET'
    )
    $Token = Get-BitbucketOAuthToken
    $Headers = @{
        'Authorization'=("Bearer {0}" -f $Token.access_token)
        'Content-Type'=('application/json')

    };
    Write-Host "Request URI: https://api.bitbucket.org/$APIVersion/$Request" -ForegroundColor Yellow
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Headers $Headers -Uri "https://api.bitbucket.org/$APIVersion/$Request" -Method $Method
    return $Response
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
    Write-Host "Request URI: https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath" -ForegroundColor Yellow
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Headers @{Authorization=("Bearer {0}" -f $Token.access_token)} -Uri "https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath" -Method $Method
    return $Response
}

function Invoke-BitbucketURI {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$URI,
        [string]$Method = 'GET'
    )
    $Token = Get-BitbucketOAuthToken
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Headers @{Authorization=("Bearer {0}" -f $Token.access_token)} -Uri "$URI" -Method $Method
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

function Get-BitbucketTeamMembers {
    [CmdletBinding()]
    param (
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

function List-BitbucketTeamMembers {
    [CmdletBinding()]
    param (
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

function Get-BitbucketWikiPage {
    # DEPRECATED API
    [CmdletBinding()]
    param (
        [string]$WikiPage = 'Code Reviewers'
    )
    # https://bitbucket.org/ormcornd/orthoplatform/wiki/Protected_branches
    $Response = Invoke-BitbucketAPI -RequestPath "/$WikiPage" -Type '/wiki' -APIVersion '1.0'
    return $Response
}

if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:list_bb_user_repos_https} = {
        Write-Host "Listing all Bitbucket repos of $($args[0])"
        $repoList = Invoke-BitbucketURI "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        $count = 0
        do {
            foreach($repo in $repoList.values){
                $count += 1
                Write-Output "$count. $($repo.full_name)"
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketURI "$($repoList.next)"))
    }

    ${function:get_bb_user_repos_https} = {
        Write-Host "Get all Bitbucket repos of $($args[0]) via HTTPS"
        $repoList = Invoke-BitbucketURI "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        do {
            foreach($repo in $repoList.values){
                $response = Invoke-BitbucketURI "https://api.bitbucket.org/2.0/repositories/$($repo.full_name)"
                git.exe clone --recurse-submodules $(($response.links.clone | Where-Object {$_.name -eq 'https'}).href)
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketURI "$($repoList.next)"))
    }

    ${function:get_bb_user_repos_ssh} = {
        Write-Host "Get all Bitbucket repos of $($args[0]) via SSH"
        $repoList = Invoke-BitbucketURI "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        do {
            foreach($repo in $repoList.values){
                $response = Invoke-BitbucketURI "https://api.bitbucket.org/2.0/repositories/$($repo.full_name)"
                git.exe clone --recurse-submodules $(($response.links.clone | Where-Object {$_.name -eq 'ssh'}).href)
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketURI "$($repoList.next)"))
    }
}
