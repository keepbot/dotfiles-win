#!/usr/bin/env bash

alias      kdev="kubectl --context dev"
alias    kstage="kubectl --context stage"
alias     kprod="kubectl --context prod"
alias   kdev_cn="kubectl --context devch"
alias kstage_cn="kubectl --context stagech"
alias  kprod_cn="kubectl --context prodch"

alias      hdev="helm --kube-context dev"
alias    hstage="helm --kube-context stage"
alias     hprod="helm --kube-context prod"
alias   hdev_cn="helm --kube-context devch"
alias hstage_cn="helm --kube-context stagech"
alias  hprod_cn="helm --kube-context prodch"

alias      kdev_proxy="kubectl --context dev proxy --port=10001"
alias    kstage_proxy="kubectl --context stage proxy --port=10001"
alias     kprod_proxy="kubectl --context prod proxy --port=10001"
alias   kdev_cn_proxy="kubectl --context devch proxy --port=10001"
alias kstage_cn_proxy="kubectl --context stagech proxy --port=10001"
alias  kprod_cn_proxy="kubectl --context prodch proxy --port=10001"

alias      kdev_admin="kubectl --context dev     -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
alias    kstage_admin="kubectl --context stage   -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
alias     kprod_admin="kubectl --context prod    -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
alias   kdev_cn_admin="kubectl --context devch   -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
alias kstage_cn_admin="kubectl --context stagech -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
alias  kprod_cn_admin="kubectl --context prodch  -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user-token | awk '{print $1}')"
