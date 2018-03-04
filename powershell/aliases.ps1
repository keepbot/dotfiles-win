#!/usr/bin/env powershell
# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }
${function:.......} = { Set-Location ..\..\..\..\..\.. }

# Navigation Shortcuts
${function:drop} = { Set-Location ~\Documents\Dropbox }
${function:desk} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\OneDrive\Documents }
${function:down} = { Set-Location ~\Downloads }
${function:ws} = { Set-Location ~\workspace }
${function:ws-df} = { Set-Location ~\workspace\my\dotfiles }
${function:ws-tmp} = { Set-Location ~\workspace\tmp }

# Missing Bash aliases
Set-Alias time Measure-Command

# Create a new directory and enter it
Set-Alias mkd CreateAndSet-Directory

# Determine size of a file or total size of a directory
Set-Alias fs Get-DiskUsage

# Empty the Recycle Bin on all drives
Set-Alias emptytrash Empty-RecycleBin

# Cleanup old files all drives
Set-Alias cleandisks Clean-Disks

# Reload the shell
Set-Alias reload Reload-Powershell

# http://xkcd.com/530/
Set-Alias mute Set-SoundMute
Set-Alias unmute Set-SoundUnmute

# Update installed Ruby Gems, NPM, and their installed packages.
Set-Alias update System-Update

# Set GVim as default vim
# Set-Alias vim gvim

# Which and where
New-Alias which Get-Command
${function:which2} = { Get-Command @args -All | Format-Table CommandType, Name, Definition }

# Correct PowerShell Aliases if tools are available (aliases win if set)
# WGet: Use `ls.exe` if available
if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) {
  rm alias:wget -ErrorAction SilentlyContinue
}

# Directory Listing: Use `ls.exe` if available
if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path) {
  rm alias:ls -ErrorAction SilentlyContinue
  # Set `ls` to call `ls.exe` and always use --color
  ${function:ls} = { ls.exe --color --group-directories-first @args }
  # List all files in long format
  ${function:l} = { ls -CFh @args }
  # List all files in long format, including hidden files
  ${function:la} = { ls -alh @args }
  ${function:ll} = { ls -alFh @args }
  ${function:lld} = { ls -l | grep.exe ^d }
  # List only directories
  ${function:lsd} = { Get-ChildItem -Directory -Force @args }
} else {
  # List all files, including hidden files
  ${function:la} = { ls -Force @args }
  # List only directories
  ${function:lsd} = { Get-ChildItem -Directory -Force @args }
}

#if (Get-Command rm.exe -ErrorAction SilentlyContinue | Test-Path) {
# ${function:rmrf} = { rm.exe -rf @args }
#} else {
${function:rmrf} = { Remove-Item -Recurse -Force @args }
#}

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
  rm alias:curl -ErrorAction SilentlyContinue
  ${function:curl} = { curl.exe @args }
  # Gzip-enabled `curl`
  ${function:gurl} = { curl --compressed @args }
} else {
  # Gzip-enabled `curl`
  ${function:gurl} = { curl -TransferEncoding GZip }
}

# Python aliases
if (Get-Command C:\Python\2.7.14-x64\python.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:vc2} = { C:\Python\2.7.14-x64\python.exe -m virtualenv -p C:\Python\2.7.14-x64\python.exe venv } # init py2 venv in curent dir
}
if (Get-Command C:\Python\3.6.3-x64\python.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:vc3} = { C:\Python\3.6.3-x64\python.exe -m virtualenv -p C:\Python\3.6.3-x64\python.exe venv } # init py3 venv in curent dir
}
if (Get-Command python.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:vc} = { ($python = Get-Command python.exe | Select-Object -ExpandProperty Definition); python.exe -m virtualenv -p $python venv }
  ${function:va} = { .\venv\Scripts\activate}
  ${function:vd} = { deactivate }
  ${function:vr} = { rmrf venv }
  ${function:vins} = { If (-Not (Test-Path venv)){vc}; va; python.exe -m pip install -r .\requirements.txt }
  ${function:vgen} = { va; python.exe -m pip freeze > .\requirements.txt }
}

# Ruby aliases
if (Get-Command ruby.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:rre} = { ruby.exe exec @args }
}
if (Get-Command gem -ErrorAction SilentlyContinue | Test-Path) {
  ${function:rgi} = { gem install @args }
  ${function:rbi} = { gem bundle install @args }

}
if (Get-Command bundle -ErrorAction SilentlyContinue | Test-Path) {
  ${function:rbu} = { bundle update @args }
  ${function:rbe} = { bundle exec @args }
}

# Git:
if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:ugr} = { $dir = Get-Location; Get-ChildItem $dir -Directory | ForEach-Object { Write-Host $_.FullName; cd $_.FullName; git.exe pull }; cd $dir }
  ${function:ugrs} = { $dir = Get-Location; Get-ChildItem @args -Directory | ForEach-Object { cd $_.FullName; ugr }; cd $dir }
  ${function:gsu} = { git.exe submodule update --recursive --remote @args }
  ${function:gll} = { git.exe log --pretty=format:"%h - %an, %ar : %s" @args }
  ${function:glL} = { git.exe log --pretty=format:"%H - %an, %ar : %s" @args }
  ${function:g} = { git.exe @args }
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
  # for gget (git.exe clone and cd), see functions.sh.
  ${function:ga} = { git.exe add @args }
  ${function:gc} = { git.exe commit -v @args }
  ${function:gcof} = { git.exe commit --no-verify -m @args }
  ${function:gcaf} = { (git.exe add --all) -and (gcof @args) }
  ${function:gcac} = { gca Cleanup. @args }
  ${function:gcoc} = { gco Cleanup. @args }
  ${function:gcaw} = { gca Whitespace. @args }
  ${function:gcow} = { gco Whitespace. @args }
  # ${function:gp} = { git.exe push -u @args }  # Comment if you use Get-Property and use gppp insted
  ${function:gpl} = { git.exe pull @args }
  ${function:gplp} = { git.exe pull --rebase; git.exe push @args }
  ${function:gpp} = { git.exe push -u @args }  # Can't pull because you forgot to track? Run this.
  ${function:gck} = { git.exe checkout @args }
  ${function:gb} = { git.exe checkout -b @args }
  ${function:got} = { git.exe checkout - @args }
  ${function:gom} = { git.exe checkout master @args }
  ${function:grb} = { git.exe rebase -i origin/master @args }
  ${function:gr} = { git.exe branch -d @args }
  ${function:grr} = { git.exe branch -D @args }
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
  # GitHub
  ${function:get_gh_user_repos} = {
    Write-Host "Clonning all GH repos of $($args[0])"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?per_page=1000" | ConvertFrom-Json
    foreach( $repo in $repoList.clone_url){
      git.exe clone $repo
    }
  }
}

# Chef
if (Get-Command kitchen.bat -ErrorAction SilentlyContinue | Test-Path) {
  ${function:kc} = { kitchen converge @args }
  ${function:kd} = { kitchen destroy @args }
  ${function:kl} = { kitchen list @args }
  ${function:klo} = { kitchen login @args }
  ${function:kt} = { kitchen test -d never @args }
}
if (Get-Command knife.bat -ErrorAction SilentlyContinue | Test-Path) {
  ${function:kn} = { knife node @args }
  ${function:kns} = { knife node show @args }
  ${function:knl} = { knife node list @args }
  ${function:kne} = { knife node edit @args }
  ${function:kbl} = { knife block list @args }
  ${function:kbu} = { knife block use @args }
}

# Network
# IP addresses: TODO: network functions
if (Get-Command dig.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:myip} = { dig.exe +short myip.opendns.com `@resolver1.opendns.com }
}

# Fun
${function:urlencode} = { python.exe -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));" @args }

################################################################################
### >> Align:
################################################################################
#Git
if (Get-Command ssh.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:ginfo} = { ssh.exe gitolite@git info @args }
}
# Greps with status
if (Get-Command grep.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:gHS} = { grep.exe -e "status" -e "health" @args }
}
