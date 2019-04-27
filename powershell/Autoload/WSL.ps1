function Find-WSL() {
    wslconfig.exe /l @args
}

function Remove-WSL() {
    wslconfig.exe /u @args
}

function Set-WSL() {
    wslconfig.exe /s @args
}

function Stop-WSL() {
    wslconfig.exe /t @args
}

function Update-WSL() {
    wslconfig.exe /upgrade @args
}

function Get-WSL-UUID() {
    Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss
}

function Get-WSL-UUID-Short() {
    (Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss).Name
}
