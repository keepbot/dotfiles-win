
<#
.SYNOPSIS
X Server scripts.

.DESCRIPTION
X Server scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command vcxsrv.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:startx} = { vcxsrv :0 -multiwindow -clipboard -wgl -ac }
}
