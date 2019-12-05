function Get-SquishList {
    $mash = @(
        'C:\tools\Squish-x64\bin'
        'C:\tools\Squish-x86\bin'
    )
    return $mash
}

function Set-Squish {
    $mash = Get-SquishList
    $SquishVersions = @()
    foreach($squish in $mash) {
        $mashBin = (Join-Path $squish "squishserver.exe")
        if (Test-Path $mashBin) {
            $SquishVersions += $squish
        }
    }
    $ChoosenSquishVersion = Select-From-List $SquishVersions "Squish Version"
    [Environment]::SetEnvironmentVariable("SQUISH_PATH", $ChoosenSquishVersion, "Machine")
    # Set-Env
}

function Clear-Squish  {
    [Environment]::SetEnvironmentVariable("SQUISH_PATH", $null, "Machine")
    if ($env:SQUISH_PATH) {
        Remove-Item Env:SQUISH_PATH
    }
    # Set-Env
}
