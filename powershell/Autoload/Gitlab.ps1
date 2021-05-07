<#
.SYNOPSIS
Gitlab scripts.

.DESCRIPTION
Gitlab scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyBaseCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Set-GitlabToken
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Token
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.gitlab.secrets')
    Set-Content $SecretFile "$Token"
}

function Get-GitlabToken
{
    [string] $SecretFile   = (Join-Path $env:USERPROFILE '.gitlab.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-GitlabToken' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    $Token   = $(Get-Content $SecretFile -First 1)
    return $Token
}

function GitlabListSubgroups
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FileName',
        Justification = 'False positive as rule does not know that ForEach-Object operates within the same scope')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $GitlabUrl,
        [Parameter(Mandatory=$true)]
        [string] $GitlabGroup
    )

    $GitlabToken = Get-GitlabToken
    $Headers = @{
        'PRIVATE-TOKEN'=("{0}" -f $GitlabToken)
    };

    $BaseApiUri = "https://${GitlabUrl}/api/v4/groups/${GitlabGroup}/subgroups"

    Write-Host "Showing Gitlab subgroups for ${GitlabGroup} on ${GitlabUrl}"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $HasNext = $true
    $NextUrl   = "${BaseApiUri}?per_page=100"
    while ($HasNext)
    {
        try
        {
            $RequestAnswer = Invoke-WebRequest -Headers $Headers -Uri $NextUrl
        }
        catch
        {
            Write-Host `
                "Error: Gitlab group not found. Exiting..." `
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
        foreach ($subgroup in $Repos)
        {
            Write-Output ("{0}`t{1}" -f $subgroup.name,$subgroup.id)
        }
    }
}

function GitlabRepos
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $GitlabUrl,
        [Parameter(Mandatory=$true)]
        [string] $GitlabGroup,
        [string] $Protocol = 'SSH',
        [switch] $Group,
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

    $GitlabToken = Get-GitlabToken
    $Headers = @{
        'PRIVATE-TOKEN'=("{0}" -f $GitlabToken)
    };

    if ($Group)
    {
        $BaseApiUri = "https://${GitlabUrl}/api/v4/groups/${GitlabGroup}/projects"
    }
    else
    {
        $BaseApiUri = "https://${GitlabUrl}/api/v4/projects"
    }

    if ($Clone)
    {
        Write-Host "Clonning Gitlab repos on ${GitlabUrl}"
        $BaseCommand = "git clone --recurse-submodules "
    }
    else
    {
        Write-Host "Showing Gitlab repos on ${GitlabUrl}"
        $BaseCommand = "Write-Output "
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $HasNext = $true
    $NextUrl   = "${BaseApiUri}?order_by=updated_at&sort=desc&per_page=100"
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
                "Error: Gitlab group not found. Exiting..." `
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
                "HTTPS" { Invoke-Expression ($BaseCommand + $repo.http_url_to_repo) }
                "SSH"   { Invoke-Expression ($BaseCommand + $repo.ssh_url_to_repo)  }
                "WEB"   { Invoke-Expression ($BaseCommand + $repo.web_url)          }
            }
        }
    }
}
Set-Alias gitlab_repos GitlabRepos
