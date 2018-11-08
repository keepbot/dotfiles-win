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
    Write-Host "ERROR: gpg.exe not found..." -ForegroundColor Red
    Write-Host "ERROR: GPG4Win should be installed and gpg.exe added to the %PATH% env" -ForegroundColor Red
  }
}
