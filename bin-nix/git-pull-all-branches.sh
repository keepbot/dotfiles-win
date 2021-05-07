#!/usr/bin/env bash
# git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done

for remote in `git branch -r`
do
    git branch --track ${remote#origin/} $remote
done

git fetch --all
git pull --all
