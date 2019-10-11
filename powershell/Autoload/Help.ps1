# Get help from cheat.sh
function cht {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Language,
        [Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)]
        [psobject[]]$SearchString
    )
    $site = "cheat.sh/" + $Language + "/" + ($SearchString -join '+')
    curl $site
}

# Show command definiton
${function:show}  = { if ($args[0] -and -Not $args[1]) { (Get-Command ${args}).Definition } else {Write-Host "Wrong command!`nUsage: show <command>"}}
