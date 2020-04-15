# Chocolatey
If (-Not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
  Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
If (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe") {
  $candies = @(
    "7zip.install"
    "adobereader"
    "awscli"
    "bind-toolsonly"
    "cmake"
    "cmdermini"
    "curl"
    "graphviz"
    "greenshot"
    "hxd"
    "jq"
    "kdiff3"
    "keystore-explorer.portable"
    "llvm"
    "mingw"
    "nasm"
    "ninja"
    "nmap"
    "notepadplusplus-npppluginmanager"
    "notepadplusplus"
    "nssm"
    "nuget.commandline"
    "nugetpackageexplorer"
    "openssh"
    "openssl.light"
    "paint.net"
    "putty"
    # choco install -y python2 --params /InstallDir:C:\tools\python2
    # choco install -y python3 --params /InstallDir:C:\tools\python3
    "rdcman"
    "slack"
    "svn"
    "terraform"
    "wget"
    "windirstat"
    "windjview"
    # choco install -y yed --params /Associate
    )

    foreach ($mars in $candies) {
        choco install -y -r $mars
    }
}

