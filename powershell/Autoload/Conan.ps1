<#
.SYNOPSIS
Conan.io scripts.

.DESCRIPTION
Conan.io scripts.
#>


# Check invocation
if ( $MyInvocation.InvocationName -ne '.' )
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Variables
$conan_env_path = 'c:\tools\conan_env'

function cei {
    if ( -Not $(Test-Path "${conan_env_path}") )
    {
        $python = Get-Command python.exe | Select-Object -ExpandProperty Definition
        python.exe -m pip install --upgrade pip
        python.exe -m pip install --upgrade virtualenv
        python.exe -m virtualenv -p $python "${conan_env_path}"
        & $(Join-Path "${conan_env_path}" 'Scripts\activate.ps1')
        python.exe -m pip install --upgrade conan
        # python.exe -m pip install --upgrade ipython
    }
    else
    {
        & $(Join-Path "${conan_env_path}" 'Scripts\activate.ps1')
    }
}
Set-Alias cenv_init cei

function ceg
{
    if ( Test-Path "${conan_env_path}" )
    {
        Set-Location "${conan_env_path}"
    }
}
Set-Alias cenv_go ceg

function ce
{
    if ( Test-Path "${conan_env_path}" )
    {
        & $( Join-Path "${conan_env_path}" 'Scripts\activate.ps1' )
    }
    else
    {
        cenv_init
    }
}
Set-Alias cenv_activate ce

function ced
{
    if(${Env:VIRTUAL_ENV})
    {
        deactivate
    }
}
Set-Alias cenv_deactivate ced

function ceu
{
    if ( Test-Path "${conan_env_path}" )
    {
        cenv_activate
        [string] $SessionID = [System.Guid]::NewGuid()
        $TempFreezeFile  = Join-Path "${Env:Temp}" "${SessionID}"
        python.exe -m pip install --upgrade -r "${TempFreezeFile}"
        Remove-Item -Force "${TempFreezeFile}"
        # python.exe -m pip freeze | %{ $_.split('==')[0] } | %{ python.exe -m pip install --upgrade $_ }
    }
    else
    {
        cenv_init
    }
}
Set-Alias cenv_update ceu

function cer {
    cenv_deactivate
    if ( Test-Path "${conan_env_path}" )
    {
        Remove-Item -Recurse -Force "${conan_env_path}"
    }
}
Set-Alias cenv_rm cer
