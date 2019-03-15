function WSL-List() {
    wslconfig.exe /l @args
}

function WSL-Remove() {
    wslconfig.exe /u @args
}

function WSL-Set() {
    wslconfig.exe /s @args
}

function WSL-Terminate() {
    wslconfig.exe /t @args
}

function WSL-Upgrade() {
    wslconfig.exe /upgrade @args
}

function WSL-UUID() {
    Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss
}

function WSL-UUID-Short() {
    (Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss).Name
}
