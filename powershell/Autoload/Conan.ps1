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


if(-Not $Env:CONAN_USER_HOME)
{
    $Env:CONAN_USER_HOME="C:\tools\conan_data"
    [Environment]::SetEnvironmentVariable("CONAN_USER_HOME", "C:\tools\conan_data", "Machine")
    if(-Not (Test-Path "${Env:CONAN_USER_HOME}"))
    {
        New-Item "${Env:CONAN_USER_HOME}" -ItemType Directory -ErrorAction SilentlyContinue
    }
}

if(-Not $Env:CONAN_USER_HOME_SHORT)
{
    $Env:CONAN_USER_HOME_SHORT="${Env:CONAN_USER_HOME}\short"
    [Environment]::SetEnvironmentVariable("CONAN_USER_HOME_SHORT", "${Env:CONAN_USER_HOME_SHORT}", "Machine")
    if(-Not (Test-Path "${Env:CONAN_USER_HOME_SHORT}"))
    {
        New-Item "${Env:CONAN_USER_HOME_SHORT}" -ItemType Directory -ErrorAction SilentlyContinue
    }
}

if((-Not $Env:CONAN_TRACE_FILE) -And $Env:CONAN_USER_HOME)
{
    $Env:CONAN_TRACE_FILE="${Env:CONAN_USER_HOME}\conan.log"
    [Environment]::SetEnvironmentVariable("CONAN_TRACE_FILE", "${Env:CONAN_USER_HOME}\conan.log", "Machine")
}

# Variables
$conan_env_path = 'c:\tools\conan_env'

function conan_symlinks
{
    $conan_my_path  = Join-Path $HOME ".conan_my"
    $conan_hooks    = Join-Path $Env:CONAN_USER_HOME ".conan\hooks"
    $conan_profiles = Join-Path $Env:CONAN_USER_HOME ".conan\profiles"

    if(-Not (Test-Path $conan_hooks))
    {
        New-Item "${conan_hooks}" -ItemType Directory -ErrorAction SilentlyContinue
    }

    if(-Not (Test-Path $conan_profiles))
    {
        New-Item "${conan_profiles}" -ItemType Directory -ErrorAction SilentlyContinue
    }

    if((Test-Path $conan_my_path) -And $Env:CONAN_USER_HOME)
    {
        Get-ChildItem "${conan_my_path}\hooks\" | ForEach-Object {
            Remove-Item -Force -Confirm:$false "${conan_hooks}\$($_.Name)" -ErrorAction SilentlyContinue
            cmd.exe /c mklink "${conan_hooks}\$($_.Name)" "$($_.FullName)"
        }

        Get-ChildItem "${conan_my_path}\profiles\" | ForEach-Object {
            Remove-Item -Force -Confirm:$false "${conan_profiles}\$($_.Name)" -ErrorAction SilentlyContinue
            cmd.exe /c mklink "${conan_profiles}\$($_.Name)" "$($_.FullName)"
        }
    }
}

function cei
{
    if ( -Not $(Test-Path "${conan_env_path}") )
    {
        $python = Get-Command python.exe | Select-Object -ExpandProperty Definition
        python.exe -m pip install --upgrade pip
        python.exe -m pip install --upgrade virtualenv
        python.exe -m virtualenv -p $python "${conan_env_path}"
        & $(Join-Path "${conan_env_path}" 'Scripts\activate.ps1')
        python.exe -m pip install --upgrade pip
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
        python.exe -m pip freeze --all | ForEach-Object { $_.split('==')[0] } >> "${TempFreezeFile}"
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

function cer
{
    cenv_deactivate
    if ( Test-Path "${conan_env_path}" )
    {
        Remove-Item -Recurse -Force "${conan_env_path}"
    }
}
Set-Alias cenv_rm cer

if (Get-Command conan.exe -ErrorAction SilentlyContinue | Test-Path)
{
    function conan_add_remote
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory=$true)]
            [string]$Organization,
            [string]$Remote = 'conan-local',
            [string]$Repo = 'conan-local'
        )
        conan remote add ${Remote} https://${Organization}.jfrog.io/artifactory/api/conan/${Repo}
    }

    function conan_set_env_password
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory=$true)]
            [SecureString]$Password
        )
        Set-Item -Path Env:CONAN_PASSWORD -Value "${Password}"
    }

    function conan_remote_auth
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory=$true)]
            [string]$Username,
            [Parameter(Mandatory=$true)]
            [SecureString]$Password,
            [string]$Remote = 'conan-local'
        )
        conan user -p ${Password} -r ${Remote} ${Username}
    }
}

${function:conan_shared} = { conan install . -pr "${Env:CONAN_USER_HOME}\.conan\profiles\windows-msvc-16-shared-release-x64" --build=missing }
${function:conan_static} = { conan install . -pr "${Env:CONAN_USER_HOME}\.conan\profiles\windows-msvc-16-static-release-x64" --build=missing }

## History
# conan remove --locks
# conan install conanfile.txt -g visual_studio --install-folder Source\Apps\Aligner\Solution\.conan -s arch=x86_64 -s build_type=Release -s compiler.toolset=v142 -s compiler.version=16 -s compiler.runtime=MD  --build=outdated --update
