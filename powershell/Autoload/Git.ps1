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
if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path)
{
    # Main
    ${function:g}           = { git.exe @args }
    ${function:gg}          = { git.exe -c core.pager='delta --features=code-review-theme' @args }
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
    ${function:gss}         = { git.exe status @args }

    ${function:gw}          = { git.exe show @args              }
    ${function:gw^}         = { git.exe show HEAD^ @args        }
    ${function:gww}         = { git.exe show HEAD^ @args        }
    ${function:gw^^}        = { git.exe show HEAD^^ @args       }
    ${function:gwww}        = { git.exe show HEAD^^ @args       }
    ${function:gw^^^}       = { git.exe show HEAD^^^ @args      }
    ${function:gwwww}       = { git.exe show HEAD^^^ @args      }
    ${function:gw^^^^}      = { git.exe show HEAD^^^^ @args     }
    ${function:gwwwww}      = { git.exe show HEAD^^^^ @args     }
    ${function:gw^^^^^}     = { git.exe show HEAD^^^^^ @args    }
    ${function:gwwwwww}     = { git.exe show HEAD^^^^^ @args    }
    ${function:gw^^^^^^}    = { git.exe show HEAD^^^^^^ @args   }
    ${function:gwwwwwww}    = { git.exe show HEAD^^^^^^ @args   }
    ${function:gw^^^^^^^}   = { git.exe show HEAD^^^^^^^ @args  }
    ${function:gwwwwwwww}   = { git.exe show HEAD^^^^^^^ @args  }
    ${function:gw^^^^^^^^}  = { git.exe show HEAD^^^^^^^^ @args }
    ${function:gwwwwwwwww}  = { git.exe show HEAD^^^^^^^^ @args }

    ${function:ggw}         = { git.exe -c core.pager='delta --features=code-review-theme' show @args              }
    ${function:ggw^}        = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^ @args        }
    ${function:ggww}        = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^ @args        }
    ${function:ggw^^}       = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^ @args       }
    ${function:ggwww}       = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^ @args       }
    ${function:ggw^^^}      = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^ @args      }
    ${function:ggwwww}      = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^ @args      }
    ${function:ggw^^^^}     = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^ @args     }
    ${function:ggwwwww}     = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^ @args     }
    ${function:ggw^^^^^}    = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^ @args    }
    ${function:ggwwwwww}    = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^ @args    }
    ${function:ggw^^^^^^}   = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^^ @args   }
    ${function:ggwwwwwww}   = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^^ @args   }
    ${function:ggw^^^^^^^}  = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^^^ @args  }
    ${function:ggwwwwwwww}  = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^^^ @args  }
    ${function:ggw^^^^^^^^} = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^^^^ @args }
    ${function:ggwwwwwwwww} = { git.exe -c core.pager='delta --features=code-review-theme' show HEAD^^^^^^^^ @args }

    ${function:gd}          = { git.exe diff HEAD @args }
    ${function:ggd}         = { git.exe -c core.pager='delta --features=code-review-theme' diff HEAD @args }
    ${function:gdo}         = { git.exe diff --cached @args }

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
    ${function:gfr}         = { git.exe fetch --all; git.exe reset --hard @args }
    ${function:gfrmn}       = { git.exe fetch --all; git.exe reset --hard origin/main @args }
    ${function:gfrms}       = { git.exe fetch --all; git.exe reset --hard origin/master @args }
    ${function:GClean}      = { while ((git diff-index HEAD --)) {git.exe reset --hard HEAD}; git.exe clean -d -x -f @args }
    ${function:GClean2}     = { while ((git diff-index HEAD --)) {git.exe reset --hard HEAD}; git.exe clean -d -f @args }

    # Pull
    ${function:gpl}         = { git.exe pull origin $(git.exe rev-parse --abbrev-ref HEAD) }
    ${function:gplmn}       = { git.exe pull origin main }
    ${function:gplms}       = { git.exe pull origin master }
    ${function:gpls}        = { git.exe stash; git.exe pull @args; git.exe stash pop}
    ${function:gplm}        = { git.exe pull; git.exe submodule update }
    ${function:gplp}        = { git.exe pull --rebase; git.exe push @args } # Can't pull because you forgot to track? Run this.

    # Push
    # ${function:gp}        = { git.exe push @args }  # Comment if you use Get-Property and use gpp insted
    ${function:gpp}         = { git.exe push @args }
    ${function:gppg}        = { git.exe push github @args }
    ${function:gppf}        = { git.exe push --force @args }
    ${function:gppu}        = { git.exe push -u @args }
    ${function:gppt}        = { git.exe push --tags @args }

    # Checkout
    ${function:gck}         = { git.exe checkout @args }
    ${function:gb}          = { git.exe checkout -b @args }
    ${function:got}         = { git.exe checkout - @args }
    ${function:gomn}        = { git.exe checkout main @args }
    ${function:goms}        = { git.exe checkout master @args }

    # Remove Branches
    ${function:gbr}         = { git.exe branch -d @args }
    ${function:gbrf}        = { git.exe branch -D @args }
    ${function:gbrr}        = { git.exe push origin --delete @args }
    ${function:gbrrm}       = { git.exe branch -D @args; git.exe push origin --delete @args }
    ${function:g-to-main}   = { git.exe branch -m master main; git.exe fetch origin; git.exe branch -u origin/main main; git.exe remote set-head origin -a }

    # Rebase
    ${function:gcp}         = { git.exe cherry-pick @args }
    ${function:grb}         = { git.exe rebase -i origin/@args }
    ${function:grbmn}       = { git.exe rebase -i origin/main @args }
    ${function:grbms}       = { git.exe rebase -i origin/master @args }
    ${function:gba}         = { git.exe rebase --abort @args }
    ${function:gbc}         = { git.exe add -A; git.exe rebase --continue @args }
    ${function:gbmn}        = { git.exe fetch origin main; git.exe rebase origin/main @args }
    ${function:gbms}        = { git.exe fetch origin master; git.exe rebase origin/master @args }

    # Code-Review
    ${function:git-review}  = { if ($args[0] -and -Not $args[1]) {git.exe push origin HEAD:refs/for/@args[0]} else {Write-Host "Wrong command!`nUsage: git-review <branch_name>"}}
    ${function:grw}         = { git-review }

    # Tags
    ${function:grmt}        = { git.exe tag --delete @args }
    ${function:grmto}       = { git.exe push --delete origin @args }

    # Submodules
    ${function:gsu}         = { git.exe submodule update --recursive --remote @args }
    ${function:gsumn}       = { git.exe submodule foreach git pull origin main @args }
    ${function:gsums}       = { git.exe submodule foreach git pull origin master @args }

    # Misc
    ${function:gex}         = { GitExtensions.exe browse @args }
    ${function:ginfo}       = { ssh.exe gitolite@git info @args }   # Gitolite list repos

    # Accounts
    ${function:git-home}    = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'd.k.ivanov@live.com' }

    # EPAM
    ${function:git-epam}    = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'dmitry_ivanov3@epam.com' }

    # Hermes
    ${function:git-hermes}  = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'dmitry.ivanov@hermes-europe.co.uk' }

    # IRQ
    ${function:git-irq}     = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'divanov@irq.ru' }

    function gprune
    {
        [CmdletBinding()]
        param
        (
            [string]$branch = "main"
        )

        $CurrentBranch = $(cmd /c "git rev-parse --abbrev-ref HEAD")
        # Stash changes
        cmd /c "git stash"
        # Checkout primary branch:
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
        param
        (
            [Parameter(ValueFromRemainingArguments = $true)]
            [string]$Options = ""
        )

        $dir = Get-Location
        Get-ChildItem $dir -Directory | ForEach-Object {
            Write-Host $_.FullName
            Set-Location $_.FullName
            & git.exe pull $Options
        }

        Set-Location $dir
    }

    function ugrf
    {
        param
        (
            [Parameter(ValueFromRemainingArguments = $true)]
            [string]$Options = ""
        )

        $dir = Get-Location
        Get-ChildItem $dir -Directory | ForEach-Object {
            Write-Host $_.FullName
            Set-Location $_.FullName
            & git.exe fetch $Options
        }

        Set-Location $dir
    }

    function ugrmn
    {
        ugr origin main
    }

    function ugrms
    {
        ugr origin master
    }

    function ugrs
    {
        param
        (
            [Parameter(ValueFromRemainingArguments = $true)]
            [string]$Options = ""
        )
        $dir = Get-Location
        Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugr $Options }
        Set-Location $dir
    }

    function ugrfs
    {
        param
        (
            [Parameter(ValueFromRemainingArguments = $true)]
            [string]$Options = ""
        )
        $dir = Get-Location
        Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugrf $Options }
        Set-Location $dir
    }

    function get_repo_with_target
    {
        if (-Not $args[0])
        {
            Write-Host "You should enter repo URI."
            Write-Host ( "Usage: {0} <repo_url>"  -f $MyInvocation.MyCommand )
            Write-Host
        }
        else
        {
            $scheme = python -c "from urllib.parse import urlparse; uri='$($args[0])'; result = urlparse(uri); print(result.scheme)"
            if ($scheme -eq "https")
            {
                $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
            }
            else
            {
                $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
            }
            git clone --recurse-submodules "$($args[0])" "$target"
        }
    }
    ${function:grt} = { get_repo_with_target @args }

    function Move-GitRepo
    {
        [CmdletBinding()]
        param
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
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Button,
        [string]$Category='all'
    )
    switch ($Button)
    {
        ({$PSItem -eq 'On' -Or $PSItem -eq 'on'})
        {
            if (($Category -eq 'curl') -Or ($Category -eq 'all'))
            {
                $Env:GIT_CURL_VERBOSE=1
                $Env:GIT_TRACE_CURL=1
            }
            if (($Category -eq 'trace') -Or ($Category -eq 'all'))
            {
                $Env:GIT_TRACE=1
            }
            if (($Category -eq 'pack') -Or ($Category -eq 'all'))
            {
                $Env:GIT_TRACE_PACK_ACCESS=1
            }
            if (($Category -eq 'packet') -Or ($Category -eq 'all'))
            {
                $Env:GIT_TRACE_PACKET=1
            }
            if (($Category -eq 'perf') -Or ($Category -eq 'all'))
            {
                $Env:GIT_TRACE_PERFORMANCE=1
            }
            if (($Category -eq 'setup') -Or ($Category -eq 'all'))
            {
                $Env:GIT_TRACE_SETUP=1
            }
            break
        }
        ({$PSItem -eq 'Off' -Or $PSItem -eq 'off'})
        {
            $Env:GIT_CURL_VERBOSE=0
            $Env:GIT_TRACE_CURL=0
            $Env:GIT_TRACE=0
            $Env:GIT_TRACE_PACK_ACCESS=0
            $Env:GIT_TRACE_PACKET=0
            $Env:GIT_TRACE_PERFORMANCE=0
            $Env:GIT_TRACE_SETUP=0
            break
        }
        default
        {
            Write-Host "ERROR: Wrong operation..." -ForegroundColor Red
            Write-Host "Usage: Git-Verbose <On|Off> [Category]" -ForegroundColor Red
            Write-Host "  Categories: curl, trace, pack, packet, perf" -ForegroundColor Red
        }
    }
}

function Show-Diff_Of_Git_Branches
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Branch1,
        [Parameter(Mandatory=$true)]
        [string]$Branch2
    )

    git checkout $Branch1
    git checkout $Branch2

    git diff ${Branch1}..${Branch2}
}

# Git analisys:
function Get-GitCommitsByAuthor
{
    [CmdletBinding()]
    param
    (
        [string]$Author = "d-k-ivanov",
        [switch]$AllBranches
    )
    $cmd  = "git log "
    $cmd += "--pretty=format:'%Cred%h%Creset %C(bold blue)%an%C(reset) - %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' "
    $cmd += "--abbrev-commit --date=relative "

    if ($AllBranches)
    {
        $cmd += "--all "
    }

    $cmd += "--author $Author"
    Invoke-Expression $cmd
}

function git_rename_author
{
    git filter-branch -f --env-filter "export GIT_COMMITTER_NAME='Dmitry Ivanov';export GIT_COMMITTER_EMAIL='d.k.ivanov@live.com';export GIT_AUTHOR_NAME='Dmitry Ivanov';export GIT_AUTHOR_EMAIL='d.k.ivanov@live.com'" --tag-name-filter cat -- --branches --tags
}

function git_change_email_in_my_commits
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$OldMail,
        [string]$NewMail = 'd.k.ivanov@live.com',
        [string]$GitName = 'Dmitry Ivanov'

    )

    git filter-branch --env-filter "                            `
        OLD_EMAIL='${OldMail}';                                 `
        GIT_NAME='${GitName}';                                  `
        NEW_EMAIL='${NewMail}';                                 `
        if [ '$GIT_COMMITTER_EMAIL' = '$OLD_EMAIL' ]; then;     `
            export GIT_COMMITTER_NAME="$GIT_NAME";              `
            export GIT_COMMITTER_EMAIL="$NEW_EMAIL";            `
        fi;                                                     `
        if [ '$GIT_AUTHOR_EMAIL' = '$OLD_EMAIL' ]; then;        `
            export GIT_AUTHOR_NAME='$GIT_NAME';                 `
            export GIT_AUTHOR_EMAIL='$NEW_EMAIL';               `
        fi;                                                     `
    " --tag-name-filter cat -- --branches --tags
}



function git_push_force
{
    git push --force --tags origin 'refs/heads/*'
}

function git_remove_file_from_history
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $File
    )
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $File" --prune-empty --tag-name-filter cat -- --all
}

function git_dangling_show
{
    git fsck --full
}

function git_dangling_fix
{
    git reflog expire --expire=now --all
    git gc --prune=now
}

function git_upstream
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Upstream
    )
    git branch --set-upstream-to=origin/${Upstream} ${Upstream}
}

#TODO: Add implementation
function Remove-GitSubmodule
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $SubmoduleName
    )

    if (-Not (Test-Path '.\\.gitmodules'))
    {
        Write-Host `
            "Error: Wrong directory. You should be in the root of git repo to use this function. Exiting..." `
            -ForegroundColor Red
        return
    }

    $gm_file = Get-Content '.\\.gitmodules'
    foreach ($line in $gm_file)
    {
        Write-Host $line
    }

    # 1. Delete the relevant section from the *.gitmodules* file.
    # [submodule "vendor"]
    # path = vendor
    # url = git://github.com/some-user/some-repo.git
    # 2. Stage the *.gitmodules* changes with following command:
    # git add .gitmodules
    # 3.Delete the relevant section from *.git/config*:
    # [submodule "vendor"]
    # url = git://github.com/some-user/some-repo.git
    # 4. Remove submodule folders from repo:
    # git rm --cached path/to/submodule
    # rm -rf .git/modules/submodule_name
    # 6. Commit changes
    # 7. Delete files
    # rm -rf path/to/submodule
}
