#requires -version 3
$profileDir         = Split-Path -Parent $profile
$ScriptName         = [io.path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

# Write-Host ${profileDir}\Modules\Win10-Initial-Setup-Script\Win10.ps1 -include "${profileDir}\Modules\Win10-Initial-Setup-Script\Win10.psm1" -preset "${PSScriptRoot}\${ScriptName}.preset"
& ${profileDir}\Modules\Win10-Initial-Setup-Script\Win10.ps1 -include "${profileDir}\Modules\Win10-Initial-Setup-Script\Win10.psm1" -preset "${PSScriptRoot}\${ScriptName}.preset"
