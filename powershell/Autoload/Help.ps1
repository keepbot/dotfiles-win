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
