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


if (Get-Command openssl.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:genpass}             = { openssl.exe rand -base64 @args  }
    ${function:ssl_check_client}    = { openssl s_client -connect @args }
}

if (Get-Command shasum.bat -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:sha}  = { shasum.bat -a 256 @args }
}

function DecryptFrom-Base64()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $string
    )
    if (Get-Command gpg.exe -ErrorAction SilentlyContinue | Test-Path)
    {
        $bytes  = [System.Convert]::FromBase64String($string);
        $filename = [System.IO.Path]::GetTempFileName()
        # Write-Output $filename
        [IO.File]::WriteAllBytes($filename, $bytes)
        gpg.exe -d $filename
        Remove-Item $filename
    }
    else
    {
        Write-Host "ERROR: gpg.exe not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg.exe added to the %PATH% env" -ForegroundColor Red
    }
}
${function:ggg}                 = { gpg --dry-run -vvvv --import @args }

${function:gpg_show_keys}       = { gpg --list-secret-keys --keyid-format LONG @args }
${function:gpg_show_key_info}   = { gpg --import-options show-only --import --fingerprint @args }

${function:gpg_search_sks}      = { gpg --keyserver pool.sks-keyservers.net --search-key  @args }
${function:gpg_search_ubuntu}   = { gpg --keyserver keyserver.ubuntu.com --search-key  @args }
${function:gpg_search_mit}      = { gpg --keyserver pgp.mit.edu --search-key  @args }

${function:mount_meta}  = { encfs ${env:USERPROFILE}\OneDrive\.meta M: }
${function:umount_meta} = { dokanctl /u M: }

function gpg_file_e()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $File,
        [string] $Recipients = "d.k.ivanov@live.com"
    )

    if (Get-Command gpg.exe -ErrorAction SilentlyContinue | Test-Path)
    {
        gpg -e --yes --trust-model always -r $Recipients $File
    }
    else
    {
        Write-Host "ERROR: gpg.exe not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg.exe added to the %PATH% env" -ForegroundColor Red
    }
}

function gpg_file_d()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $File
    )

    if (Get-Command gpg.exe -ErrorAction SilentlyContinue | Test-Path)
    {
        $FileName = [io.path]::GetFileNameWithoutExtension("$File")
        gpg --output $FileName --decrypt $File
    }
    else
    {
        Write-Host "ERROR: gpg.exe not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg.exe added to the %PATH% env" -ForegroundColor Red
    }
}
