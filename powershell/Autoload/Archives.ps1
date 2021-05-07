<#
.SYNOPSIS
Archiving scripts.

.DESCRIPTION
Archiving scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Extract a .zip file
function Unzip
{
    <#
    .SYNOPSIS
        Extracts the contents of a zip file.
    .DESCRIPTION
        Extracts the contents of a zip file specified via the -File parameter to the
        location specified via the -Destination parameter.
    .PARAMETER File
        The zip file to extract. This can be an absolute or relative path.
    .PARAMETER Destination
        The destination folder to extract the contents of the zip file to.
    .PARAMETER ForceCOM
        Switch parameter to force the use of COM for the extraction even if the .NET Framework 4.5 is present.
    .EXAMPLE
        Unzip-File -File archive.zip -Destination .\d
    .EXAMPLE
        'archive.zip' | Unzip-File
    .EXAMPLE
        Get-ChildItem -Path C:\zipfiles | ForEach-Object {$_.fullname | Unzip-File -Destination C:\databases}
    .INPUTS
        String
    .OUTPUTS
        None
    .NOTES
        Inspired by:  Mike F Robbins, @mikefrobbins
        This function first checks to see if the .NET Framework 4.5 is installed and uses it for the unzipping process, otherwise COM is used.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$File,
        [ValidateNotNullOrEmpty()]
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    if (
            ($PSVersionTable.PSVersion.Major -ge 3) -and
            (
                (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full"   -ErrorAction SilentlyContinue).Version -like "4.*" -or
                (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.*"
            )
        )
    {
        try
        {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        }
        catch
        {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
    else
    {
        try
        {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        }
        catch
        {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}

## Save PuTTY sessons and configs
if (Get-Command putty.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ## Export to Desktop
    ${function:Export-Putty-Config}     = { reg export HKCU\Software\SimonTatham ([Environment]::GetFolderPath("Desktop") + "\putty.reg") }
    ${function:Export-Putty-Sessions}   = { reg export HKCU\Software\SimonTatham\PuTTY\Sessions ([Environment]::GetFolderPath("Desktop") + "\putty-sessions.reg") }
}
