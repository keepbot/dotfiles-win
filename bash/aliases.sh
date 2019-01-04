#!/usr/bin/env bash
# Management
alias reload='source ~/.bashrc && echo "Bash profile reloaded"'

# Export DISPLAY variable. If local than it exports localhost, if remole it exports SSH Client
alias disp='source ~/.bin/export-display.sh'

# Bash as a login shell:
alias bash='bash -l '

platform=`uname`
case $platform in
	Linux )
		alias ls='ls --color=auto'
		;;
	Darwin )
		alias ls='gls --color=auto'
		;;
	FreeBSD )
		alias ls='ls -G'
		;;
	MSYS_NT-10.0 )
		ls='ls --color=auto'
		;;
esac

alias l='ls -CFh --group-directories-first'
alias la='ls -alh --group-directories-first'
alias ll='ls -alFh --group-directories-first'
alias dirs="ls -l | grep ^d"

alias c='clear'

alias cdd='cd -'  # back to last directory
alias pg='ps aux | head -n1; ps aux | grep -i'
alias tf='tail -F -n200'
alias top='top -o%CPU'
alias        ..='cd ..'
alias       ...='cd ../..'
alias      ....='cd ../../..'
alias     .....='cd ../../../..'
alias    ......='cd ../../../../..'
alias   .......='cd ../../../../../..'
alias  ........='cd ../../../../../../..'

# Navigation Shortcuts
alias ws='cd ~/workspace'
alias wsmy='cd ~/workspace/my'
alias wsdf='cd ~/workspace/my/dotfiles'
alias wso='cd ~/workspace/ormco'
alias wsod='cd ~/workspace/ormco/devops'
alias wsc='cd /c/Users/dkiva/workspace'
alias wsco='cd /c/Users/dkiva/workspace/ormco'
alias wsd='cd /d/work'
alias wst='cd ~/workspace/tmp'

alias crlf_fix='find ./ -type f -exec dos2unix {} \;'
alias dir_fix='find ./ -type d -print -exec chmod 755 {} \;'
alias files_fix='find ./ -type f -print -exec chmod 644 {} \;'

# Python
alias vc2='python2 -m virtualenv -p python2 venv' # init py2 venv in curent dir
alias vc3='python3 -m virtualenv -p python3 venv' # init py3 venv in curent dir
alias va='source ./venv/bin/activate'
alias vd='deactivate'
alias vr='rm -rf ./venv'
alias vins='va && pip install -r requirements.txt'
alias vgen='va && pip freeze > requirements.txt'

# tmux aliases
alias tmux="tmux -2"
alias tm='tmux'
alias tma='tmux attach'
alias tmls='tmux ls'
alias tmat='tmux attach -t'
alias tmns='tmux new-session -s'

# With tmux mouse mode on, just select text in a pane to copy.
# Then run tcopy to put it in the OS X clipboard (assuming reattach-to-user-namespace).
alias tcopy="tmux show-buffer | pbcopy"

# sudo (do not forget _ at the end (for alias))
alias sudo="sudo -E "

# Mignight commander
alias mc="mc -a -b"

# Straight into console-in-screen.
# Assumes there is only one screen running.
#alias prodc="ssh srv -t screen -RD"

# Helpers
alias grep='grep --color=auto'
alias gerp='grep'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# IP addresses
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# View HTTP traffic
alias sniffe="sudo ngrep -d 'enp0s31f6' -t '^(GET|POST) ' 'tcp and port 80'"
alias sniffw="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# File size
alias fs="stat -c \"%s bytes\""

# ROT13. Encode and decode. JUST FOR Lulz ;)
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));"'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep 'chrome --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of janmoesen's ProTips. Preinstall: cpan install lwp-request
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

alias mmn="mount|column -t"

# ruby
alias rre='ruby exec'
alias rgi='gem install'
alias rbi='gem bundle install'
alias rbu='bundle update'
alias rbe='bundle exec'

# Docker
alias di='docker images'
alias dc='docker ps -a'
alias dcl='docker rm $(docker ps -aqf status=exited)'
alias dcla='docker rm $(docker ps -aqf status=exited) && docker rmi $(docker images -qf dangling=true) && docker volume rm $(docker volume ls -qf dangling=true)'
alias dira='docker rmi $(docker images -q)'
alias diraf='docker rmi -f $(docker images -q)'
# inspect docker images
function dc_trace_cmd() {
  local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
  declare -i level=$2
  echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
  level=level+1
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent
    dc_trace_cmd $parent $level
  fi
}

# Terraform
alias terrafrom='terraform'
alias t='terraform'
alias ta='terraform apply terraform.plan'
alias ti='terraform init'
alias tp='terraform plan -out terraform.plan'
alias tpd='terraform plan -destroy -out terraform.plan'
alias tw='terraform workspace'
alias twd='terraform workspace delete'
alias twn='terraform workspace new'
alias twl='terraform workspace list'
alias tws='terraform workspace select'

alias genpass='openssl rand -base64'
alias sha='shasum -a 256'

################################################################################
### >> Align:
################################################################################
#Git
alias ginfo='ssh gitolite@git info'

# Greps with status
alias gHS='grep -e "status" -e "health"'


