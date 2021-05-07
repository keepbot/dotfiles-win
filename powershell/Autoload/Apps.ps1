<#
.SYNOPSIS
Application scripts.

.DESCRIPTION
Application scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-InstalledApps
{
    # Alternative
    # wmic
    # wmic:root\cli>/output:D:\Temp\installed2.txt product get name,version

    $location = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    Get-ItemProperty $location | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize
}
