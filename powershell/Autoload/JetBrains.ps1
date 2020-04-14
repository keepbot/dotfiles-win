<#
.SYNOPSIS
JetBrains scripts.

.DESCRIPTION
JetBrains scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


function Get-JBList {
    $IdeaPaths = @(
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\AndroidStudio"
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\IDEA-U"
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\IDEA-C"
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\CLion"
    )
    return $IdeaPaths
}

function Find-JBApps {
    $apps = Get-JBList

    foreach($app in $apps) {
        if (Test-Path $app) {
            Write-Host " -> ${app}"
        }
    }
}
