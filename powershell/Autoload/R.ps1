<#
.SYNOPSIS
R Project scripts.

.DESCRIPTION
R Project scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# R aliases
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path)
{
    Set-Alias -Name R -Value R.exe -Force -Option AllScope
    ${function:rver} = { echo 'paste0(version[c("major","minor")], collapse = ".")' | R.exe --no-save --no-echo }
}

function Get-RProjectPaths
{
    $rPaths = @(
        'C:\Program Files\R\R-4.0.4\bin\i386'
        'C:\Program Files\R\R-4.0.4\bin\x64'
        'C:\Program Files\R\R-4.0.3\bin\i386'
        'C:\Program Files\R\R-4.0.3\bin\x64'
        'C:\Program Files\Microsoft\R Open\R-3.5.3\bin\x64'
        'C:\Program Files\Microsoft\R Open\R-3.6.3\bin\x64'
        'C:\Program Files\Microsoft\R Open\R-4.0.2\bin\x64'
    )
    return $rPaths
}

function Find-RProjects
{
    $rPathList = Get-RProjectPaths

    Write-Host "List of R interpretators on this PC:"
    foreach ($r in $rPathList)
    {
        $rBin = (Join-Path $r "R.exe")

        if (Test-Path $rBin)
        {
            Write-Host "- [$($(& $rBin --version 2>&1)[0] -replace '\D+(\d.\d.\d+)\D.*','$1')] -> $r"
        }
    }
}

function Set-RProject
{
    $rPathList = Get-RProjectPaths
    $ValidatedVersions = @()
    $Versions = @()

    foreach ($r in $rPathList)
    {
        $rBin = (Join-Path $r "R.exe")

        if (Test-Path $rBin)
        {
            $ValidatedVersions += $r
            $Versions += "$($(& $rBin --version 2>&1)[0] -replace '\D+(\d.\d.\d+)\D.*','$1')"
        }
    }

    $ChoosenVersion = Select-From-List $ValidatedVersions "R Prokect Version" $Versions
    [Environment]::SetEnvironmentVariable("RPROJECT_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:RPROJECT_PATH -Value "$ChoosenVersion"
    # Set-Env
}

function Clear-RProject
{
    [Environment]::SetEnvironmentVariable("RPROJECT_PATH", $null, "Machine")
    if ($env:RPROJECT_PATH)
    {
        Remove-Item Env:RPROJECT_PATH
    }
    # Set-Env
}
