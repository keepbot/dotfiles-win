#!/usr/bin/env bash

alias terrafrom='terraform'
alias t='terraform'

alias ti='terraform init'
alias ta='terraform apply terraform.plan'
alias tp='terraform plan -out terraform.plan'
alias tpd='terraform plan -destroy -out terraform.plan'

alias tw='terraform workspace'
alias twd='terraform workspace delete'
alias twn='terraform workspace new'
alias twl='terraform workspace list'
alias tws='terraform workspace select'

function tpdm()
{
    terraform plan -destroy -target module.$@ -out terraform.plan
}
