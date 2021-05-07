<#
.SYNOPSIS
PowerShell modules scripts.

.DESCRIPTION
PowerShell modules scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

$ModulesDir = Join-Path (Get-Item $PSScriptRoot).Parent.FullName "Modules"

$local_modules = @(
    "ApplicationCompatibility"
)

$modules = @(
    # "PowerShellGet"
    # "AWSPowerShell" # -- SLOW
    # "CredentialManager"
    # "dbatools" # -- SLOW
    # "OData"
    # "OpenSSHUtils"
    "Posh-Docker"
    "Posh-Git"
    # "Posh-SSH" # - SLOW
    # "powershell-yaml"
    "PSReadline"
)

foreach ($module in $local_modules)
{
    Import-Module (Join-Path $ModulesDir $module)
}

foreach ($module in $modules)
{
    if (Get-Module -ListAvailable -Name ${module})
    {
    #  Write-Host "Module $module already exist"
    #  Get-Date -Format HH:mm:ss.fff
        Import-Module -Name $module
    }
    else
    {
        Install-Module -Scope AllUsers -Name ${module} -Force
        Write-Host "Module ${module} succesfully installed"
        Import-Module -Name ${module}
    }
}

# Posh git settings
# $GitPromptSettings.EnableFileStatus = $false
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "C:\a"         # Dev folder for big repos
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "C:\boost"     # Boost libs
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "${Env:USERPROFILE}\workspace\libs\boost"          # Boost libs
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "${Env:USERPROFILE}\workspace\libs\UnrealEngine"   # Unreal Engine

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}

$InstallPaths = @(
    'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise'
    'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional'
    'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community'
    'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools'
    'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Preview'
)

foreach ($InstallPath in $InstallPaths)
{
    $DevShell = (Join-Path "$InstallPath" 'Common7\Tools\Microsoft.VisualStudio.DevShell.dll')
    if (Test-Path "$DevShell")
    {
        Import-Module "$DevShell"
        ${function:vsdevenv}    = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" -DevCmdArguments -arch=x64 @args }
        ${function:vsdevenv32}  = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" -DevCmdArguments -arch=x86 @args }
        ${function:vsdevenv64}  = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" -DevCmdArguments -arch=x64 @args }
        ${function:dev}         = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" -DevCmdArguments -arch=x64 @args }
        ${function:dev32}       = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" -DevCmdArguments -arch=x86 @args }
        ${function:dev64}       = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" -DevCmdArguments -arch=x64 @args }
        $ENV:VSDevEnv = "True"
        break
    }
}

function Get-Manually-Installed-Modules
{
    Get-Module -ListAvailable |
    Where-Object ModuleBase -like $env:ProgramFiles\WindowsPowerShell\Modules\* |
    Sort-Object -Property Name, Version -Descending |
    Get-Unique -PipelineVariable Module |
    ForEach-Object {
        if (-not(Test-Path -Path "$($_.ModuleBase)\PSGetModuleInfo.xml"))
        {
            Find-Module -Name $_.Name -OutVariable Repo -ErrorAction SilentlyContinue |
            Compare-Object -ReferenceObject $_ -Property Name, Version |
            Where-Object SideIndicator -eq '=>' |
            Select-Object -Property Name, Version, @{label='Repository';expression={$Repo.Repository}}, @{label='InstalledVersion';expression={$Module.Version}}
        }
    }
}
