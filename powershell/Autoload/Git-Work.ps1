<#
.SYNOPSIS
Personalized git scripts for work.

.DESCRIPTION
Personalized git scripts for work.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


# Git:
if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
    function grcpr
    {
        git fetch origin master
        git checkout DEV/Copyright
        git rebase master
    }

    function grcpr_push
    {
        git push --force origin DEV/Copyright
    }
}
