<#
.SYNOPSIS
Jupyter scripts.

.DESCRIPTION
Jupyter scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


${function:jpn}      = { jupyter notebook @args }

function jp {
    <#
    .SYNOPSIS
        Wrapprer for Jupyter notebooks
    .DESCRIPTION
        Run and manage Jupyter environment in ~/.jpenv
    .PARAMETER NoteBookPath
        Path to Jupyter Notebook file.
    .PARAMETER Command
        Run specific commant for Jupyter. Default: 'notebook'
    .PARAMETER Port
        Specify non-default port to start Jupyter Notebook.
    .PARAMETER ReInstall
        Remove old Jupyter environment.
    .PARAMETER KeepEnv
        Do not deactivate virtual environment on exit.
    .EXAMPLE
        jp C:\Temp\Hello-World.ipynb
        jp .\Hello-World.ipynb
    .INPUTS
        String
        String
        Int
        Switch
        Switch
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>
    [CmdletBinding()]
    param (
        [string]$NoteBookPath = $null,
        [string]$Command = "notebook",
        [Int]$Port = 8888,
        [switch]$ReInstall,
        [switch]$KeepEnv
    )
    if (-Not (Get-Command python.exe -ErrorAction SilentlyContinue | Test-Path)) {
        Write-Host "ERROR: Python doesn't found in system Path. Exiting..." -ForegroundColor Red
        break
    }
    if (-Not (Get-Command virtualenv.exe -ErrorAction SilentlyContinue | Test-Path)) {
        python.exe -m pip install virtualenv
    }
    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    If ($ReInstall -And (Test-Path $jenvDir) ) {
        Remove-Item -Recurse -Force $jenvDir
    }
    If (-Not (Test-Path $jenvDir)) {
        $python = Get-Command python.exe | Select-Object -ExpandProperty Definition
        python.exe -m virtualenv -p $python $jenvDir
    }
    & $jenvDir\Scripts\activate.ps1
    If (-Not (Get-Command jupyter.exe -ErrorAction SilentlyContinue | Test-Path)) {
        python.exe -m pip install jupyter
    }
    If ($NoteBookPath) {
        jupyter.exe $Command --port $Port $NoteBookPath
    } Else {
        jupyter.exe $Command --port $Port
    }
    if (-Not $KeepEnv) {
        deactivate
    }
}

function jp-conf {
    <#
    .SYNOPSIS
        Jupyter environment configureation.
    .DESCRIPTION
        Jupyter environment configureation. Just activates python's virual env.
    .PARAMETER ReInstall
        Remove environment and install from scratch
    .EXAMPLE
        jpconf
        jpconf -ReInstall
    .INPUTS
        Switch
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>
    [CmdletBinding()]
    param (
        [switch]$ReInstall
    )
    if (-Not (Get-Command python.exe -ErrorAction SilentlyContinue | Test-Path)) {
        Write-Host "ERROR: Python doesn't found in system Path. Exiting..." -ForegroundColor Red
        break
    }
    if (-Not (Get-Command virtualenv.exe -ErrorAction SilentlyContinue | Test-Path)) {
        python.exe -m pip install virtualenv
    }
    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    If ($ReInstall -And (Test-Path $jenvDir) ) {
        Remove-Item -Recurse -Force $jenvDir
    }
    If (-Not (Test-Path $jenvDir)) {
        $python = Get-Command python.exe | Select-Object -ExpandProperty Definition
        python.exe -m virtualenv -p $python $jenvDir
    }
    # Set-Location $jenvDir
    & $jenvDir\Scripts\activate.ps1
}

function jp-install {
    <#
    .SYNOPSIS
        Install or update my set of module for Jupiter Nortebookss.
    .DESCRIPTION
        Install or update my set of modules for Jupiter Nortebooks.
    .PARAMETER ReInstall
        Remove environment and install from scratch
    .EXAMPLE
        jpconf
        jpconf -ReInstall
    .INPUTS
        Switch
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>
    [CmdletBinding()]
    param (
        [switch]$ReInstall
    )
    if (-Not (Get-Command python.exe -ErrorAction SilentlyContinue | Test-Path)) {
        Write-Host "ERROR: Python doesn't found in system Path. Exiting..." -ForegroundColor Red
        break
    }
    if (-Not (Get-Command virtualenv.exe -ErrorAction SilentlyContinue | Test-Path)) {
        python.exe -m pip install virtualenv
    }
    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    If ($ReInstall -And (Test-Path $jenvDir) ) {
        Remove-Item -Recurse -Force $jenvDir
    }
    If (-Not (Test-Path $jenvDir)) {
        $python = Get-Command python.exe | Select-Object -ExpandProperty Definition
        python.exe -m virtualenv -p $python $jenvDir
    }
    # Set-Location $jenvDir
    & $jenvDir\Scripts\activate.ps1
    python -m pip install --upgrade jupyter
    python -m pip install --upgrade numpy
    python -m pip install --upgrade matplotlib
    # python -m pip install --upgrade powershell_kernel
    # python -m powershell_kernel.install
    deactivate
}

function jp-remove {
    <#
    .SYNOPSIS
        Cleanup local Jupiter Environment.
    .DESCRIPTION
        Cleanup local Jupiter Environment.
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>
    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    If (Test-Path $jenvDir) {
        $title    = "Removing Jupiter Environment: $jenvDir"
        $question = 'Are you sure you want to remove it?'
        $choices  = '&Yes', '&No'

        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 0) {
            Remove-Item -Recurse -Force $jenvDir
        } else {
            Write-Host 'cancelled'
        }
    } else {
        Write-Host "ERROR: Jupiter Environment: $jenvDir doesn't exist. Exiting..." -ForegroundColor Red
    }
}
