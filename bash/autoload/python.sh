#!/usr/bin/env bash

alias vc='python -m virtualenv -p python venv'
alias vc2='python2 -m virtualenv -p python2 venv' # init py2 venv in curent dir
alias vc3='python3 -m virtualenv -p python3 venv' # init py3 venv in curent dir
alias va='source ./venv/bin/activate'
alias vd='deactivate'
alias vr='rm -rf ./venv'
alias vins='python -m pip install -r requirements.txt'
alias vgen='python -m pip freeze > requirements.txt'

# Basic environment
alias pip_update='python -m pip install --upgrade pip'
alias venv_install='python -m pip install virtualenv'
alias ipython_install='python -m pip install ipython'

alias py_srv='python -m http.server'

py_venv()
{
    python -m pip install --upgrade pip
    python -m pip install --upgrade virtualenv
    python -m pip install --upgrade ipython
}
alias pip_update='py_venv'
