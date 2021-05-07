<#
.SYNOPSIS
Unix-like scripts.

.DESCRIPTION
Unix-like scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Set-Alias time Measure-Command
# ${function:time} = { Measure-Command { @args }}

function time
{
    $command = $args
    $timings = $(Measure-Command { Invoke-Expression "${command}" | Out-Default })
    $obj = New-Object PSObject
    $obj | Add-Member Ticks $timings.Ticks
    $obj | Add-Member Hours $timings.TotalHours
    $obj | Add-Member Minutes $timings.TotalMinutes
    $obj | Add-Member Seconds $timings.TotalSeconds
    $obj | Add-Member Milliseconds $timings.TotalMilliseconds
    # $str = "| " + $obj + " |"
    # Write-Host $('-' * $str.Length)
    # Write-Host $str
    # Write-Host $('-' * $str.Length)
    Write-Host
    # Write-Host $('-' * 17) " Time report " $('-' * 18)
    # Write-Host $('-' * 50)
    Write-Host "Ticks       :" $timings.Ticks
    Write-Host "Hours       :" $timings.TotalHours
    Write-Host "Minutes     :" $timings.TotalMinutes
    Write-Host "Seconds     :" $timings.TotalSeconds
    Write-Host "Miliseconds :" $timings.TotalMilliseconds
    # Write-Host $('-' * 50)
}

# ${function:time} = {
#     $sw = [Diagnostics.Stopwatch]::StartNew()
#     Invoke-Expression "${args}" | Out-Default
#     $sw.Stop()
#     $sw.Elapsed
# }

${function:bash-wsl}    = { conemu-cyg-64.exe --wsl -cur_console:h0 }

Set-Alias wc Measure-Object
