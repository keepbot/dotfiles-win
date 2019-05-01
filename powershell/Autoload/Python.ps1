# Python aliases
if (Get-Command c:\tools\python2\python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc2}     = { c:\tools\python2\python.exe -m virtualenv -p c:\tools\python2\python.exe venv } # init py2 venv in curent dir
}
if (Get-Command c:\tools\python3\python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc3}     = { c:\tools\python3\python.exe -m virtualenv -p c:\tools\python3\python.exe venv } # init py3 venv in curent dir
}
if (Get-Command python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc}      = { ($python = Get-Command python.exe | Select-Object -ExpandProperty Definition); python.exe -m virtualenv -p $python venv }
    ${function:va}      = { .\venv\Scripts\activate}
    ${function:vd}      = { deactivate }
    ${function:vr}      = { rmrf venv }
    ${function:vins}    = { If (-Not (Test-Path venv)){vc}; va; python.exe -m pip install -r .\requirements.txt }
    ${function:vgen}    = { va; python.exe -m pip freeze > .\requirements.txt }

    # Update
    function pyupdate {
        python.exe -m pip install --upgrade pip
        python.exe -m pip install --upgrade virtualenv
        python.exe -m pip install --upgrade ipython
    }
}

function Get-PyList {
    $serpents = @(
        'C:\tools\python2'
        'C:\tools\python3'
        'C:\tools\miniconda2'
        'C:\tools\miniconda3'
        'C:\Python25'
        'C:\Python26'
        'C:\Python27'
        'C:\Python34'
        'C:\Python35'
        'C:\Python36'
        'C:\Python37'
        "$env:LOCALAPPDATA\Programs\Python\Python25"
        "$env:LOCALAPPDATA\Programs\Python\Python26"
        "$env:LOCALAPPDATA\Programs\Python\Python27"
        "$env:LOCALAPPDATA\Programs\Python\Python35"
        "$env:LOCALAPPDATA\Programs\Python\Python36"
        "$env:LOCALAPPDATA\Programs\Python\Python37"
    )
    return $serpents
}

function Find-Py {
    <#
    .SYNOPSIS
        List installed Python versions on current PC.
    .DESCRIPTION
        List installed Python versions on current PC.
    .EXAMPLE
        Find-Py
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>

    $serpents = Get-PyList

    Write-Host "List of Python interpretators on this PC:"
    foreach($snake in $serpents) {
        $snakeBin = (Join-Path $snake "python.exe")
        if (Test-Path $snakeBin) {
            Write-Host "- [$($( & $snakeBin --version 2>&1) -replace '\D+(\d+...)','$1')] -> $snake"
        }
    }
}

function Set-Py {
    <#
    .SYNOPSIS
        Set Python version on current PC.
    .DESCRIPTION
        Set Python version on current PC.
    .EXAMPLE
        Set-Py
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>
    $serpents = Get-PyList
    $PyVersions = @()
    foreach($snake in $serpents) {
        $snakeBin = (Join-Path $snake "python.exe")
        if (Test-Path $snakeBin) {
            $PyVersions += $snake
        }
    }
    $ChoosenPyVersion = Select-From-List $PyVersions "Python Version"
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", $ChoosenPyVersion, "Machine")
    Set-Env
}

function Clear-Py {
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", $null, "Machine")
    if ($env:PYTHON_PATH) {
        Remove-Item Env:PYTHON_PATH
    }
    Set-Env
}
