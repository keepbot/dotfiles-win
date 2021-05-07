<#
.SYNOPSIS
WSL scripts.

.DESCRIPTION
WSL scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Find-WSL()
{
    wslconfig.exe /l @args
}

function Remove-WSL()
{
    wslconfig.exe /u @args
}

function Set-WSL()
{
    wslconfig.exe /s @args
}

function Stop-WSL()
{
    wslconfig.exe /t @args
}

function Update-WSL()
{
    wslconfig.exe /upgrade @args
}

function Get-WSL-UUID()
{
    Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss
}

function Get-WSL-UUID-Short()
{
    (Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss).Name
}
function List-WSLDistros()
{
    wsl.exe --list -v
}

function anyconnect-wsl-fix()
{
    Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"} | Set-NetIPInterface -InterfaceMetric 4000
    Get-NetIPInterface -InterfaceAlias "vEthernet (WSL)" | Set-NetIPInterface -InterfaceMetric 1
}

###
# Get-DnsClientServerAddress -AddressFamily IPv6 | Where-Object ServerAddresses -NE "{}" | Select-Object -ExpandProperty InterfaceAlias
# Get-NetAdapterBinding -ComponentID ms_tcpip6 | Where-Object Name -In (Get-DnsClientServerAddress -AddressFamily IPv6 | Where-Object ServerAddresses -NE "{}" | Select-Object -ExpandProperty InterfaceAlias)
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
