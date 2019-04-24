function List-QT {
    <#
    .SYNOPSIS
      List QT Framework versions on current PC.

    .DESCRIPTION
      List QT Framework versions on current PC.

    .EXAMPLE
      List-QT

    .INPUTS
      None

    .OUTPUTS
      None

    .NOTES
      Written by: Dmitriy Ivanov
    #>

    if (Test-Path "C:\Qt") {
      $QTVersions = $(((Get-ChildItem "C:\Qt").Name) -replace '\D+(\d+.)','$1')
    }

    Write-Host "List of QT Toolset on this PC:"
    if ($QTVersions) {
      foreach($v in $QTVersions) {
            $CurrentQT = "C:\Qt\Qt" + $v+ "\" + $v
            (Get-ChildItem $CurrentQT).Name | ForEach-Object{
                If ($_ -match "Src" -Or $_ -match "sha1s.txt"){
                    continue
                }
                Write-Host " -"$v" -> "$_
            }
        }
    }
}

function Set-QT {
    <#
    .SYNOPSIS
      Set QT Framework version on current PC.

    .DESCRIPTION
      Set QT Framework version on current PC.

    .EXAMPLE
      Set-QT

    .INPUTS
      None

    .OUTPUTS
      None

    .NOTES
      Written by: Dmitriy Ivanov
    #>

    if (Test-Path "C:\Qt") {
      $QTVersions = $(((Get-ChildItem "C:\Qt").Name) -replace '\D+(\d+.)','$1')
    } else {
        Write-Host "ERROR: QT doesn't installed to path 'C:\Qt'..." -ForegroundColor Red
        break
    }

    $ChoosenQTVersion = Select-From-List $QTVersions "QT Version"

    $CurrentQTPath = "C:\Qt\Qt" + $ChoosenQTVersion + "\" + $ChoosenQTVersion
    $QTToolsets = @()
    (Get-ChildItem $CurrentQTPath).Name | ForEach-Object{
        If ($_ -Match "^Src$" -Or $_ -Match "^sha1s.txt$") {
            return
        }
        $QTToolsets += $_
    }


    $ChoosenQTToolset = Select-From-List $QTToolsets "QT Toolset"

    [Environment]::SetEnvironmentVariable("QTDIR", "$CurrentQTPath\$ChoosenQTToolset", "Machine")
    $env:QTDIR = "$CurrentQTPath\$ChoosenQTToolset"
    [Environment]::SetEnvironmentVariable("QMAKESPEC", "$CurrentQTPath\$ChoosenQTToolset\mkspecs\win32-msvc", "Machine")
    $env:QMAKESPEC = "$CurrentQTPath\$ChoosenQTToolset\mkspecs\win32-msvc"
}

function UnSet-QT {
    [Environment]::SetEnvironmentVariable("QTDIR", $null, "Machine")
    [Environment]::SetEnvironmentVariable("QMAKESPEC", $null, "Machine")
    if ($env:QTDIR) {
        Remove-Item Env:QTDIR
    }
    if ($env:QMAKESPEC) {
        Remove-Item Env:QMAKESPEC
    }
}
