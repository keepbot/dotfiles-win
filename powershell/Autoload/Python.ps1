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
