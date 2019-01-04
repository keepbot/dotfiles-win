#!/usr/bin/env bash

alias vc2='python2 -m virtualenv -p python2 venv' # init py2 venv in curent dir
alias vc3='python3 -m virtualenv -p python3 venv' # init py3 venv in curent dir
alias va='source ./venv/bin/activate'
alias vd='deactivate'
alias vr='rm -rf ./venv'
alias vins='va && pip install -r requirements.txt'
alias vgen='va && pip freeze > requirements.txt'
