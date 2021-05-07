<#
.SYNOPSIS
VisualGDB scripts.

.DESCRIPTION
VisualGDB scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command VisualGDB.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:vgdb_pm} = { VisualGDB.exe /pkgmgr }
}
