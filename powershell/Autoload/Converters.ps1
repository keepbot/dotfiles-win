<#
.SYNOPSIS
Convert scripts.

.DESCRIPTION
Convert scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


function ConvertTo-Base64() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $string
    )
    $bytes   = [System.Text.Encoding]::UTF8.GetBytes($string);
    $encoded = [System.Convert]::ToBase64String($bytes);
    Write-Output $encoded;
}

function ConvertFrom-Base64() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $string
    )
    $bytes   = [System.Convert]::FromBase64String($string);
    $decoded = [System.Text.Encoding]::UTF8.GetString($bytes);
    Write-Output $decoded;
}

function ResizePDF() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path -Path $_})]
        [string] $Path,
        [string] $OutputPath,
        [string] $Resolution = "72"
    )

    if (-Not $OutputPath) {
        $OutputPath = "$((Get-Item $Path).BaseName)_${Resolution}dpi.pdf"
        Write-Host "`t Setting OutputPath to ${OutputPath}" -ForegroundColor Yellow
    }

    If (Get-Command gswin64.exe -ErrorAction SilentlyContinue | Test-Path) {
        $cmd  = "cmd /c '"
        $cmd  += "gswin64.exe"
        $cmd += " -q -dNOPAUSE -dBATCH -dSAFER"
        $cmd += " -sDEVICE=pdfwrite"
        $cmd += " -dCompatibilityLevel=1.3"
        $cmd += " -dPDFSETTINGS=/screen"
        $cmd += " -dEmbedAllFonts=true"
        $cmd += " -dSubsetFonts=true"
        $cmd += " -dAutoRotatePages=/None"
        $cmd += " -dColorImageDownsampleType=/Bicubic"
        $cmd += " -dColorImageResolution=$Resolution"
        $cmd += " -dGrayImageDownsampleType=/Bicubic"
        $cmd += " -dGrayImageResolution=$Resolution"
        $cmd += " -dMonoImageDownsampleType=/Subsample"
        $cmd += " -dMonoImageResolution=$Resolution"
        $cmd += " -sOutputFile=$OutputPath"
        $cmd += " $Path"
        $cmd += "'"

        Write-Host "`t GhostScript cmd: $cmd`n" -ForegroundColor Yellow
        Invoke-Expression "$cmd"
    } else {
        Write-Host "ERROR: gswin64 not found..." -ForegroundColor Red
        Write-Host "ERROR: GhostScript for Windows should be installed and gswin64.exe added to the %PATH% env" -ForegroundColor Red
    }
}
