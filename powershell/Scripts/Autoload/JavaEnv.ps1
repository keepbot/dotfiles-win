#!/usr/env/pwsh
function Use-Java {
  <#
  .SYNOPSIS
    Enable to use particular version of JAVA within current session.

  .DESCRIPTION
    Enable to use particular version of JAVA within current session.

  .PARAMETER JavaVersion
    Version of jdk.

  .PARAMETER Arch
    Processor architecture x86 or X64(default).

  .EXAMPLE
    Use-Java jdk-10.0.1

  .INPUTS
    String

  .OUTPUTS
    None

  .NOTES
    Written by: Dmitriy Ivanov
  #>
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true)]
      [string]$JavaVersion,
      [ValidateNotNullOrEmpty()]
      [string]$Arch = "x64"
  )

  switch ($Arch) {
    "x64" {
      $Versions = $((Get-ChildItem 'C:\Program Files\Java\').Name)
      if ($Versions.Contains(${JavaVersion})) {
        [Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\${JavaVersion}", "Machine")
        $env:JAVA_HOME = "C:\Program Files\Java\${JavaVersion}"
        $env:PATH = "${env:JAVA_HOME}\bin;${env:PATH}"
      }
      else {
        Write-Host "JAVA `"${JavaVersion}`" does not exist. Please use one of following:"
        foreach($v in $Versions){
          Write-Host " -" $v
        }
      }
      break
    }
    "x86" {
      $Versions = $((Get-ChildItem 'C:\Program Files (x86)\Java\').Name)
      if ($Versions.Contains(${JavaVersion})) {
        [Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files ($Arch)\Java\${JavaVersion}", "Machine")
        $env:JAVA_HOME = "C:\Program Files ($Arch)\Java\${JavaVersion}"
        $env:PATH = "${env:JAVA_HOME}\bin;${env:PATH}"
      }
      else {
        Write-Host "JAVA `"${JavaVersion}`" does not exist. Please use one of following:"
        foreach($v in $Versions){
          Write-Host " -" $v
        }
      }
      break
    }
    default {
      Write-Error -Message "ERROR: Wrong processor architecture!"
      break
    }
 }
}

function List-Java {
  <#
  .SYNOPSIS
    List Java version on current PC.

  .DESCRIPTION
    List Java version on current PC.

  .PARAMETER Arch
    Processor architecture x86 or X64(default).

  .EXAMPLE
    List-Java x64

  .INPUTS
    String

  .OUTPUTS
    String Array

  .NOTES
    Written by: Dmitriy Ivanov
  #>
  [CmdletBinding()]
  param (
      [ValidateNotNullOrEmpty()]
      [string]$Arch = "x64"
  )

  switch ($Arch) {
    "x64" {
      $Versions = $((Get-ChildItem 'C:\Program Files\Java\').Name)
      break
    }
    "x86" {
      $Versions = $((Get-ChildItem 'C:\Program Files (x86)\Java\').Name)
      break
    }
    default {
      Write-Error -Message "ERROR: Wrong processor architecture!"
      break
    }
  }

    Write-Host "List of JAVA installef for ${Arch} on this PC:"
    foreach($v in $Versions) {Write-Host " -" $v}
}
