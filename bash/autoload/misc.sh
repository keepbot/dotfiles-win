#!/usr/bin/env bash

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

exit_code()
{
    echo -e '\e[1;33m'Exit code: $?'\e[m'
}
