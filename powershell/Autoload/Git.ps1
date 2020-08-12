<#
.SYNOPSIS
Git scripts.

.DESCRIPTION
Git scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


# Git:
if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
    # Main
    ${function:g}           = { git.exe @args }
    ${function:gunsec}      = { git.exe -c http.sslVerify=false @args }

    # Logs
    ${function:gll}         = { git.exe log --pretty=format:"%h - %an, %ar : %s" @args }
    ${function:glL}         = { git.exe log --pretty=format:"%H - %an, %ar : %s" @args }

    # Clone
    ${function:gcr}         = { git.exe clone --recurse-submodules @args }
    ${function:gcb}         = { git.exe clone --single-branch --branch @args }
    ${function:gcrb}        = { git.exe clone --recurse-submodules --single-branch --branch @args }

    # Look for satus or changes
    ${function:gs}          = { git.exe status @args }

    ${function:gw}          = { git.exe show @args }
    ${function:gw^}         = { git.exe show HEAD^ @args }
    ${function:gw^^}        = { git.exe show HEAD^^ @args }
    ${function:gw^^^}       = { git.exe show HEAD^^^ @args }
    ${function:gw^^^^}      = { git.exe show HEAD^^^^ @args }
    ${function:gw^^^^^}     = { git.exe show HEAD^^^^^ @args }

    ${function:gd}          = { git.exe diff HEAD @args } # What's changed? Both staged and unstaged.
    ${function:gdo}         = { git.exe diff --cached @args } # What's changed? Only staged (added) changes.

    # Add and Commit
    ${function:gco}         = { if ($args) {git.exe commit -m @args} else {git.exe commit -v}} # "git commit only"
    ${function:ga}          = { git.exe add @args }
    ${function:gca}         = { git.exe add --all; gco @args} # "git commit all"
    ${function:gcv}         = { git.exe commit -v @args }
    ${function:gcof}        = { git.exe commit --no-verify -m @args }
    ${function:gcaf}        = { (git.exe add --all) -and (gcof @args) }
    ${function:gam}         = { git.exe commit --amend @args }
    ${function:gamne}       = { git.exe commit --amend --no-edit @args }
    ${function:gamm}        = { git.exe add --all; git.exe commit --amend -C HEAD @args }
    ${function:gammf}       = { gamm --no-verify @args }

    # Cleanup
    ${function:gcoc}        = { gco Cleanup. @args }
    ${function:gcac}        = { gca Cleanup. @args }
    ${function:gcow}        = { gco Whitespace. @args }
    ${function:gcaw}        = { gca Whitespace. @args }
    ${function:gfr}         = { git.exe fetch --all; git.exe reset --hard origin/master @args }
    ${function:GClean}      = { while ((git diff-index HEAD --)) {git.exe reset --hard HEAD}; git.exe clean -d -x -f @args }
    ${function:GClean2}     = { while ((git diff-index HEAD --)) {git.exe reset --hard HEAD}; git.exe clean -d -f @args }

    # Pull
    ${function:gpl}         = { git.exe pull @args }
    ${function:gpls}        = { git.exe stash; git.exe pull @args; git.exe stash pop}
    ${function:gplm}        = { git.exe pull; git.exe submodule update }
    ${function:gplp}        = { git.exe pull --rebase; git.exe push @args } # Can't pull because you forgot to track? Run this.

    # Push
    # ${function:gp}        = { git.exe push @args }  # Comment if you use Get-Property and use gpp insted
    ${function:gpp}         = { git.exe push @args }
    ${function:gppu}        = { git.exe push -u @args }
    ${function:gppt}        = { git.exe push --tags @args }

    # Checkout
    ${function:gck}         = { git.exe checkout @args }
    ${function:gb}          = { git.exe checkout -b @args }
    ${function:got}         = { git.exe checkout - @args }
    ${function:gom}         = { git.exe checkout master @args }

    # Remove Branches
    ${function:gbr}         = { git.exe branch -d @args }
    ${function:gbrf}        = { git.exe branch -D @args }
    ${function:gbrr}        = { git.exe push origin --delete @args }
    ${function:gbrrm}       = { git.exe branch -D @args; git.exe push origin --delete @args }

    # Rebase
    ${function:gcp}         = { git.exe cherry-pick @args }
    ${function:grb}         = { git.exe rebase -i origin/master @args }
    ${function:gba}         = { git.exe rebase --abort @args }
    ${function:gbc}         = { git.exe add -A; git.exe rebase --continue @args }
    ${function:gbm}         = { git.exe fetch origin master; git.exe rebase origin/master @args }

    # Code-Review
    ${function:git-review}  = { if ($args[0] -and -Not $args[1]) {git.exe push origin HEAD:refs/for/@args[0]} else {Write-Host "Wrong command!`nUsage: git-review <branch_name>"}}
    ${function:grw}         = { git-review }

    # Tags
    ${function:grmt}        = { git.exe tag --delete @args }
    ${function:grmto}       = { git.exe push --delete origin @args }

    # Submodules
    ${function:gsu}         = { git.exe submodule update --recursive --remote @args }
    ${function:gsu2}        = { git.exe submodule foreach git pull origin master @args }

    # Misc
    ${function:gex}         = { GitExtensions.exe browse @args }
    ${function:ginfo}       = { ssh.exe gitolite@git info @args }   # Gitolite list repos

    # Accounts
    ${function:git-home}    = { git config --local user.name 'Dmitriy Ivanov';       git config --local user.email 'd.k.ivanov@live.com' }
    ${function:git-work}    = { git config --local user.name 'Dmitriy Ivanov';       git config --local user.email 'dmitriy.ivanov@ormco.com' }
    ${function:git-builder} = { git config --local user.name 'DEN-ORMCO-MSK-DevOps'; git config --local user.email 'DEN-ORMCO-MSK-DevOps@ormco.com' }

    ${function:gprune} = {
        [CmdletBinding()]
        Param
        (
            [string]$branch = "master"
        )

        $CurrentBranch = $(cmd /c "git rev-parse --abbrev-ref HEAD")
        # Stash changes
        cmd /c "git stash"
        # Checkout master:
        cmd /c "git checkout $branch"
        cmd /c "git fetch"
        # Run garbage collector
        cmd /c "git gc --prune=now"
        # Prune obsolete refs in 3 turns
        cmd /c "git remote prune origin"
        cmd /c "git fetch --prune"
        cmd /c "git remote prune origin"
        cmd /c "git fetch --prune"
        cmd /c "git remote prune origin"
        cmd /c "git fetch --prune"
        # Return to working branch
        cmd /c "git checkout $CurrentBranch"
        # Unstash work:
        cmd /c "git stash pop"
    }

    function ugr
    {
        Param
        (
            [Parameter(ValueFromRemainingArguments = $true)]
            [string]$Options = ""
        )

        $dir = Get-Location
        Get-ChildItem $dir -Directory | ForEach-Object {
            Write-Host $_.FullName
            Set-Location $_.FullName
            git.exe pull $Options
        }

        Set-Location $dir
    }

    function ugrm
    {
        ugr origin master
    }

    function ugrs
    {
        Param
        (
            [Parameter(ValueFromRemainingArguments = $true)]
            [string]$Options = ""
        )
        $dir = Get-Location
        Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugr $Options }
        Set-Location $dir
    }

    ${function:get_repo_with_target} = {
        if (-Not $args[0]){
            Write-Host "You should enter repo URI."
            Write-Host ( "Usage: {0} <repo_url>"  -f $MyInvocation.MyCommand )
            Write-Host
        } else {
            $scheme = python -c "from urllib.parse import urlparse; uri='$($args[0])'; result = urlparse(uri); print(result.scheme)"
            if ($scheme -eq "https") {
                $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
            } else {
                $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
            }
            git clone --recurse-submodules "$($args[0])" "$target"
        }
    }
    ${function:grt}  = { get_repo_with_target @args }

    function Move-GitRepo
    {
        [CmdletBinding()]
        Param
        (
            [Parameter(Mandatory=$true)]
            [string]$From,
            [Parameter(Mandatory=$true)]
            [string]$To
        )
        [string] $SessionID = [System.Guid]::NewGuid()

        Invoke-Expression "git.exe clone --mirror $From $SessionID"
        $RepoDir  = (Join-Path $env:Temp $SessionID)
        Set-Location $RepoDir
        Invoke-Expression "git.exe push --mirror $To"
        Set-Location $env:Temp
        Remove-Item -Force -ErrorAction SilentlyContinue "$TempDir"
    }

    # TMP Get Chef cookbook
    # ${function:get_cbk} = { if (Test-Path "~/workspace/Chef/cookbooks"){ Set-Location "~/workspace/Chef/cookbooks"; git clone "gitolite@git.domain.com:chef/cookbooks/$($args[0].ToString()).git"; Set-Location "$($args[0].ToString())" } }
}

function Set-GitVerbosity
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$Button,
        [string]$Category='all'
    )
    switch ($Button) {
        ({$PSItem -eq 'On' -Or $PSItem -eq 'on'}) {
            if (($Category -eq 'curl') -Or ($Category -eq 'all')) {
                $Env:GIT_CURL_VERBOSE=1
                $Env:GIT_TRACE_CURL=1
            }
            if (($Category -eq 'trace') -Or ($Category -eq 'all')) {
                $Env:GIT_TRACE=1
            }
            if (($Category -eq 'pack') -Or ($Category -eq 'all')) {
                $Env:GIT_TRACE_PACK_ACCESS=1
            }
            if (($Category -eq 'packet') -Or ($Category -eq 'all')) {
                $Env:GIT_TRACE_PACKET=1
            }
            if (($Category -eq 'perf') -Or ($Category -eq 'all')) {
                $Env:GIT_TRACE_PERFORMANCE=1
            }
            if (($Category -eq 'setup') -Or ($Category -eq 'all')) {
                $Env:GIT_TRACE_SETUP=1
            }
            break
        }
        ({$PSItem -eq 'Off' -Or $PSItem -eq 'off'}){
            $Env:GIT_CURL_VERBOSE=0
            $Env:GIT_TRACE_CURL=0
            $Env:GIT_TRACE=0
            $Env:GIT_TRACE_PACK_ACCESS=0
            $Env:GIT_TRACE_PACKET=0
            $Env:GIT_TRACE_PERFORMANCE=0
            $Env:GIT_TRACE_SETUP=0
            break
        }
        default {
            Write-Host "ERROR: Wrong operation..." -ForegroundColor Red
            Write-Host "Usage: Git-Verbose <On|Off> [Category]" -ForegroundColor Red
            Write-Host "  Categories: curl, trace, pack, packet, perf" -ForegroundColor Red
        }
    }
}

function Show-Diff_Of_Git_Branches
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$Branch1,
        [Parameter(Mandatory=$true)]
        [string]$Branch2
    )

    git checkout Branch1
    git checkout Branch2

    git diff Branch1..Branch2
}

# Git analisys:
function Get-GitCommitsByAuthor
{
    [CmdletBinding()]
    Param
    (
        [string]$Author = "d-k-ivanov",
        [switch]$AllBranches
    )
    $cmd  = "git log "
    $cmd += "--pretty=format:'%Cred%h%Creset %C(bold blue)%an%C(reset) - %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' "
    $cmd += "--abbrev-commit --date=relative "

    if ($AllBranches) {
        $cmd += "--all "
    }

    $cmd += "--author $Author"
    Invoke-Expression $cmd
}

function git_rename_author
{
    git filter-branch --env-filter "export GIT_COMMITTER_NAME='Dmitriy Ivanov';export GIT_COMMITTER_EMAIL='d.k.ivanov@live.com';export GIT_AUTHOR_NAME='Dmitriy Ivanov';export GIT_AUTHOR_EMAIL='d.k.ivanov@live.com'" --tag-name-filter cat -- --branches --tags
}

function git_push_force
{
    git push --force --tags origin 'refs/heads/*'
}
