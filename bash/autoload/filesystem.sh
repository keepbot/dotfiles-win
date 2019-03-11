#!/usr/bin/env bash

alias        ..='cd ..'
alias       ...='cd ../..'
alias      ....='cd ../../..'
alias     .....='cd ../../../..'
alias    ......='cd ../../../../..'
alias   .......='cd ../../../../../..'
alias  ........='cd ../../../../../../..'

alias cdd='cd -'  # back to last directory

# Create a new directory and enter it
md() {
	mkdir -p "$@" && cd "$@"
}

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

# Navigation Shortcuts
alias wscd='cd ~/workspace'
alias wsmy='cd ~/workspace/my'
alias wsdf='cd ~/workspace/my/dotfiles'
alias wsaw='cd ~/.config/awesome'
alias wsom='cd ~/workspace/ormco'
alias wsod='cd ~/workspace/ormco/devops'
alias wscw='cd /c/Users/dkiva/workspace'
alias wsco='cd /c/Users/dkiva/workspace/ormco'
alias wsdw='cd /d/work'
alias wstp='cd ~/workspace/tmp'

alias crlf_fix='find ./ -type f -exec dos2unix {} \;'
alias dir_fix='find ./ -type d -print -exec chmod 755 {} \;'
alias files_fix='find ./ -type f -print -exec chmod 644 {} \;'

# File size
alias fs="stat -c \"%s bytes\""

alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

alias mmn="mount|column -t"

# find shorthand
f() {
	find . -name "$1"
}

# List files in current directory and replace spaces with underscores
lsD() {
  origIFS="${IFS}"
	IFS=''
	for str in `find . -maxdepth 1 -type f -name "* *" |sed 's#.*/##'`; do
		echo ${str// /_}
	done
  IFS="${origIFS}"
}

find-rootfs() {
    sudo find / -path /home/storage -prune -printf '' -o "$@"
}

find_core_dumps() {
    sudo find / -path /home/storage -prune -printf '' -o                    \
        -type f -regextype posix-extended                                   \
        -regex '^.*core\.([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5})'    \
        -print "$@"
}

