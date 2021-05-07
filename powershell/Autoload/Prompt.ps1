<#
.SYNOPSIS
Prompt scripts.

.DESCRIPTION
Prompt scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Module PSReadline -ErrorAction "SilentlyContinue")
{
    Set-PSReadlineOption -ExtraPromptLineCount 1
}

function CheckGit($Path)
{
    if (Test-Path -Path (Join-Path $Path '.git'))
    {
        Write-VcsStatus
        return
    }
    $SplitPath = Split-Path $Path
    if ($SplitPath)
    {
        CheckGit($SplitPath)
    }
}

# ==========================================================================================
# Prompt Hooks
# ==========================================================================================
[ScriptBlock]$ExecutionTime = {
    $history = Get-History -ErrorAction Ignore -Count 1
    if ($history)
    {
        Microsoft.PowerShell.Utility\Write-Host "[" -NoNewline -ForegroundColor DarkGreen
        $ts = New-TimeSpan $history.StartExecutionTime $history.EndExecutionTime
        switch ($ts)
        {
            {$_.TotalMilliseconds -lt 1}
            {
                [int]$us = $(($_.Ticks / 10) % 1000)
                '{0:d3}µs' -f ($us) | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor DarkGray -NoNewline
                break
            }
            {$_.TotalMilliseconds -lt 100}
            {
                [int]$ms = $_.TotalMilliseconds
                [int]$us = $(($_.Ticks / 10) % 1000)
                '{0}.{1:d3}ms' -f ($ms, $us) | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor Cyan -NoNewline
                break
            }
            {$_.TotalSeconds -lt 1}
            {
                [int]$ms = $_.TotalMilliseconds
                '{0}ms' -f ($ms) | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor Cyan -NoNewline
                break
            }
            {$_.TotalSeconds -lt 5}
            {
                [int]$s = [Math]::Floor([decimal]($_.TotalSeconds))
                [int]$ms = $($_.TotalMilliseconds % 1000)
                '{0}.{1:d3}s' -f ($s, $ms) | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor Cyan -NoNewline
                break
            }
            {$_.TotalMinutes -lt 1}
            {
                [int]$s = [Math]::Floor([decimal]($_.TotalSeconds))
                [int]$ms = $($_.TotalMilliseconds % 1000)
                '{0}.{1:d3}s' -f ($s, $ms) | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor Yellow -NoNewline
                break
            }
            {$_.TotalMinutes -ge 1}
            {
                "{0:HH:mm:ss}" -f ([datetime]$ts.Ticks) | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor Red -NoNewline
                break
            }
        }
        Microsoft.PowerShell.Utility\Write-Host "] " -NoNewline -ForegroundColor DarkGreen
    }
}

[ScriptBlock]$GitPrompt = {}

# ==========================================================================================
# This scriptblock runs every time the prompt is returned.
# Explicitly use functions from MS namespace to protect from being overridden in the user session.
# Custom prompt functions are loaded in as constants to get the same behaviour
# ==========================================================================================
[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    Microsoft.PowerShell.Utility\Write-Host "[" -NoNewline -ForegroundColor DarkGreen
    Microsoft.PowerShell.Utility\Write-Host "$realLASTEXITCODE" -NoNewLine -ForegroundColor Yellow
    Microsoft.PowerShell.Utility\Write-Host "] " -NoNewline -ForegroundColor DarkGreen

    ExecutionTime | Microsoft.PowerShell.Utility\Write-Host -NoNewline

    $host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
    $Host.UI.RawUI.ForegroundColor = "White"

    Microsoft.PowerShell.Utility\Write-Host "[" -NoNewline -ForegroundColor DarkGreen
    Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Cyan
    Microsoft.PowerShell.Utility\Write-Host "]" -NoNewline -ForegroundColor DarkGreen

    checkGit($pwd.ProviderPath)

    $now      = Get-date -Format "HH:mm:ss"
    # $username = $(Split-Path (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName).UserName -Leaf)
    $username = Split-Path $Env:USERPROFILE -Leaf
    $compname = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object DNSHostName).DNSHostName
    Microsoft.PowerShell.Utility\Write-Host "`n${now} ${username}@${compname} λ " -NoNewLine -ForegroundColor DarkGray

    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

Set-Item -Path function:\GitPrompt      -Value $GitPrompt
Set-Item -Path function:\ExecutionTime  -Value $ExecutionTime
Set-Item -Path function:\Prompt         -Value $Prompt
