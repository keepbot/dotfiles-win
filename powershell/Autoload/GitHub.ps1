<#
.SYNOPSIS
GitHub scripts.

.DESCRIPTION
GitHub scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyBaseCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Set-GithubOAuthCreds
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Username,
        [Parameter(Mandatory=$true)]
        [string]$Token
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.github.secrets')
    Set-Content $SecretFile "$Username"
    Add-Content $SecretFile "$Token"
}

function Get-GithubBasicCreds
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.github.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-GitHubOAuthCreds' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $Username   = $(Get-Content $SecretFile -First 1)
    $Token      = $(Get-Content $SecretFile -First 2)[-1]

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username,$Token)))
    return $base64AuthInfo
}

function GithubRepos
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $GithubName,
        [string] $Protocol = 'SSH',
        [switch] $Organization,
        [switch] $All,
        [switch] $Clone
    )

    if (-Not (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path))
    {
        Write-Host `
                "Error: Git not found. Please install Git for Windows and add it to PATH. Exiting..." `
                -ForegroundColor Red
            return
    }

    $BasicCreds = Get-GithubBasicCreds
    $Headers = @{
        'Authorization'=("Basic {0}" -f $BasicCreds)
    };

    if ($Organization)
    {
        $BaseApiUri = "https://api.github.com/orgs/${GithubName}/repos"
    }
    else
    {
        $BaseApiUri = "https://api.github.com/users/${GithubName}/repos"
    }

    if ($Clone)
    {
        Write-Host "Clonning Github repos of ${GithubName}"
        $BaseCommand = "git clone --recurse-submodules "
    }
    else
    {
        Write-Host "Showing Github repos of ${GithubName}"
        $BaseCommand = "Write-Output "
    }


    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $HasNext = $true
    $NextUrl   = "${BaseApiUri}?sort=pushed&per_page=100"
    # for ($i = 1; $i -lt 2; $i++)
    while ($HasNext)
    {
        # Write-Output $NextUrl
        try
        {
            $RequestAnswer = Invoke-WebRequest -Headers $Headers -Uri $NextUrl
        }
        catch
        {
            Write-Host `
                "Error: Github user or organization not found. Exiting..." `
                -ForegroundColor Red
            return
        }

        if ($RequestAnswer.RelationLink["next"])
        {
            $NextUrl   = $RequestAnswer.RelationLink["next"]
        }
        else
        {
            $HasNext = $false
        }

        $Repos = $RequestAnswer | ConvertFrom-Json
        foreach ($repo in $Repos)
        {
            if ((-Not $All) -And $repo.fork) { continue }

            switch ($Protocol)
            {
                "GIT"   { Invoke-Expression ($BaseCommand + $repo.git_url)   }
                "HTTPS" { Invoke-Expression ($BaseCommand + $repo.clone_url) }
                "SSH"   { Invoke-Expression ($BaseCommand + $repo.ssh_url)   }
                "SVN"   { Invoke-Expression ($BaseCommand + $repo.svn_url)   }
            }
        }
    }
}
Set-Alias github_repos GithubRepos

function Rename-GitHub-Origin
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$NewName
    )
    Write-Output "Renaming repo to $NewName"
    $dir = Get-Location
    Get-ChildItem $dir -Directory | ForEach-Object {
        Write-Host $_.FullName
        Set-Location $_.FullName
        $oldRemote = git config --get remote.origin.url
        Write-Host "Old remote:"
        git remote -v
        $repo = Split-Path $oldRemote -leaf
        $newRemote = "git@github.com:${NewName}/${repo}"
        git remote rm origin
        git remote add origin ${newRemote}
        Write-Host "New remote:"
        # Write-Host $newRemote
        git remote -v
        Write-Host "------------------------------------------------------------"
    }
    Set-Location $dir
}
