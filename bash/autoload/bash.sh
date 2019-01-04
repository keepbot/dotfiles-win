#!/usr/bin/env bash

alias reload='source ~/.bashrc && echo "Bash profile reloaded"'

# Bash as a login shell:
alias bash='bash -l '

hist() {
	history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
