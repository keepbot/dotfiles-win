function rm-wapp {
  if ($args.Count -ne 1) {
    Write-Host "Usage: rm-wapp <package_mask>"
  }
  else {
    Get-AppxPackage *$($args[0].ToString())* | Remove-AppxPackage
  }
}

function get-wapp {
  if ($args.Count -ne 1) {
    Write-Host "Usage: get-wapp <package_mask>"
  }
  else {
    Get-AppxPackage *$($args[0].ToString())*
  }
}

function re-wapp {
  Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}
