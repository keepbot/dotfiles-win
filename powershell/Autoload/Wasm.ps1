<#
.SYNOPSIS
WASM scripts.

.DESCRIPTION
WASM scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:wasm_build} = { emcc.py -o a.out.html -s STANDALONE_WASM=1 -s WASM_BIGINT=1 -O3 -v @args }
