#!/usr/bin/env bash

alias reload='source ~/.bashrc && echo "Bash profile reloaded"'

# Bash as a login shell:
alias bash='bash -l '

hist_top()
{
    history | awk '{a[$3]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -50
}
