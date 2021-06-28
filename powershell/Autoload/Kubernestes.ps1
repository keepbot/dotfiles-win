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

function kdev_token()
{
    kubectl --context dev -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts service-account-controller `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kstage_token()
{
    kubectl --context stage -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts service-account-controller `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kprod_token()
{
    kubectl --context prod -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts service-account-controller `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kdev_cn_token()
{
    kubectl --context devch -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts service-account-controller `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kstage_cn_token()
{
    kubectl --context stagech -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts service-account-controller `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
function kprod_cn_token()
{
    kubectl --context prodch -n kube-system get secret `
    $((kubectl --context prodch -o yaml -n kube-system get serviceaccounts service-account-controller `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}
