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

$conan_env_path = 'c:\tools\conan_env'

function cenv_init {
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

function cenv_go
{
    if ( Test-Path "${conan_env_path}" )
    {
        Set-Location "${conan_env_path}"
    }
}

function cenv
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
Set-Alias cenv_activate cenv

function nocenv
{
    if(${Env:VIRTUAL_ENV})
    {
        deactivate
    }
}
Set-Alias cenv_deactivate nocenv

function cenv_update
{
    if ( Test-Path "${conan_env_path}" )
    {
        cenv_activate
        [string] $SessionID = [System.Guid]::NewGuid()
        $TempFreezeFile  = (Join-Path "${Env:Temp}" "${SessionID}")
        python.exe -m pip freeze | %{ $_.split('==')[0] } | %{ python.exe -m pip install --upgrade $_ }
    }
    else
    {
        cenv_init
    }
}

function cenv_rm {
    nocenv
    if ( Test-Path "${conan_env_path}" )
    {
        rmrf "${conan_env_path}"
    }
}
