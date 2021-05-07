<#
.SYNOPSIS
System scripts.

.DESCRIPTION
System scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Clear screen
Set-Alias c Clear-Host

# Empty the Recycle Bin on all drives
function EmptyRecycleBin
{
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | ForEach-Object {Remove-Item $_.Path -Recurse -Confirm:$false}
}
Set-Alias emptytrash Empty-RecycleBin


# Reload the shell
function Restart-Powershell
{
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = "-nologo"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
}


function Reload-Powershell
{
    function Invoke-PowerShell
    {
        if ($PSVersionTable.PSEdition -eq "Core")
        {
            pwsh -ExecutionPolicy Bypass -NoLogo -NoExit
        }
        else
        {
            powershell -ExecutionPolicy Bypass -NoLogo -NoExit
        }
    }

    # $parentProcessId = (Get-WmiObject Win32_Process -Filter "ProcessId=$PID").ParentProcessId
    # $parentProcessName = (Get-WmiObject Win32_Process -Filter "ProcessId=$parentProcessId").ProcessName

    if ($host.Name -eq 'ConsoleHost')
    {
            Invoke-PowerShell
    }
    else
    {
        Write-Warning 'Only usable while in the PowerShell console host'
    }
    exit
}
Set-Alias reload Reload-Powershell


function Refresh-Powershell
{
    . $profile
}
Set-Alias refresh Refresh-Powershell


# Update installed Ruby Gems, NPM, and their installed packages.
function Update-System()
{
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
function sudo()
{
    if ($args.Length -eq 1)
    {
        start-process $args[0] -verb "runAs"
    }

    if ($args.Length -gt 1)
    {
        start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}


function Stop-Beeper
{
    # sc config beep start= disabled
    net stop beep
}


function Get-WindowsKey
{
    ## function to retrieve the Windows Product Key from any PC
    ## by Jakob Bindslet (jakob@bindslet.dk)
    param
    (
        $targets = "."
    )
    $hklm = 2147483650
    $regPath = "Software\Microsoft\Windows NT\CurrentVersion"
    $regValue = "DigitalProductId"
    foreach ($target in $targets)
    {
        $productKey = $null
        $win32os = $null
        $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
        $data = $wmi.GetBinaryValue($hklm,$regPath,$regValue)
        $binArray = ($data.uValue)[52..66]
        $charsArray = "B","C","D","F","G","H","J","K","M","P","Q","R","T","V","W","X","Y","2","3","4","6","7","8","9"

        ## decrypt base24 encoded binary data
        for ($i = 24; $i -ge 0; $i--)
        {
            $k = 0
            for ($j = 14; $j -ge 0; $j--)
            {
                $k = $k * 256 -bxor $binArray[$j]
                $binArray[$j] = [math]::truncate($k / 24)
                $k = $k % 24
            }

            $productKey = $charsArray[$k] + $productKey
            if (($i % 5 -eq 0) -and ($i -ne 0))
            {
                $productKey = "-" + $productKey
            }
        }

        # Write-host "Here:" + $productKey
        $win32os = Get-WmiObject Win32_OperatingSystem -computer $target
        $obj = New-Object Object
        $obj | Add-Member Noteproperty Computer -value $target
        $obj | Add-Member Noteproperty Caption -value $win32os.Caption
        $obj | Add-Member Noteproperty CSDVersion -value $win32os.CSDVersion
        $obj | Add-Member Noteproperty OSArch -value $win32os.OSArchitecture
        $obj | Add-Member Noteproperty BuildNumber -value $win32os.BuildNumber
        $obj | Add-Member Noteproperty RegisteredTo -value $win32os.RegisteredUser
        $obj | Add-Member Noteproperty ProductID -value $win32os.SerialNumber
        $obj | Add-Member Noteproperty ProductKey -value $productkey
        $obj
    }
}

function  Get-WindowsBuildNumber
{
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    return [int]($os.BuildNumber)
}

function Get-WinFeatures
{
    Get-WindowsOptionalFeature -Online |format-table
}


function Get-WinFeatureInfo
{
    param
    (
        [String] $FeatureName
    )
    dism /online /Get-FeatureInfo /FeatureName:$FeatureName
}

function Get-ConsoleCP
{
    return ($(chcp) -replace '[^0-9]','')
}

function Get-DuplicatedModules
{
    Get-InstalledModule | ForEach-Object {
        $latestVersion = $PSItem.Version

        Write-Host "$($PSItem.Name) - $($PSItem.Version)" -ForegroundColor Green

        Get-InstalledModule $PSItem.Name -AllVersions |
        Where-Object Version -NE $latestVersion       | ForEach-Object {
            Write-Host "- $($PSItem.Name) - $($PSItem.Version)" -ForegroundColor Magenta
        }
    }
}

function Uninstall-DuplicatedModules
{
    Get-InstalledModule | ForEach-Object {
        $latestVersion = $PSItem.Version

        Write-Host "$($PSItem.Name) - $($PSItem.Version)" -ForegroundColor Green

        Get-InstalledModule $PSItem.Name -AllVersions |
        Where-Object Version -NE $latestVersion       | ForEach-Object {
            Write-Host "- Uninstalling version $($PSItem.Version)..." -ForegroundColor Magenta -NoNewline
            $PSItem | Uninstall-Module -Force
            Write-Host "done"
        }
    }
}

function Get-SystemInfo
{
    Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *
}

Function EnableDifferentInputMethodForEachApp
{
    $prefMask = (Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
    if (($prefMask[4] -band 0x80) -eq 0)
    {
        $prefMask[4] = ($prefMask[4] -bor 0x80)
        New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value $prefMask -PropertyType ([Microsoft.Win32.RegistryValueKind]::Binary) -Force | Out-Null
    }
}

${function:killall} = { Get-Process @args | Stop-Process }

function psef()
{
    Get-Process @args -IncludeUserName | Format-Table `
    ProcessName,
    Id,
    UserName,
    @{Label = "CPU(s)"; Expression = {if ($_.CPU) {$_.CPU.ToString("N")}}},
    @{Label = "VM(M)";  Expression = {[int]($_.VM  / 1MB)}},
    @{Label = "WS(K)";  Expression = {[int]($_.WS  / 1024)}},
    @{Label = "PM(K)";  Expression = {[int]($_.PM  / 1024)}},
    @{Label = "NPM(K)"; Expression = {[int]($_.NPM / 1024)}},
    Path -AutoSize
}
