#!/usr/bin/env bash

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

exit_code() {
	echo -e '\e[1;33m'Exit code: $?'\e[m'
}

# Get help from cheat.sh
cht() {
  origIFS="${IFS}"
  IFS='+'
  if [ $# -eq 0 ]; then
    echo "Usage: `basename $0` <langiage> <search string>"
    exit 0
  fi
  lang="$1"
  shift
  site="cheat.sh/${lang}/$*"
  curl "${site}"
  IFS="${origIFS}"
}
