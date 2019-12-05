if ($env:SQUISH_PATH) {
    if (Get-Command "${env:SQUISH_PATH}\..\python\python.exe" -ErrorAction SilentlyContinue | Test-Path) {
        ${function:vc3-squish}  = { & ${env:SQUISH_PATH}\..\python\python.exe -m virtualenv -p ${env:SQUISH_PATH}\..\python\python.exe venv }
    }
}

function Get-SquishList {
    $mash = @(
        'C:\tools\Squish-x64'
        'C:\tools\Squish-x86'
    )
    return $mash
}

function Set-Squish {
    $mash = Get-SquishList
    $SquishVersions = @()
    foreach($squish in $mash) {
        if (Test-Path $squish) {
            $SquishVersions += $squish
        }
    }
    $ChoosenSquishVersion = Select-From-List $SquishVersions "Squish Version"
    [Environment]::SetEnvironmentVariable("SQUISH_PATH", $ChoosenSquishVersion, "Machine")
    [Environment]::SetEnvironmentVariable("SQUISH_LICENSEKEY_DIR", $ChoosenSquishVersion, "Machine")
    [Environment]::SetEnvironmentVariable("SquishBinDir", "${ChoosenSquishVersion}\bin", "Machine")

    # Set-Env
}

function Clear-Squish  {
    [Environment]::SetEnvironmentVariable("SQUISH_PATH", $null, "Machine")
    if ($env:SQUISH_PATH) {
        Remove-Item Env:SQUISH_PATH
    }
    # Set-Env
}
