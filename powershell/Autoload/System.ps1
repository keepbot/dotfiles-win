# Clear screen
Set-Alias c Clear-Host

# Empty the Recycle Bin on all drives
function EmptyRecycleBin {
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | ForEach-Object {Remove-Item $_.Path -Recurse -Confirm:$false}
}
Set-Alias emptytrash Empty-RecycleBin

# Reload the shell
function Restart-Powershell {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = "-nologo"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
}
Set-Alias reload Reload-Powershell

# Update installed Ruby Gems, NPM, and their installed packages.
function Update-System() {
    # Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
    Update-Module
    Update-Help -Force
    # scoop update
    gem update --system
    gem update
    npm install npm -g
    npm update -g
    cup all -y
}
Set-Alias update System-Update

# Sudo
function sudo() {
    if ($args.Length -eq 1) {
        start-process $args[0] -verb "runAs"
    }
    if ($args.Length -gt 1) {
        start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}

# Show function code
${function:show-cmd} = { (Get-Command $args[0]).Definition }

function Stop-Beeper {
    # sc config beep start= disabled
    net stop beep
}
