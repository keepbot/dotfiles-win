<#
.SYNOPSIS
Crypto scripts.

.DESCRIPTION
Crypto scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


if (Get-Command openssl.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:genpass}   = { openssl.exe rand -base64 @args }
}

if (Get-Command shasum.bat -ErrorAction SilentlyContinue | Test-Path) {
    ${function:sha}  = { shasum.bat -a 256 @args }
}

function DecryptFrom-Base64() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs')]

    [CmdletBinding()]
    param
    (
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
${function:ggg}  = { gpg.exe --dry-run -vvvv --import @args }

function gpg_file_e() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $File,
        [string] $Recipients = "d.k.ivanov@live.com"
    )
    If (Get-Command gpg.exe -ErrorAction SilentlyContinue | Test-Path) {
        gpg -e --yes --trust-model always -r $Recipients $File
    } else {
        Write-Host "ERROR: gpg.exe not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg.exe added to the %PATH% env" -ForegroundColor Red
    }
}

function gpg_file_d() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $File
    )
    If (Get-Command gpg.exe -ErrorAction SilentlyContinue | Test-Path) {
        $FileName = [io.path]::GetFileNameWithoutExtension("$File")
        gpg --output $FileName --decrypt $File
    } else {
        Write-Host "ERROR: gpg.exe not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg.exe added to the %PATH% env" -ForegroundColor Red
    }
}
