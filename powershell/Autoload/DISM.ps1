<#
.SYNOPSIS
DISM scripts.

.DESCRIPTION
DISM scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# TMP
# Dism /Unmount-Image /?
# Dism /Unmount-Image /MountDir:C:\Temp\WIM /Commit
# Dism /Unmount-Image /MountDir:C:\Temp\WIM /Discard

# Dism /Mount-Image /ImageFile:C:\Temp\install.wim /Name:"Windows 10 Pro" /MountDir:C:\Temp\WIM
# Dism /Mount-Image /ImageFile:C:\Temp\install.wim /Name:"Windows 10 Pro" /MountDir:C:\Temp\WIM /ReadOnly

# Dism /Image:C:\Temp\WIM /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All

# Dism /Image:C:\Temp\WIM /Get-Features
# Dism /Get-ImageInfo /ImageFile:C:\Temp\install.wim

# DISM /Image:C:\Temp\WIM /Cleanup-Image /RestoreHealth
# Dism /Online /Cleanup-Image /RestoreHealth /Source:wim:H:\sources\install.wim:1 /limitaccess ?????
#

function sys-repair
{
    DISM.exe /Online /Cleanup-image /Restorehealth
    sfc /scannow
    cmd /c 'findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"'

    # cat "${Env:USERPROFILE}\Desktop\sfcdetails.txt"

    # Check:
    # %WinDir%\WinSxS\Temp
    # %WinDir%\Logs\CBS\CBS.log

    # Replace a corrupted system file:
    # takeown /f Path_And_File_Name
    # icacls Path_And_File_Name /GRANT ADMINISTRATORS:F
    # copy Source_File Destination
}

function hyperv-repair
{
    dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
    Get-HNSNetwork | Remove-HNSNetwork
    netsh int ipv4 add excludedportrange protocol=tcp startport=50051 numberofports=1
    netsh int ipv4 set dynamic tcp start=49152 num=16384
    dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All
}
