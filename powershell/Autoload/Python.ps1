<#
.SYNOPSIS
Python scripts.

.DESCRIPTION
Python scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


# Python virtualenv aliases - personal
if (Get-Command c:\tools\python2\python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc2}     = { c:\tools\python2\python.exe -m virtualenv -p c:\tools\python2\python.exe venv } # init py2 venv in curent dir
}

if (Get-Command c:\tools\python2\python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc2-32}  = { c:\tools\python2_x86\python.exe -m virtualenv -p c:\tools\python2_x86\python.exe venv } # init py2 venv in curent dir x86
}

if (Get-Command c:\tools\python3\python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc3}     = { c:\tools\python3\python.exe -m virtualenv -p c:\tools\python3\python.exe venv } # init py3 venv in curent dir
}

if (Get-Command c:\tools\python3\python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc3-32}  = { c:\tools\python3_x86\python.exe -m virtualenv -p c:\tools\python3_x86\python.exe venv } # init py3 venv in curent dir x86
}

if (Get-Command python.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:vc}      = { ($python = Get-Command python.exe | Select-Object -ExpandProperty Definition); python.exe -m virtualenv -p $python venv }
    ${function:va}      = { .\venv\Scripts\activate }
    ${function:vd}      = { deactivate }
    ${function:vr}      = { rmrf venv }
    ${function:vpi}     = { python.exe -m pip install  }
    ${function:vins}    = { If (-Not (Test-Path venv)){vc}; va; python.exe -m pip install -r .\requirements.txt }
    ${function:vgen}    = { va; python.exe -m pip freeze > .\requirements.txt }

    # Basic environment
    ${function:pip-update}      = { python.exe -m pip install --upgrade pip }
    ${function:venv-install}    = { python.exe -m pip install virtualenv }
    ${function:ipython-install} = { python.exe -m pip install ipython }

    function py_venv
    {
        python -m pip install --upgrade pip
        python -m pip install --upgrade virtualenv
        python -m pip install --upgrade ipython
    }

    function pyclean
    {
        [string] $SessionID = [System.Guid]::NewGuid()
        $TempFreezeFile  = (Join-Path "${Env:Temp}" "${SessionID}")
        python -m pip freeze > "${TempFreezeFile}"
        python -m pip uninstall -y -r "${TempFreezeFile}"
        Remove-Item -Force "${TempFreezeFile}"
        # python.exe -m pip freeze | %{ $_.split('==')[0] } | %{ python.exe -m pip install --upgrade $_ }
        python -m pip install --upgrade pip
        python -m pip install --upgrade virtualenv
    }

    ${function:py_srv} = { python -m http.server }
}

function Get-PyList
{
    $serpents = @(
        'C:\Python38'
        'C:\Python37'
        'C:\Python36'
        'C:\Python35'
        'C:\Python34'
        'C:\Python27'
        'C:\Python26'
        'C:\Python25'
        'C:\Python38-32'
        'C:\Python37-32'
        'C:\Python36-32'
        'C:\Python35-32'
        'C:\Python34-32'
        'C:\Python27-32'
        'C:\Python26-32'
        'C:\Python25-32'
        "$env:LOCALAPPDATA\Programs\Python\Python38"
        "$env:LOCALAPPDATA\Programs\Python\Python37"
        "$env:LOCALAPPDATA\Programs\Python\Python36"
        "$env:LOCALAPPDATA\Programs\Python\Python35"
        "$env:LOCALAPPDATA\Programs\Python\Python27"
        "$env:LOCALAPPDATA\Programs\Python\Python26"
        "$env:LOCALAPPDATA\Programs\Python\Python25"
        "$env:LOCALAPPDATA\Programs\Python\Python38-32"
        "$env:LOCALAPPDATA\Programs\Python\Python37-32"
        "$env:LOCALAPPDATA\Programs\Python\Python36-32"
        "$env:LOCALAPPDATA\Programs\Python\Python35-32"
        "$env:LOCALAPPDATA\Programs\Python\Python27-32"
        "$env:LOCALAPPDATA\Programs\Python\Python26-32"
        "$env:LOCALAPPDATA\Programs\Python\Python25-32"
        'C:\tools\python3'
        'C:\tools\python3_x86'
        'C:\tools\python2'
        'C:\tools\python2_x86'
        'C:\tools\miniconda3'
        'C:\tools\miniconda2'
        'C:\tools\python-embed-38-x64'
        'C:\tools\python-embed-38-win32'
    )
    return $serpents
}

function List-Py
{
    $serpents = Get-PyList

    Write-Host "List of Python interpretators on this PC:"
    foreach($snake in $serpents)
    {
        $snakeBin = (Join-Path $snake "python.exe")
        if (Test-Path $snakeBin)
        {
            Write-Host "- [$($( & $snakeBin --version 2>&1) -replace '\D+(\d+...)','$1')] -> $snake"
        }
    }
}

function Set-Py
{
    $serpents = Get-PyList
    $ValidatedSerpents = @()
    $Versions = @()
    foreach($snake in $serpents)
    {
        $snakeBin = (Join-Path $snake "python.exe")
        if (Test-Path $snakeBin)
        {
            $ValidatedSerpents += $snake
            $Versions += "$($( & $snakeBin --version 2>&1) -replace '\D+(\d+...)','$1')"
        }
    }
    $ChoosenVersion = Select-From-List $ValidatedSerpents "Python Version" $Versions
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:PYTHON_PATH -Value "$ChoosenVersion"

    [Environment]::SetEnvironmentVariable("PYTHONPATH", "${ChoosenVersion}\Lib\;${ChoosenVersion}\DLLs\", "Machine")
    Set-Item -Path Env:PYTHONPATH -Value "${ChoosenVersion}\Lib\;${ChoosenVersion}\DLLs\"
    # Set-Env
}

function Clear-Py
{
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", $null, "Machine")
    if ($env:PYTHON_PATH)
    {
        Remove-Item Env:PYTHON_PATH
    }

    [Environment]::SetEnvironmentVariable("PYTHONPATH", $null, "Machine")
    if ($env:PYTHONPATH)
    {
        Remove-Item Env:PYTHONPATH
    }
    # Set-Env
}
