#!/usr/bin/env pwsh
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
${function:drop} = { Set-Location D:\Dropbox }
${function:desk} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:down} = { Set-Location ~\Downloads }
${function:ws} = { Set-Location ~\workspace }
${function:wsmy} = { Set-Location ~\workspace\my }
${function:wsdf} = { Set-Location ~\workspace\my\dotfiles }
${function:wso} = { Set-Location ~\workspace\ormco}
${function:wsod} = { Set-Location ~\workspace\ormco\devops}
${function:wst} = { Set-Location ~\workspace\tmp }

${function:mountW} = { subst.exe W: ( Join-Path $HOME "workspace" ) }

# Missing Bash aliases
# Set-Alias time Measure-Command
# ${function:time} = { Measure-Command { @args }}
${function:time} = {
  $command = $args
  $timings = $(Measure-Command {Invoke-Expression "${command}" | Out-Default})
  $obj = New-Object PSObject
  $obj | Add-Member Ticks $timings.Ticks
  $obj | Add-Member Hours $timings.TotalHours
  $obj | Add-Member Minutes $timings.TotalMinutes
  $obj | Add-Member Seconds $timings.TotalSeconds
  $obj | Add-Member Milliseconds $timings.TotalMilliseconds
  # $str = "| " + $obj + " |"
  # Write-Host $('-' * $str.Length)
  # Write-Host $str
  # Write-Host $('-' * $str.Length)
  Write-Host
  # Write-Host $('-' * 17) " Time report " $('-' * 18)
  # Write-Host $('-' * 50)
  Write-Host "Ticks       :" $timings.Ticks
  Write-Host "Hours       :" $timings.TotalHours
  Write-Host "Minutes     :" $timings.TotalMinutes
  Write-Host "Seconds     :" $timings.TotalSeconds
  Write-Host "Miliseconds :" $timings.TotalMilliseconds
  # Write-Host $('-' * 50)
}
# ${function:time} = {
#   $sw = [Diagnostics.Stopwatch]::StartNew()
#   Invoke-Expression "${args}" | Out-Default
#   $sw.Stop()
#   $sw.Elapsed
# }

${function:env} = {Get-ChildItem Env:}

# Clear screen
Set-Alias c Clear-Host

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
Set-Alias vim gvim

# Which and where
New-Alias which1 Get-Command
${function:which2} = { Get-Command @args -All | Format-Table CommandType, Name, Definition }

# Correct PowerShell Aliases if tools are available (aliases win if set)
# WGet: Use `wget.exe` if available
if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:wget -ErrorAction SilentlyContinue
}

# Directory Listing: Use `ls.exe` if available
if (Get-Command busybox.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:ls -ErrorAction SilentlyContinue
  # Set `ls` to call `ls.exe` and always use --color
  ${function:ls} = { busybox.exe ls --color --group-directories-first @args }
  # List all files in long format
  ${function:l} = { ls -CFh @args }
  # List all files in long format, including hidden files
  ${function:la} = { ls -alh @args }
  ${function:ll} = { ls -alFh @args }
  ${function:lld} = { ls -l | busybox.exe grep ^d }
  # List only directories
  ${function:lsd} = { Get-ChildItem -Directory -Force @args }
} else {
  # List all files, including hidden files
  ${function:la} = { Get-ChildItem-Force @args }
  # List only directories
  ${function:lsd} = { Get-ChildItem -Directory -Force @args }
}

# Greps with status
if (Get-Command busybox.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:grep} = { busybox.exe grep @args }
  ${function:gerp} = { grep @args }
  ${function:gHS} = { grep -e "status" -e "health" @args }
} else {
  Set-Alias -Name grep -Value Select-String
  Set-Alias -Name gerp -Value grep
  Set-Alias -Name greo -Value grep
}

${function:lsf} = { Get-ChildItem . | ForEach-Object{ $_.Name } }

#if (Get-Command rm.exe -ErrorAction SilentlyContinue | Test-Path) {
# ${function:rmrf} = { rm.exe -rf @args }
#} else {
${function:rmrf} = { Remove-Item -Recurse -Force @args }
#}

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:curl -ErrorAction SilentlyContinue
  ${function:curl} = { curl.exe @args }
  # Gzip-enabled `curl`
  ${function:gurl} = { curl.exe --compressed @args }
} else {
  # Gzip-enabled `curl`
  ${function:gurl} = { Invoke-WebRequest -TransferEncoding GZip }
}

# Python aliases
if (Get-Command c:\tools\python2\python.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:vc2} = { c:\tools\python2\python.exe -m virtualenv -p c:\tools\python2\python.exe venv } # init py2 venv in curent dir
}
if (Get-Command c:\tools\python3\python.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:vc3} = { c:\tools\python3\python.exe -m virtualenv -p c:\tools\python3\python.exe venv } # init py3 venv in curent dir
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
  ${function:ugr} = { $dir = Get-Location; Get-ChildItem $dir -Directory | ForEach-Object { Write-Host $_.FullName; Set-Location $_.FullName; git.exe pull }; Set-Location $dir }
  ${function:ugrm} = { $dir = Get-Location; Get-ChildItem $dir -Directory | ForEach-Object { Write-Host $_.FullName; Set-Location $_.FullName; git.exe checkout master; git.exe pull }; cd $dir }
  ${function:ugrs} = { $dir = Get-Location; Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugr }; Set-Location $dir }
  ${function:gsu} = { git.exe submodule update --recursive --remote @args }
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
  # GitHub
  ${function:get_gh_user_repos} = {
    Write-Host "Clonning all GH repos of $($args[0])"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?per_page=1000" | ConvertFrom-Json
    foreach( $repo in $repoList.clone_url){
      git.exe clone $repo
    }
  }
  ${function:get_repo_with_target} = {
    if (-Not $args[0]){
      Write-Host "You should enter repo URI."
      Write-Host ( "Usage: {0} <repo_url>"  -f $MyInvocation.MyCommand )
      Write-Host
    } else {
      $scheme = python.exe -c "from urllib.parse import urlparse; uri='$($args[0])'; result = urlparse(uri); print(result.scheme)"
      if ($scheme -eq "https") {
        $target = python.exe -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
      } else {
        $target = python.exe -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
      }
      git clone --recurse-submodules "$($args[0])" "$target"
    }
  }
  # Align Git
  ${function:get_cbk} = { if (Test-Path "~/workspace/Chef/cookbooks"){ Set-Location "~/workspace/Chef/cookbooks"; git clone "gitolite@git.aligntech.com:chef/cookbooks/$($args[0].ToString()).git"; Set-Location "$($args[0].ToString())" } }
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
  ${function:kne} = { knife node edit $($args[0].ToString()) -a }
  ${function:kbl} = { knife block list @args }
  ${function:kbu} = { knife block use @args }
  ${function:ksn} = {
    if ($args.Count -eq 1){
      $recipe_term = ""
    }
    else {
      $recipe_term = "AND recipe:*$($args[1].ToString())*"
    }
    knife search node "chef_env*:$($args[0].ToString().ToUpper()) ${recipe_term}" -i
  }
  ${function:ksni} = {
    if ($args.Count -ne 1) {
      Write-Host "Usage: ksni <ip_address>"
    }
    else {
      knife search node "ipaddress:$($args[0].ToString())" -i
    }
  }

  # Align chef
  ${function:wso2creds} = {
    if ($args.Count -ne 2) {
      Write-Host "Usage: wso2creds <environment> <username>"
    }
    else {
      kbu itio-vault
      $wso2db = knife vault show wso2creds "$($args[0].ToString().ToUpper())" --mode client --format json | ConvertFrom-Json
      Write-Host $wso2db.users.$($args[1].ToString())
      kbu itio
    }
  }
}

# Network
# IP addresses: TODO: network functions
if (Get-Command dig.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:myip} = { dig.exe +short myip.opendns.com `@resolver1.opendns.com }
  ${function:digga} = { dig.exe +nocmd "$($args[0].ToString())" any +multiline +noall +answer }
}
${function:ipif} = {if ($($args[0])) {curl ipinfo.io/"$($args[0].ToString())"} else {curl ipinfo.io}}

${function:localip} = { Get-NetIPAddress | Format-Table }

# Fun
${function:urlencode} = { python.exe -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));" @args }

if (Get-Command $Env:ProgramFiles\Docker\Docker\DockerCli.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:dokkaSD} = { & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon }
}

${function:List-Paths} = { $Env:Path.Split(';') }

# Tail
${function:tail} = {
  if ($args.Count -ne 2) {
    Write-Host "Usage: tail <-N or -f> <path_to_file>"
  } else {
    switch ($args[0]) {
      "-f" {Get-Content $args[1] -Wait}
      default {Get-Content $args[1] -Tail $($args[0] -replace '\D+(\d+)','$1')}
    }
  }
}

${function:List-Env} = { Get-ChildItem Env: }

# Docker
if (Get-Command docker.exe -ErrorAction SilentlyContinue | Test-Path)
{
  ${function:di} = { docker.exe images }
  ${function:dc} = { docker.exe ps -a }
  ${function:dcl} = { docker.exe rm $(docker ps -aqf status=exited) }
  ${function:dcla} = {
    docker.exe rm $(docker ps -aqf status=exited)
    docker.exe rmi $(docker images -qf dangling=true)
    docker.exe volume rm $(docker volume ls -qf dangling=true)
  }
  ${function:dira} = { docker.exe rmi -f $(docker images -q) }
  # inspect docker images
  ${function:dc_trace_cmd} = {
    ${parent}= $(docker.exe inspect -f '{{ .Parent }}' $args[0])
    [int]${level}=$args[1]
    Write-Host ${level}: $(docker inspect -f '{{ .ContainerConfig.Cmd }}' $args[0])
    ${level}=${level}+1
    if (${parent})
    {
      Write-Host ${level}: ${parent}
      dc_trace_cmd ${parent} ${level}
    }
  }
}

# Power
${function:Set-Power-Max} = { powercfg.exe /SETACTIVE SCHEME_MIN }
${function:Set-Power-Balanced} = { powercfg.exe /SETACTIVE SCHEME_BALANCED }
${function:Set-Power-Min} = { powercfg.exe /SETACTIVE SCHEME_MAX }

# Terraform
if (Get-Command terraform.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:terrafrom}   = { terraform.exe @args }
    ${function:t}           = { terraform.exe @args }
    ${function:ta}          = { terraform.exe apply terraform.plan @args }
    ${function:ti}          = { terraform.exe init @args }
    ${function:tp}          = { terraform.exe plan -out terraform.plan @args}
    ${function:tpd}         = { terraform.exe plan -destroy -out terraform.plan @args}
    # ${function:tp}          = { if ($args[0] -And -Not $args[1]) {terraform.exe plan -out terraform.plan --var-file=$args.tfvars} else {terraform.exe plan -out terraform.plan @args}}
    # ${function:tpd}         = { if ($args[0] -And -Not $args[1]) {terraform.exe plan -destroy -out terraform.plan --var-file=$args.tfvars} else {terraform.exe plan -destroy -out terraform.plan @args}}
    ${function:tw}          = { terraform.exe workspace @args }
    ${function:twd}         = { terraform.exe workspace delete @args }
    ${function:twn}         = { terraform.exe workspace new @args }
    ${function:twl}         = { terraform.exe workspace list @args }
    ${function:tws}         = { terraform.exe workspace select @args }
}

if (Get-Command openssl.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:genpass}   = { openssl.exe rand -base64 @args }
}

if (Get-Command shasum.bat -ErrorAction SilentlyContinue | Test-Path) {
  ${function:sha}  = { shasum.bat -a 256 @args }
}


################################################################################
### >> Align:
################################################################################
#Git
if (Get-Command ssh.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:ginfo} = { ssh.exe gitolite@git info @args }
}
