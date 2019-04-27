function Remove-WAPP {
    if ($args.Count -ne 1) {
        Write-Host "Usage: rm-wapp <package_mask>"
    }
    else {
        Get-AppxPackage *$($args[0].ToString())* | Remove-AppxPackage
    }
}

function Get-WAPP {
    if ($args.Count -ne 1) {
        Write-Host "Usage: get-wapp <package_mask>"
    }
    else {
        Get-AppxPackage *$($args[0].ToString())*
    }
}

function Install-WAPP {
    Get-AppxPackage *$($args[0].ToString())* | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}

function Install-WAPP-all {
    Get-AppxPackage -AllUsers| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}
