#!/usr/bin/env bash

alias grep='grep --color=auto'
alias gerp='grep'

# Greps with status
alias gHS='grep -e "status" -e "health"'

alias tf='tail -F -n200'

sss() {
	if [ ! "$1" ]; then
		echo "ERROR: You should enter path for searching..."
		echo "Usage: $0 \"<where>\" \"<string>\""
		echo
	fi
	if [ ! "$2" ]; then
		echo "ERROR: You should enter string for searching..."
		echo "Usage: $0 \"<where>\" \"<string>\""
		echo
	fi
	if [ "$3" ]; then
		echo "ERROR: Too many arguments..."
		echo "Usage: $0 \"<where>\" \"<string>\""
		echo
	fi
	grep -rnw $1 -e $2
}
