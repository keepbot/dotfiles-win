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

${function:kdev}   = { kubectl --context dev     @args }
${function:kstage} = { kubectl --context stage   @args }
${function:kprod}  = { kubectl --context prod    @args }

${function:hdev}   = { helm --kube-context dev   @args }
${function:hstage} = { helm --kube-context stage @args }
${function:hprod}  = { helm --kube-context prod  @args }
