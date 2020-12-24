<#
.SYNOPSIS
Filesystem scripts.

.DESCRIPTION
Filesystem scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


Remove-Item alias:cd -ErrorAction SilentlyContinue
${function:cd} = {
    if ($args -eq '-')
    {
        $tmpLocation = $env:OLDPWD
        $env:OLDPWD = Get-Location
        Set-Location $tmpLocation
    }
    else
    {
        $env:OLDPWD = Get-Location
        Set-Location @args
    }
    $env:PWD = Get-Location
}

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...}     = { Set-Location ..\..                                      }
${function:....}    = { Set-Location ..\..\..                                   }
${function:.....}   = { Set-Location ..\..\..\..                                }
${function:......}  = { Set-Location ..\..\..\..\..                             }
${function:.......} = { Set-Location ..\..\..\..\..\..                          }

# Navigation Shortcuts
${function:drop}    = { Set-Location D:\Dropbox                                 }
${function:desk}    = { Set-Location ~\Desktop                                  }
${function:docs}    = { Set-Location ~\Documents                                }
${function:down}    = { Set-Location ~\Downloads                                }
${function:ws}      = { Set-Location ~\workspace                                }
${function:wsm}     = { Set-Location ~\workspace\misc                           }
${function:wsmy}    = { Set-Location ~\workspace\my                             }
${function:wsdf}    = { Set-Location ~\workspace\my\dotfiles                    }
${function:wsdsc}   = { Set-Location ~\workspace\my\dsc-windows-workstation     }
${function:wst}     = { Set-Location ~\workspace\tmp                            }

# Ormco Shortcuts
${function:wso}     = { Set-Location ~\workspace\ormco                          }
${function:wsoc}    = { Set-Location ~\workspace\ormco\common                   }
${function:wsoo}    = { Set-Location ~\workspace\ormco\common\orthoplatform     }
${function:wsod}    = { Set-Location ~\workspace\ormco\devops                   }
${function:wsor}    = { Set-Location ~\workspace\ormco\web\alignerweb-reports   }

# IRQ Shortcuts
${function:wsi}     = { Set-Location ~\workspace\irq                            }
${function:wsic}    = { Set-Location ~\workspace\irq\common                     }
${function:wsid}    = { Set-Location ~\workspace\irq\devops                     }
${function:wsim}    = { Set-Location ~\workspace\irq\ml                         }
${function:wsimm}   = { Set-Location ~\workspace\irq\ml\irqml                   }

# Create a new directory and enter it
function New-DirectoryAndSet ([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path}
Set-Alias mkd New-DirectoryAndSet

function Get-DuList
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Precision',
        Justification = 'False positive as rule does not know that ForEach-Object operates within the same scope')]
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$Path = $(Get-Location),
        [ValidateNotNullOrEmpty()]
        [string]$Precision = 5
    )
    # $null = $Precision
    Get-ChildItem ${Path} -Force | ForEach-Object {
        "{0} {1:N${Precision}} MB" -f ($_.Name), ((Get-ChildItem $(Join-Path ${Path} ${_}) -Force -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
    }
}
Set-Alias dul Get-DuList

# Determine size of a file or total size of a directory
function Get-DiskUsage([string] $Path=(Get-Location).Path) {
    Convert-ToDiskSize `
        ( `
            Get-ChildItem $Path -Force -Recurse -ErrorAction SilentlyContinue `
            | Measure-Object -Property length -sum -ErrorAction SilentlyContinue
        ).Sum `
        1
}

function Convert-ToDiskSize {
    param
    (
        $bytes,
        $precision='0'
    )

    foreach ($size in ("B","K","M","G","T")) {
        if (($bytes -lt 1000) -or ($size -eq "T")){
            $bytes = ($bytes).tostring("F0" + "$precision")
            return "${bytes}${size}"
        }
        else { $bytes /= 1KB }
    }
}
Set-Alias du Get-DiskUsage

# Directory Listing: Use `ls.exe` if available
if (Get-Command busybox.exe -ErrorAction SilentlyContinue | Test-Path)
{
    Remove-Item alias:ls -ErrorAction SilentlyContinue
    # Set `ls` to call `ls.exe` and always use --color
    # ${function:ls} = { busybox.exe ls --color --group-directories-first @args }
    ${function:ls}      = { busybox.exe ls --group-directories-first @args }
    # List all files in long format
    ${function:l}       = { ls -CFh @args }
    # List all files in long format, including hidden files
    ${function:la}      = { ls -alh @args }
    ${function:ll}      = { ls -alFh @args }
    ${function:fls}     = { ls -l  @args | busybox.exe grep -v ^d }
    ${function:flsa}    = { ls -la @args | busybox.exe grep -v ^d }
    ${function:dirs}    = { ls -l  @args | busybox.exe grep ^d }
    ${function:dirsa}   = { ls -la @args | busybox.exe grep ^d }
    # List only directories
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
    # List directories recursively
    ${function:llr} = { lsd | ForEach-Object{ll $_ @args} }
} else {
    # List all files, including hidden files
    ${function:la} = { Get-ChildItem -Force @args }
    # List only directories
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
    # List directories recursively
    ${function:llr} = { lsd | ForEach-Object{la $_ @args} }
}

function  llf() {
    if ($Args[0]) {
        $path = $Args[0]
    } else {
        $path = "."
    }

    if ($Args[1]) {
        $pattern = ".*$($Args[1]).*"
    } else {
        $pattern = ''
    }
    Get-ChildItem "$path" | ForEach-Object{
        if ($_.Name -match "$pattern") {
            $_.FullName
        }
    }
}

function Remove-File-Recursively
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FileName',
        Justification = 'False positive as rule does not know that ForEach-Object operates within the same scope')]
    param
    (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$PathToFolderTree,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$FileName
    )
    Get-ChildItem $PathToFolderTree | ForEach-Object {
        $targetFile = $(Join-Path $_.FullName $FileName)
        if(Test-Path $targetFile){
            Remove-Item -Force $targetFile
            Write-Host $targetFile " removed"
        }
    }
}

#if (Get-Command rm.exe -ErrorAction SilentlyContinue | Test-Path) {
#   ${function:rmf}  = { rm.exe -f  @args }
#   ${function:rmrf} = { rm.exe -rf @args }
#} else {
    ${function:rmf}  = { Remove-Item -Force @args }
    ${function:rmrf} = { Remove-Item -Recurse -Force @args }
#}

function touch($file) { $null | Out-File -Append $file -Encoding ASCII }

# Mounts
${function:mountW} = { subst.exe W: ( Join-Path $Env:USERPROFILE "workspace" ) }

# Find files
function find
{
    param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,
        [Parameter(Mandatory = $True)]
        [string]$Expression
    )
    Get-ChildItem -Path $Path -Filter $Expression -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object { Write-Host $_.FullName -ForegroundColor Yellow}
}

# Copy files with directory structure.
# Input: Array of Strings
# Output: Folder with copied files
function Copy-FilesWithFolderStructure
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [String]$Destination,
        [Parameter(Mandatory = $True,ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]$Items
    )

    if(-Not (Test-Path $Destination))
    {
        New-Item -ItemType Directory -Path "$Destination" -Force
    }

    foreach ($item in $Items)
    {
        if(Test-Path $item)
        {
            $Dir = Split-Path -Path $item
            New-Item -Path "$(Join-Path $Destination $Dir)" -ItemType Directory -Force
            Copy-Item "$item" -Destination "$(Join-Path $Destination $Dir)" -Force
        }
    }
}

function join_files
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Out,

        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({
            foreach ($file in $_) {
                Test-Path $file.FullName
            }
        })]
        [System.Object[]] $FilesToJoin = (Get-ChildItem -Path . -File)
    )
    $cmd = "cmd /c '$($FilesToJoin.FullName -join ' + ') ${Out}'"
    Write-Host $cmd

    # Usages:
    # join_files out.mp3
    # join_files out.mp3 (Get-ChildItem -Path ..\path\to\folder\ -File)
    # Get-ChildItem -Path ..\path\to\folder\ -File | join_files out.mp3
    # Get-ChildItem -Path ..\path\to\folder\ -File -Filter "*.mp3"  | join_files out.mp3
    #
    # CMD equivalent
    # copy /b 01.mp3 + 02.mp3 + 03.mp3 + 04.mp3 + 05.mp3 + 06.mp3 + 07.mp3 + 08.mp3 + 09.mp3 + 10.mp3 + 11.mp3 out.mp3
}
