$Env:PSModulePath  = "$(Get-Location)" + "$([System.IO.Path]::PathSeparator)${Env:PSModulePath}"
. Microsoft.PowerShell_profile.ps1
