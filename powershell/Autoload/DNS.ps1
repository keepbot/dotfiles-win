<#
.SYNOPSIS
DNS scripts.

.DESCRIPTION
DNS scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command dig.exe -ErrorAction SilentlyContinue | Test-Path)
{
    function dig-init
    {
        # mkdir $env:SystemRoot\System32\Drivers\etc\
        # Write-Output 'nameserver 8.8.8.8' > $env:SystemRoot\System32\Drivers\etc\resolv.conf
        # Write-Output 'nameserver 77.88.8.8' >> $env:SystemRoot\System32\Drivers\etc\resolv.conf
        Write-Output 'nameserver 1.1.1.1' > $env:SystemRoot\System32\Drivers\etc\resolv.conf
        Write-Output 'nameserver 1.0.0.1' > $env:SystemRoot\System32\Drivers\etc\resolv.conf
    }
}
