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

foreach($module in $local_modules) {
    Import-Module (Join-Path $ModulesDir $module)
}

foreach($module in $modules) {
    if (Get-Module -ListAvailable -Name $module ) {
    #  Write-Host "Module $module already exist"
    #  Get-Date -Format HH:mm:ss.fff
        Import-Module -Name $module
    } else {
        PowerShellGet\Install-Module $module
        Write-Host "Module $module succesfully installed"
        Import-Module -Name $module
    }
}

# Posh git settings
# $GitPromptSettings.EnableFileStatus = $false
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += 'C:\a'         # Dev folder for big repos
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += 'C:\boost'     # Boost libs

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
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

foreach($InstallPath in $InstallPaths) {
    $DevShell = (Join-Path "$InstallPath" 'Common7\Tools\vsdevshell\Microsoft.VisualStudio.DevShell.dll')
    if (Test-Path "$DevShell") {
        Import-Module "$DevShell"
        ${function:vsdevenv}    = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" @args }
        ${function:dev}         = { $curDir = Get-Location; Enter-VsDevShell -VsInstallPath "$InstallPath" -StartInPath "$curDir" @args }
        $ENV:VSDevEnv = "True"
        break
    }
}
