#!/usr/bin/env bash

kb()
{
    cd ~ || return 1
    knife block "${1}"
    cd - >/dev/null || return 1
}

# Here keyword 'function' used to avoid some king of tricky bug which breaks loading bash functions!
function kne()
{
    cd ~ || return 1
    knife node edit "${1}" -a
    cd - >/dev/null || return 1
}

ksn()
{
    cd ~ || return 1
    envupper=$(echo "${1}" | tr '[:lower:]' '[:upper:]')
    if [ $# -eq 1 ]
    then
        recipe_term=""
    else
        recipe_term="AND recipe:*${2}*"
    fi
    knife search node "chef_env*:${envupper} ${recipe_term}" -i;
    cd - >/dev/null || return 1
}

ksni()
{
    cd ~ || return 1
    knife search node "ipaddress:${1}" -i;
    cd - >/dev/null || return 1
}

alias  kl='kitchen list'
alias klo='kitchen login'
alias  kd='kitchen destroy'
alias  kc='kitchen converge'
alias  kt='kitchen test -d never'

alias  kn='knife node'
alias kns='knife node show'
alias knl='knife node list'
alias kne='knife node edit'

alias kbu='knife block use'
alias kbl='knife block list'
