# Greps with status
if (Get-Command busybox.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:grep} = {
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory=$true)]
            [string]$Pattern,
            [switch]$c,
            [switch]$E,
            [switch]$F,
            [switch]$hh,
            [switch]$H,
            [switch]$i,
            [switch]$ll,
            [switch]$L,
            [switch]$n,
            [switch]$o,
            [switch]$q,
            [switch]$r,
            [switch]$s,
            [switch]$v,
            [switch]$w,
            [switch]$x,
            [Parameter(ValueFromPipeline=$true)]
            $Data = $null,
            [string]$Other = $null
        )
        Begin {
            [string] $SessionID = [System.Guid]::NewGuid()
            [string] $TempFile  = (Join-Path $env:Temp $SessionID'.grep')
        }
        Process {
            if (-Not $Data) { Write-Host "ERROR: File not defined"; return }
            $File = ""
            if (Test-Path $Data) {
                $File = $Data
            } else {
                Add-Content "$TempFile" $Data
                $File = $TempFile
            }
            $Arguments = "-e $Pattern"
            if ($c)         {$Arguments += " -c"}
            if ($E)         {$Arguments += " -E"}
            if ($F)         {$Arguments += " -F"}
            if ($hh)        {$Arguments += " -h"}
            if ($H)         {$Arguments += " -H"}
            if ($i)         {$Arguments += " -i"}
            if ($ll)        {$Arguments += " -l"}
            if ($L)         {$Arguments += " -L"}
            if ($n)         {$Arguments += " -n"}
            if ($o)         {$Arguments += " -o"}
            if ($q)         {$Arguments += " -q"}
            if ($r)         {$Arguments += " -r"}
            if ($s)         {$Arguments += " -s"}
            if ($v)         {$Arguments += " -v"}
            if ($w)         {$Arguments += " -w"}
            if ($x)         {$Arguments += " -x"}
            if ($Other)     {$Arguments += " $Other"}

            Invoke-Expression "busybox.exe grep $Arguments $File"
        }

        End {
            Remove-Item -Force -ErrorAction SilentlyContinue "$TempFile"

        }
    }
    Set-Alias -Name gerp -Value grep
    Set-Alias -Name greo -Value grep
    ${function:gHS}  = { grep -e "status" -e "health" @args }
} else {
    Set-Alias -Name grep -Value Select-String
    Set-Alias -Name gerp -Value grep
    Set-Alias -Name greo -Value grep
}

# Tail
${function:tail} = {
    if ($args.Count -ne 2) {
        Write-Host "Usage: tail <-N or -f> <path_to_file>"
    } else {
        switch ($args[0]) {
            "-f" {Get-Content $args[1] -Wait}
            default {Get-Content $args[1] -Tail $($args[0] -replace '\D+(\d+)','$1')}
        }
    }
}

# Which and where
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
New-Alias which1 Get-Command -Force
${function:which2} = { Get-Command @args -All | Format-Table CommandType, Name, Definition }
