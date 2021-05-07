#!/usr/bin/env bash

TMP=$(mktemp)
trap ctrlC INT

removeTempFiles()
{
    rm -f $TMP
}

ctrlC()
{
    echo
    echo "Trapped Ctrl-C, removing temporary files"
    removeTempFiles
    stty sane
}

echo "Current resolv.conf"
echo "-------------------"
cat /etc/resolv.conf

echo
echo "Creating new resolv.conf"
echo "------------------------"

{
    # head -1 /etc/resolv.conf | grep '^#.*generated'
    # tail -n+2 /etc/resolv.conf | grep -v '^nameserver'
    grep -v '^nameserver' /etc/resolv.conf
    for i in $(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command 'Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"} | Get-DnsClientServerAddress -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses')
    do
        echo nameserver $i
    done
    for i in `/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command 'Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Wireless"} | Get-DnsClientServerAddress -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses'`
    do
        echo nameserver $i
    done
    echo nameserver 1.1.1.1
} | tr -d '\r' | tee $TMP

(set -x; sudo cp -i $TMP /etc/resolv.conf)

removeTempFiles
