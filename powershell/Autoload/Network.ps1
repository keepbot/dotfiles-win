<#
.SYNOPSIS
Network scripts.

.DESCRIPTION
Network scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


if (Get-Command dig.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:myip} = { dig.exe +short myip.opendns.com `@resolver1.opendns.com }
    ${function:digga} = { dig.exe +nocmd "$($args[0].ToString())" any +multiline +noall +answer }
}
${function:ipif} = {if ($($args[0])) {curl ipinfo.io/"$($args[0].ToString())"} else {curl ipinfo.io}}

${function:localip} = { Get-NetIPAddress | Format-Table }

${function:urlencode} = { python.exe -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));" @args }
