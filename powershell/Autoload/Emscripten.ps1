<#
.SYNOPSIS
Emscripten scripts.

.DESCRIPTION
Emscripten scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command emsdk -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:ema}  = { if ($args) {emsdk.ps1 activate @args} else {emsdk.ps1 activate latest}}
    ${function:emi}  = { if ($args) {emsdk.ps1 install  @args} else {emsdk.ps1 install  latest}}
    ${function:eml}  = { emsdk.ps1 list }
    ${function:emup} = { emsdk.ps1 update }
    ${function:emun} = { emsdk.ps1 uninstall @args }
}
