<#
.SYNOPSIS
Debugging scripts.

.DESCRIPTION
Debugging scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command gdb.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:gdb_py}   = { gdb.exe -ex r --args python @args }
}
