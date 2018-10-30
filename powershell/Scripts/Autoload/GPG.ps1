
function DecryptFrom-Base64() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string] $string
  )
  If (Get-Command gpg.exe -ErrorAction SilentlyContinue | Test-Path) {
    $bytes  = [System.Convert]::FromBase64String($string);
    $filename = [System.IO.Path]::GetTempFileName()
    # Write-Output $filename
    [IO.File]::WriteAllBytes($filename, $bytes)
    gpg.exe -d $filename
    Remove-Item $filename
  } else {
    Write-Error "ERROR! You don't have gpg.exe in your path!"
  }
}
