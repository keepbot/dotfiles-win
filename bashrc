#!/usr/bin/env bash

# Test for interactiveness
[[ $- == *i* ]] || return

# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

for file in ${HOME}/.bash/autoload/*; do
    source ${file}
done
