#!/usr/bin/env bash
alias reload='source ~/.bashrc && echo "Bash profile reloaded"'

# Bash as a login shell:
alias bash='bash -l '

alias c='clear'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"
