# Greps with status
if (Get-Command busybox.exe -ErrorAction SilentlyContinue | Test-Path) {
  ${function:grep} = { busybox.exe grep @args }
  ${function:gerp} = { grep @args }
  ${function:gHS} = { grep -e "status" -e "health" @args }
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
New-Alias which1 Get-Command
${function:which2} = { Get-Command @args -All | Format-Table CommandType, Name, Definition }
