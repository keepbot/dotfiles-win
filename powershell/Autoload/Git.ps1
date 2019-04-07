# Git:
if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:ugr} = { $dir = Get-Location; Get-ChildItem $dir -Directory | ForEach-Object { Write-Host $_.FullName; Set-Location $_.FullName; git.exe pull }; Set-Location $dir }
  ${function:ugrm} = { $dir = Get-Location; Get-ChildItem $dir -Directory | ForEach-Object { Write-Host $_.FullName; Set-Location $_.FullName; git.exe checkout master; git.exe pull }; cd $dir }
  ${function:ugrs} = { $dir = Get-Location; Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugr }; Set-Location $dir }
  ${function:gsu} = { git.exe submodule update --recursive --remote @args }
  ${function:gsu2} = { git.exe submodule foreach git pull origin master @args }
  ${function:gll} = { git.exe log --pretty=format:"%h - %an, %ar : %s" @args }
  ${function:glL} = { git.exe log --pretty=format:"%H - %an, %ar : %s" @args }
  ${function:g} = { git.exe @args }
  ${function:gcr} = { git.exe clone --recurse-submodules @args }
  ${function:gs} = { git.exe status @args }
  ${function:gw} = { git.exe show @args }
  ${function:gw^} = { git.exe show HEAD^ @args }
  ${function:gw^^} = { git.exe show HEAD^^ @args }
  ${function:gw^^^} = { git.exe show HEAD^^^ @args }
  ${function:gw^^^^} = { git.exe show HEAD^^^^ @args }
  ${function:gw^^^^^} = { git.exe show HEAD^^^^^ @args }
  ${function:gd} = { git.exe diff HEAD @args } # What's changed? Both staged and unstaged.
  ${function:gdo} = { git.exe diff --cached @args } # What's changed? Only staged (added) changes.
  ${function:gco} = { if ($args) {git.exe commit -m @args} else {git.exe commit -v}} # "git commit only"
  ${function:gca} = { git.exe add --all; gco @args} # "git commit all"
  ${function:ga} = { git.exe add @args }
  ${function:gcv} = { git.exe commit -v @args }
  ${function:gcof} = { git.exe commit --no-verify -m @args }
  ${function:gcaf} = { (git.exe add --all) -and (gcof @args) }
  ${function:gcac} = { gca Cleanup. @args }
  ${function:gcoc} = { gco Cleanup. @args }
  ${function:gcaw} = { gca Whitespace. @args }
  ${function:gcow} = { gco Whitespace. @args }
  # ${function:gp} = { git.exe push }  # Comment if you use Get-Property and use gpp insted
  ${function:gpl} = { git.exe pull @args }
  ${function:gplp} = { git.exe pull --rebase; git.exe push @args } # Can't pull because you forgot to track? Run this.
  ${function:gpp} = { git.exe push }
  ${function:gppt} = { git.exe push --tags}
  ${function:gppu} = { git.exe push -u @args }
  ${function:gck} = { git.exe checkout @args }
  ${function:gb} = { git.exe checkout -b @args }
  ${function:got} = { git.exe checkout - @args }
  ${function:gom} = { git.exe checkout master @args }
  ${function:grb} = { git.exe rebase -i origin/master @args }
  ${function:gbr} = { git.exe branch -d @args }
  ${function:gbrf} = { git.exe branch -D @args }
  ${function:gbrr} = { git.exe push origin --delete @args }
  ${function:gcp} = { git.exe cherry-pick @args }
  ${function:gam} = { git.exe commit --amend @args }
  ${function:gamne} = { git.exe commit --amend --no-edit @args }
  ${function:gamm} = { git.exe add --all; git.exe commit --amend -C HEAD @args }
  ${function:gammf} = { gamm --no-verify @args }
  ${function:gba} = { git.exe rebase --abort @args }
  ${function:gbc} = { git.exe add -A; git.exe rebase --continue @args }
  ${function:gbm} = { git.exe fetch origin master; git.exe rebase origin/master @args }
  ${function:gfr} = { git.exe fetch --all; git.exe reset --hard origin/master @args }
  ${function:GClean} = { while ((git diff-index HEAD --)) {git.exe reset --hard HEAD}; git.exe clean -d -x -f @args }
  ${function:git-review} = { if ($args[0] -and -Not $args[1]) {git.exe push origin HEAD:refs/for/@args[0]} else {Write-Host "Wrong command!`nUsage: git-review <branch_name>"}}
  ${function:grw} = { git-review }
  ${function:git-home} = { git config --local user.email "d.k.ivanov@live.com" }
  ${function:git-work} = { git config --local user.email "dmitriy.ivanov@ormco.com" }
  ${function:git-ssh-bb}={ (Get-Content .gitmodules).replace('https://bitbucket.org/', 'git@bitbucket.org:') | Set-Content .gitmodules }
  ${function:git-ssh-bbr}={ (Get-Content .gitmodules).replace('git@bitbucket.org:', 'https://bitbucket.org/') | Set-Content .gitmodules }
  ${function:grmt} = { git.exe tag --delete @args }
  ${function:grmto} = { git.exe push --delete origin @args }
  ${function:gunsec} = { git.exe -c http.sslVerify=false @args }

  ${function:gprune} = {
    $CurrentBranch = $(cmd /c "git rev-parse --abbrev-ref HEAD")

    # Stash changes
    cmd /c "git stash"

    # Checkout master:
    cmd /c "git checkout master"
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

  # GitHub
  ${function:get_gh_user_repos_https} = {
    Write-Host "Clonning all GH repos of $($args[0])"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?per_page=1000" | ConvertFrom-Json
    foreach( $repo in $repoList.clone_url){
      git.exe clone $repo
    }
  }

  ${function:get_gh_user_repos_ssh} = {
    Write-Host "Clonning all GH repos of $($args[0])"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?per_page=1000" | ConvertFrom-Json
    foreach( $repo in $repoList.ssh_url){
      git.exe clone $repo
    }
  }

  ${function:get_repo_with_target} = {
    if (-Not $args[0]){
      Write-Host "You should enter repo URI."
      Write-Host ( "Usage: {0} <repo_url>"  -f $MyInvocation.MyCommand )
      Write-Host
    } else {
      $scheme = python3 -c "from urllib.parse import urlparse; uri='$($args[0])'; result = urlparse(uri); print(result.scheme)"
      if ($scheme -eq "https") {
        $target = python3 -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
      } else {
        $target = python3 -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
      }
      git clone --recurse-submodules "$($args[0])" "$target"
    }
  }

  # Align Git
  ${function:get_cbk} = { if (Test-Path "~/workspace/Chef/cookbooks"){ Set-Location "~/workspace/Chef/cookbooks"; git clone "gitolite@git.aligntech.com:chef/cookbooks/$($args[0].ToString()).git"; Set-Location "$($args[0].ToString())" } }
}

if (Get-Command ssh.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:ginfo} = { ssh.exe gitolite@git info @args }
}

function Rename-GitHub-Origin {
  param (
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      [string]$NewName
  )
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

function Git-Verbose {
  param (
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
