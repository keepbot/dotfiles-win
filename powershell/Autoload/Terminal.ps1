
<#
.SYNOPSIS
Terminal scripts.

.DESCRIPTION
Terminal scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:wt_ps} = { wt -p pwsh.exe `; split-pane -p pwsh.exe }
${function:wt_ws} = { wt -p pwsh.exe `; split-pane -p pwsh.exe `; new-tab wsl.exe }
