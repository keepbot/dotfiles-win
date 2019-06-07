if (Get-Command dig.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:dig-init} = {
        # mkdir $env:SystemRoot\System32\Drivers\etc\
        Write-Output 'nameserver 8.8.8.8' > $env:SystemRoot\System32\Drivers\etc\resolv.conf
        Write-Output 'nameserver 77.88.8.8' >> $env:SystemRoot\System32\Drivers\etc\resolv.conf
    }
}
