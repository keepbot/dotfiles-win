<#
.SYNOPSIS
Kubernetes scripts.

.DESCRIPTION
Kubernetes scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:kdev}            = { kubectl --context dev       @args }
${function:kstage}          = { kubectl --context stage     @args }
${function:kprod}           = { kubectl --context prod      @args }
${function:kdev_cn}         = { kubectl --context devch     @args }
${function:kstage_cn}       = { kubectl --context stagech   @args }
${function:kprod_cn}        = { kubectl --context prodch    @args }

${function:hdev}            = { helm --kube-context dev     @args }
${function:hstage}          = { helm --kube-context stage   @args }
${function:hprod}           = { helm --kube-context prod    @args }
${function:hdev_cn}         = { helm --kube-context devch   @args }
${function:hstage_cn}       = { helm --kube-context stagech @args }
${function:hprod_cn}        = { helm --kube-context prodch  @args }

${function:kdev_proxy}      = { kubectl --context dev     proxy --port=10001 }
${function:kstage_proxy}    = { kubectl --context stage   proxy --port=10001 }
${function:kprod_proxy}     = { kubectl --context prod    proxy --port=10001 }
${function:kdev_cn_proxy}   = { kubectl --context devch   proxy --port=10001 }
${function:kstage_cn_proxy} = { kubectl --context stagech proxy --port=10001 }
${function:kprod_cn_proxy}  = { kubectl --context prodch  proxy --port=10001 }

${function:kdev_exec}       = { kubectl --context dev     exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstage_exec}     = { kubectl --context stage   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprod_exec}      = { kubectl --context prod    exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdev_cn_exec}    = { kubectl --context devch   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstage_cn_exec}  = { kubectl --context stagech exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprod_cn_exec}   = { kubectl --context prodch  exec -it @args "--" sh -c "(bash || ash || sh)" }

function kdev_admin()
{
    kubectl --context dev -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kstage_admin()
{
    kubectl --context stage -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kprod_admin()
{
    kubectl --context prod -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kdev_cn_admin()
{
    kubectl --context devch -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kstage_cn_admin()
{
    kubectl --context stagech -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kprod_cn_admin()
{
    kubectl --context prodch -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
