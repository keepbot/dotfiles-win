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

function VC-Vars-All {
  <#
    .SYNOPSIS
      Script to initialize all VC Variables.
    .DESCRIPTION
      Script to initialize all VC Variables.
    .PARAMETER Arch
      Architecture.
    .PARAMETER SDK
      Version of Windows SDK.
    .PARAMETER Platform
      Microsoft platform None, store or uwp.
    .PARAMETER VC
      Version Visual Studio.
    .PARAMETER Spectre
      Use for VS 2017 libraries with spectre mitigations.
    .PARAMETER Help
      Show help message.
    .INPUTS
      None
    .OUTPUTS
      None
    .NOTES
      Version:        1.0
      Author:         Dmitriy Ivanov
      Creation Date:  2019-01-14
    .EXAMPLE
      VC-Vars-All x86_amd64
      VC-Vars-All x86_amd64 10.0.10240.0
      VC-Vars-All x86_arm uwp 10.0.10240.0
      VC-Vars-All x86_arm onecore 10.0.10240.0 -vcvars_ver=14.0
      VC-Vars-All x64 8.1
      VC-Vars-All x64 store 8.1

  #>
  [CmdletBinding()]

  param (
    [ValidateNotNullOrEmpty()]
    [string]$Arch = "x86",
    [ValidateNotNullOrEmpty()]
    [string]$SDK = "8.1",
    [string]$Platform,
    [string]$VC,
    [switch]$Spectre,
    [switch]$Help
  )

  if ($Help) {
    Write-Host '
    Syntax:
      VC-Vars-All [-Arch <string>] [-SDK <string>] [-Platform <string>] [-VC <string>] [-Spectre] [-Help]
    where :
      [Arch]    : x86 | amd64 | x86_amd64 | x86_arm | x86_arm64 | amd64_x86 | amd64_arm | amd64_arm64
      [SDK]     : full Windows 10 SDK number (e.g. 10.0.10240.0) or "8.1" to use the Windows 8.1 SDK.
      [Platform]: {empty} | store | uwp
      [VC]      : {none} for default VS 2017 VC++ compiler toolset |
                  "14.0" for VC++ 2015 Compiler Toolset |
                  "14.1x" for the latest 14.1x.yyyyy toolset installed (e.g. "14.11") |
                  "14.1x.yyyyy" for a specific full version number (e.g. 14.11.25503)
      [Spectre] : Flag to set -vcvars_spectre_libs=spectre
      [Help]    : Flag to show this help message, all other parameters will be ignored
    '
    return
  }

  $VC_Distros = @(
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat'
    'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat'
  )

  $cmd_string = "cmd /c "

  foreach($distro in $VC_Distros) {
    if (Test-Path "$distro") {
      $cmd_string += "`'`"" + $distro + "`" " + $Arch
      break
    }
  }

  if ($Platform) {
    $cmd_string += " " + $Platform
  }

  $cmd_string += " " + $SDK

  if ($VC) {
    $cmd_string += " -vcvars_ver=" + $VC
  }

  if ($Spectre) {
    $cmd_string += " -vcvars_spectre_libs=spectre"
  }

  $cmd_string += "` & set'"

  Write-Host "$cmd_string"

  Invoke-Expression $cmd_string |
  ForEach-Object {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
    }
  }
}
