#!/usr/bin/env bash
# Management
alias reload='source ~/.bashrc && echo "Bash profile reloaded"'

# Export DISPLAY variable. If local than it exports localhost, if remole it exports SSH Client
alias disp='source ~/.local/bin/displayvar.sh'

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
alias lld="ls -l | grep ^d"

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
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

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
alias myips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

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

# Git:
alias ugr='for dir in `ls`; do echo "${dir}"; cd "${dir}"; git pull; cd ..; done' # Update all repos in current directory
alias ugrs='root=${PWD}; for dir in `ls`; do cd "${root}/${dir}" && ugr; done'    # Update all repos within all sub directories from curent
alias gsu='git submodule update --recursive --remote'
alias gll='git log --pretty=format:"%h - %an, %ar : %s"'
alias glL='git log --pretty=format:"%H - %an, %ar : %s"'
alias g="git"
alias gs="git status"
alias gw="git show"
alias gw^="git show HEAD^"
alias gw^^="git show HEAD^^"
alias gw^^^="git show HEAD^^^"
alias gw^^^^="git show HEAD^^^^"
alias gw^^^^^="git show HEAD^^^^^"
alias gd="git diff HEAD"  # What's changed? Both staged and unstaged.
alias gdo="git diff --cached"  # What's changed? Only staged (added) changes.
# for gco ("git commit only") and gca ("git commit all"), see functions.sh.
# for gget (git clone and cd), see functions.sh.
alias ga="git add"
alias gc="git commit -v"
alias gcof="git commit --no-verify -m"
alias gcaf="git add --all && gcof"
alias gcac="gca Cleanup."
alias gcoc="gco Cleanup."
alias gcaw="gca Whitespace."
alias gcow="gco Whitespace."
alias gp='git push -u'  # Comment if you use Pari Calculator and use gpp instead
alias gpp="git push -u"  # Can't pull because you forgot to track? Run this.
alias gpl='git pull'
alias gppp='git pull --rebase && git push'
alias gps='(git stash --include-untracked | grep -v "No local changes to save") && gpp && git stash pop || echo "Fail!"'
alias gck="git checkout"
alias gb="git checkout -b"
alias got="git checkout -"
alias gom="git checkout master"
alias grb="git rebase -i origin/master"
alias gr="git branch -d"
alias grr="git branch -D"
alias gcp="git cherry-pick"
alias gam="git commit --amend"
alias gamne="git commit --amend --no-edit"
alias gamm="git add --all && git commit --amend -C HEAD"
alias gammf="gamm --no-verify"
alias gba="git rebase --abort"
alias gbc="git add -A && git rebase --continue"
alias gbm="git fetch origin master && git rebase origin/master"
alias gfr="git fetch --all && git reset --hard origin/master"
alias GClean="git reset --hard && git clean -d -x -f"

# Chef
alias kc='kitchen converge'
alias kd='kitchen destroy'
alias kl='kitchen list'
alias klo='kitchen login'
alias kt='kitchen test -d never'

alias kn='knife node'
alias kns='knife node show'
alias knl='knife node list'
alias kne='knife node edit'

alias kbl='knife block list'
alias kbu='knife block use'

# ruby
alias bup='bundle update'
alias be='bundle exec'

################################################################################
### >> Align:
################################################################################
#Git
alias ginfo='ssh gitolite@git info'

# Greps with status
alias gHS='grep -e "status" -e "health"'


