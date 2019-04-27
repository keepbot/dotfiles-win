Remove-Item alias:cd -ErrorAction SilentlyContinue
${function:cd} = {
    if ($args -eq '-') {
        $tmpLocation = $env:OLDPWD
        $env:OLDPWD = Get-Location
        Set-Location $tmpLocation
    } else {
        $env:OLDPWD = Get-Location
        Set-Location @args
    }
    $env:PWD = Get-Location
}

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...}     = { Set-Location ..\..                      }
${function:....}    = { Set-Location ..\..\..                   }
${function:.....}   = { Set-Location ..\..\..\..                }
${function:......}  = { Set-Location ..\..\..\..\..             }
${function:.......} = { Set-Location ..\..\..\..\..\..          }

# Navigation Shortcuts
${function:drop}    = { Set-Location D:\Dropbox                 }
${function:desk}    = { Set-Location ~\Desktop                  }
${function:docs}    = { Set-Location ~\Documents                }
${function:down}    = { Set-Location ~\Downloads                }
${function:ws}      = { Set-Location ~\workspace                }
${function:wsmy}    = { Set-Location ~\workspace\my             }
${function:wsdf}    = { Set-Location ~\workspace\my\dotfiles    }
${function:wso}     = { Set-Location ~\workspace\ormco          }
${function:wsod}    = { Set-Location ~\workspace\ormco\devops   }
${function:wst}     = { Set-Location ~\workspace\tmp            }

# Create a new directory and enter it
function New-DirectoryAndSet ([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path}
Set-Alias mkd New-DirectoryAndSet

# Determine size of a file or total size of a directory
function Get-DiskUsage([string] $path=(Get-Location).Path) {
    Convert-ToDiskSize `
        ( `
            Get-ChildItem .\ -recurse -ErrorAction SilentlyContinue `
            | Measure-Object -property length -sum -ErrorAction SilentlyContinue
        ).Sum `
        1
}

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

# Determine size of a file or total size of a directory
Set-Alias fs Get-DiskUsage

# Directory Listing: Use `ls.exe` if available
if (Get-Command busybox.exe -ErrorAction SilentlyContinue | Test-Path) {
    Remove-Item alias:ls -ErrorAction SilentlyContinue
    # Set `ls` to call `ls.exe` and always use --color
    # ${function:ls} = { busybox.exe ls --color --group-directories-first @args }
    ${function:ls} = { busybox.exe ls --group-directories-first @args }
    # List all files in long format
    ${function:l} = { ls -CFh @args }
    # List all files in long format, including hidden files
    ${function:la} = { ls -alh @args }
    ${function:ll} = { ls -alFh @args }
    ${function:dirs} = { ls -l | busybox.exe grep ^d }
    # List only directories
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
    # List directories recursively
    ${function:llr} = { lsd | ForEach-Object{ll $_ @args} }
} else {
    # List all files, including hidden files
    ${function:la} = { Get-ChildItem-Force @args }
    # List only directories
    ${function:lsd} = { Get-ChildItem -Directory -Force @args }
    # List directories recursively
    ${function:llr} = { lsd | ForEach-Object{la $_ @args} }
}

function Remove-File-Recursively {
    Param (
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
#   ${function:rmrf} = { rm.exe -rf @args }
#} else {
    ${function:rmrf} = { Remove-Item -Recurse -Force @args }
#}

function touch($file) { "" | Out-File $file -Encoding ASCII }

# Mounts
${function:mountW} = { subst.exe W: ( Join-Path $HOME "workspace" ) }

# Find files
function find {
    Param (
        [Parameter(Mandatory = $True)]
        [string]$Path,
        [Parameter(Mandatory = $True)]
        [string]$Expression
    )
    Get-ChildItem -Path $Path -Filter $Expression -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object { Write-Host $_.FullName -ForegroundColor Yellow}
}
