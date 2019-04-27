#!/usr/env/pwsh
function Get-Du {
    <#
    .SYNOPSIS
      Show sizes of all sub-folders.
    .DESCRIPTION
      Show sizes of all sub-folders.
    .PARAMETER Path
      Path to target foder.
    .EXAMPLE
      Get-Du C:\
    .INPUTS
      String
    .OUTPUTS
      None
    .NOTES
      Written by: Dmitriy Ivanov
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$Path = $(Get-Location),
        [ValidateNotNullOrEmpty()]
        [string]$Precision = 5
    )
    Get-ChildItem ${Path} -Hidden | ForEach-Object {
        "{0} {1:N${Precision}} MB" -f ($_.Name), ((Get-ChildItem $(Join-Path ${Path} ${_}) -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
    }
    Get-ChildItem ${Path} | ForEach-Object {
        "{0} {1:N${Precision}} MB" -f ($_.Name), ((Get-ChildItem $(Join-Path ${Path} ${_}) -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
    }
}
