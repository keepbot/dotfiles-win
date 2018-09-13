# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Common Editing needs
function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Sudo
function sudo() {
    if ($args.Length -eq 1) {
        start-process $args[0] -verb "runAs"
    }
    if ($args.Length -gt 1) {
        start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}

# System Update - Update RubyGems, NPM, and their installed packages
function System-Update() {
    # Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
    Update-Module
    Update-Help -Force
    # scoop update
    gem update --system
    gem update
    npm install npm -g
    npm update -g
    cup all -y
}

# Reload the Shell
function Reload-Powershell {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = "-nologo"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
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

# Empty the Recycle Bin on all drives
function Empty-RecycleBin {
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}

### File System functions
### ----------------------------
# Create a new directory and enter it
function CreateAndSet-Directory([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path}

# Determine size of a file or total size of a directory
function Get-DiskUsage([string] $path=(Get-Location).Path) {
    Convert-ToDiskSize `
        ( `
            Get-ChildItem .\ -recurse -ErrorAction SilentlyContinue `
            | Measure-Object -property length -sum -ErrorAction SilentlyContinue
        ).Sum `
        1
}

# Cleanup all disks (Based on Registry Settings in `windows.ps1`)
function Clean-Disks {
    Start-Process "$(Join-Path $env:WinDir 'system32\cleanmgr.exe')" -ArgumentList "/sagerun:6174" -Verb "runAs"
}

function Remove-File-Recursively {
    Param (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$FileName,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$PathToFolderTree
    )
    Get-ChildItem $PathToFolderTree | ForEach-Object {
        $targetFile = $(Join-Path $_.FullName $FileName)
        if(Test-Path $targetFile){
            Remove-Item -Force $targetFile
            Write-Host $targetFile " removed"
        }
    }
}

### Environment functions
### ----------------------------

# Reload the $env object from the registry
function Refresh-Environment {
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                 'HKCU:\Environment'

    $locations | ForEach-Object {
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name  = $_
            $value = $k.GetValue($_)
            Set-Item -Path Env:\$name -Value $value
        }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Add a folder to $env:Path
function Prepend-EnvPath([String]$path) { $env:PATH = "$path;" + $env:PATH }
function Prepend-EnvPathIfExists([String]$path) { if (Test-Path $path) { Prepend-EnvPath $path } }
function Append-EnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
function Append-EnvPathIfExists([String]$path) { if (Test-Path $path) { Append-EnvPath $path } }


### Utilities
### ----------------------------

# Convert a number to a disk size (12.4K or 5M)
function Convert-ToDiskSize {
    param ( $bytes, $precision='0' )
    foreach ($size in ("B","K","M","G","T")) {
        if (($bytes -lt 1000) -or ($size -eq "T")){
            $bytes = ($bytes).tostring("F0" + "$precision")
            return "${bytes}${size}"
        }
        else { $bytes /= 1KB }
    }
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

# Extract a .zip file
function Unzip-File {
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
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$File,

        [ValidateNotNullOrEmpty()]
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    if (($PSVersionTable.PSVersion.Major -ge 3) -and
       ((Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -like "4.*" -or
       (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.*")) {

        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    } else {
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}

function rm-wapp {
  if ($args.Count -ne 1) {
    Write-Host "Usage: rm-wapp <package_mask>"
  }
  else {
    Get-AppxPackage *$($args[0].ToString())* | Remove-AppxPackage
  }
}

function get-wapp {
  if ($args.Count -ne 1) {
    Write-Host "Usage: get-wapp <package_mask>"
  }
  else {
    Get-AppxPackage *$($args[0].ToString())*
  }
}

function re-wapp {
  Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}

function Bamboo-Get-AMI {
  if ($args.Count -ne 2) {
    Write-Host "Usage: Bamboo-Get-AMI <Bamboo_version> <filter(windows, linux, PV, HVM)>"
  }
  else {
    ${BAMBOO_VERSION}=$args[0]
    Write-Host "For Bamboo version: ${BAMBOO_VERSION}"
    [xml]${pom_file} = (New-Object System.Net.WebClient).DownloadString("https://maven.atlassian.com/content/groups/public/com/atlassian/bamboo/atlassian-bamboo/${BAMBOO_VERSION}/atlassian-bamboo-${BAMBOO_VERSION}.pom")
    ${ELASTIC_VERSION}=${pom_file}.project.properties.'elastic-image.version'

    Write-Host "Elastic bamboo version is $ELASTIC_VERSION"
    ${amis} = Invoke-RestMethod https://maven.atlassian.com/content/groups/public/com/atlassian/bamboo/atlassian-bamboo-elastic-image/${ELASTIC_VERSION}/atlassian-bamboo-elastic-image-${ELASTIC_VERSION}.ami
    ${amis}.tostring() -split "[`r`n]" | Select-String "image." | Select-String $args[1] | Sort-Object
    Write-Host "REMEMBER: Use the Image from the appropriate region!"
  }
}

function Stop-Beeper {
  # sc config beep start= disabled
  net stop beep
}

# Get help from cheat.sh
function cht {
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$Language,

    [Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)]
    [psobject[]]$SearchString
  )
  $site = "cheat.sh/" + $Language + "/" + ($SearchString -join '+')
  curl $site
}

function Rename-GitHub-Origin {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$NewName
    )
    $dir = Get-Location
    Get-ChildItem $dir -Directory | ForEach-Object {
        Write-Host $_.FullName
        Set-Location $_.FullName
        $oldRemote = git config --get remote.origin.url
        Write-Host "Old remote:"
        git remote -v
        $repo = Split-Path $oldRemote -leaf
        $newRemote = "git@github.com:${NewName}/${repo}"
        git remote rm origin
        git remote add origin ${newRemote}
        Write-Host "New remote:"
        # Write-Host $newRemote
        git remote -v
        Write-Host "------------------------------------------------------------"
    }
    Set-Location $dir
}
