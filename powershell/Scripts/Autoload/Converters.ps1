function ConvertTo-Base64() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string] $string
  )
  $bytes  = [System.Text.Encoding]::UTF8.GetBytes($string);
  $encoded = [System.Convert]::ToBase64String($bytes);

  Write-Output $encoded;
}

function ConvertFrom-Base64() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string] $string
  )
  $bytes  = [System.Convert]::FromBase64String($string);
  $decoded = [System.Text.Encoding]::UTF8.GetString($bytes);

  Write-Output $decoded;
}
