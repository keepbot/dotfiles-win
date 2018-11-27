# WGet: Use `wget.exe` if available
if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:wget -ErrorAction SilentlyContinue
}

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item alias:curl -ErrorAction SilentlyContinue
  ${function:curl} = { curl.exe @args }
  # Gzip-enabled `curl`
  ${function:gurl} = { curl.exe --compressed @args }
} else {
  # Gzip-enabled `curl`
  ${function:gurl} = { Invoke-WebRequest -TransferEncoding GZip }
}

# Download a file into a temporary folder
function curlex($url) {
  $uri = new-object system.uri $url
  $filename = $name = $uri.segments | Select-Object -Last 1
  $path = join-path $env:Temp $filename
  if( test-path $path ) { rm -force $path }

  (new-object net.webclient).DownloadFile($url, $path)

  return new-object io.fileinfo $path
}

# Start IIS Express Server with an optional path and port
function Start-IISExpress {
  [CmdletBinding()]
  param (
      [String] $path = (Get-Location).Path,
      [Int32]  $port = 3000
  )

  if ((Test-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe") -or (Test-Path "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe")) {
      $iisExpress = Resolve-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe" -ErrorAction SilentlyContinue
      if ($iisExpress -eq $null) { $iisExpress = Get-Item "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe" }

      & $iisExpress @("/path:${path}") /port:$port
  } else { Write-Warning "Unable to find iisexpress.exe"}
}
