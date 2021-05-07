#!/usr/bin/env bash

# Get help from cheat.sh
cht()
{
    origIFS="${IFS}"
    IFS='+'

    if [ $# -eq 0 ]
    then
        echo "Usage: `basename $0` <langiage> <search string>"
        return 1
    fi

    lang="$1"
    shift
    site="cheat.sh/${lang}/$*"
    curl "${site}"
    IFS="${origIFS}"
}
