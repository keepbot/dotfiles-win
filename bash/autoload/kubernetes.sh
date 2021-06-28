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

alias      kdev_token="kubectl --context dev     -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"
alias    kstage_token="kubectl --context stage   -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"
alias     kprod_token="kubectl --context prod    -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"
alias   kdev_cn_token="kubectl --context devch   -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"
alias kstage_cn_token="kubectl --context stagech -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"
alias  kprod_cn_token="kubectl --context prodch  -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')"
