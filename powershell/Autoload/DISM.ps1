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
#
#
#
#
