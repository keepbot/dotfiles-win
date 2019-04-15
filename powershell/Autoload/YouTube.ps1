if (Get-Command youtube-dl.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:yget} = {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            [String] $link,
            [String] $dst = "./youtube.mp4"
        )
        youtube-dl.exe ${link} -o ${dst} -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' @args
    }
  }
