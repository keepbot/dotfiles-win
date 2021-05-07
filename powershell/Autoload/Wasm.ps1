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

function wasm_debug
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Button
    )

    switch ($Button)
    {
        ({$PSItem -eq 'On' -Or $PSItem -eq 'on'})
        {
            Set-Item -Path Env:EMCC_DEBUG -Value 1
            break
        }
        ({$PSItem -eq 'Off' -Or $PSItem -eq 'off'})
        {
            Set-Item -Path Env:EMCC_DEBUG -Value 0
            break
        }
        default
        {
            Write-Host "ERROR: Wrong operation..." -ForegroundColor Red
            Write-Host "  Usage: wasm_debug <On|Off>" -ForegroundColor Red
        }
    }
}
