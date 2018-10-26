#requires -version 3
$profileDir         = Split-Path -Parent $profile
$ScriptName         = [io.path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

# Write-Host ${profileDir}\Modules\W10Init\Win10.ps1 -include "${profileDir}\Modules\W10Init\Win10.psm1" -preset "${PSScriptRoot}\${ScriptName}.preset"
# & ${profileDir}\Modules\W10Init\Win10.ps1 -include "${profileDir}\Modules\W10Init\Win10.psm1" -preset "${PSScriptRoot}\${ScriptName}.preset"

# Write-Host "${PSScriptRoot}\${ScriptName}.cmd" "${profileDir}\Modules\W10Init\Win10" "${PSScriptRoot}\${ScriptName}.preset"
& "${PSScriptRoot}\${ScriptName}.cmd" "${profileDir}\Modules\W10Init\Win10" "${PSScriptRoot}\${ScriptName}.preset"
