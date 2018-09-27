#!/usr/env/pwsh
function Set-VC {
  <#
  .SYNOPSIS
    Enable to use particular version of Visual Compiler.

  .DESCRIPTION
    Enable to use particular version of Visual Compiler.

  .EXAMPLE
    Set-VC

  .INPUTS
    None

  .OUTPUTS
    None

  .NOTES
    Written by: Dmitriy Ivanov
  #>

  $tools = @(
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise'
  )

  # $versions = ''

  foreach($tool in $tools) {
    if (Test-Path "$tool\VC\Tools\MSVC\") {
      # "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.15.26726\bin\Hostx64\x64"
      foreach($ver in $(Get-ChildItem "$tool\VC\Tools\MSVC").Name ) {
        $versions += $(Get-ChildItem "$tool\VC\Tools\MSVC\$ver\bin\Hostx86").FullName
        $versions += $(Get-ChildItem "$tool\VC\Tools\MSVC\$ver\bin\Hostx64").FullName
      }
    }
  }


  do {
    $x = 0
    foreach($ver in $versions) {
      $x = $x + 1
      Write-Host "`t[$x]" $ver
    }

    Write-Host

    $regexp = '^['
    foreach($y in 1..$x){
      $regexp += $y
    }
    $regexp += ']$'

    Write-Host
    $choice = Read-Host -Prompt "`tSelect VC from the list"

    $ok = $choice -match $regexp

    if ( -not $ok) {
      Write-Host "`tERROR: Invalid selection"
    } else {
      [Environment]::SetEnvironmentVariable("VC_PATH", $versions[$choice - 1], "Machine")
      $env:VC_PATH = $versions[$choice - 1]
    }
  } until ( $ok )



}

function List-VC {
  <#
  .SYNOPSIS
    List Visual Compiler versions on current PC.

  .DESCRIPTION
    List Java version on current PC.

  .EXAMPLE
    List-VC

  .INPUTS
    None

  .OUTPUTS
    String Array

  .NOTES
    Written by: Dmitriy Ivanov
  #>

  $VS_Comunity = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community'
  $VS_BuildTools = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools'
  #$VS_Professional = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional'
  #$VS_Enterprise = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise'


#   if (Test-Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\')
  if (Test-Path "$VS_Comunity\VC\Tools\MSVC\") {
    $ComunityVersions = $((Get-ChildItem "$VS_Comunity\VC\Tools\MSVC\").Name)
  }

  if (Test-Path "$VS_BuildTools\VC\Tools\MSVC\") {
    $BuildToolsVersions = $((Get-ChildItem "$VS_BuildTools\VC\Tools\MSVC\").Name)
  }

  Write-Host "List of VC versions on this PC:"
  if ($ComunityVersions) {
    foreach($v in $ComunityVersions) {Write-Host " -" $v " (VS Comunity)"}
  }

  if ($BuilderVersions) {
    foreach($v in $BuildToolsVersions) {Write-Host " -" $v " (VS BuildTools)"}
  }
}
