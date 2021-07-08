#requires -version 3
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser

$dotfilesProfileDir = Join-Path $PSScriptRoot       "powershell"
$dotfilesModulesDir = Join-Path $dotfilesProfileDir "Modules"
$dotfilesScriptsDir = Join-Path $dotfilesProfileDir "Scripts"

"DEVELOPMENT" | Out-File ( Join-Path $PSScriptRoot "bash/var.env"    )
"COMPLEX"     | Out-File ( Join-Path $PSScriptRoot "bash/var.prompt" )

# Cleanup profile
If (Test-Path (Join-Path $Env:USERPROFILE ".bash"           )) { [System.IO.Directory]::Delete(( Join-Path $Env:USERPROFILE ".bash"         ),  $true       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".bin"            )) { [System.IO.Directory]::Delete(( Join-Path $Env:USERPROFILE ".bin"          ),  $true       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".conan_my"       )) { [System.IO.Directory]::Delete(( Join-Path $Env:USERPROFILE ".conan_my"     ),  $true       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".git.d"          )) { [System.IO.Directory]::Delete(( Join-Path $Env:USERPROFILE ".git.d"        ),  $true       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".tmux"           )) { [System.IO.Directory]::Delete(( Join-Path $Env:USERPROFILE ".tmux"         ),  $true       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".vim"            )) { [System.IO.Directory]::Delete(( Join-Path $Env:USERPROFILE ".vim"          ),  $true       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".bash_profile"   )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".bash_profile" )}
If (Test-Path (Join-Path $Env:USERPROFILE ".bashrc"         )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".bashrc"       )}
If (Test-Path (Join-Path $Env:USERPROFILE ".gemrc"          )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".gemrc"        )}
If (Test-Path (Join-Path $Env:USERPROFILE ".gitconfig"      )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".gitconfig"    )}
If (Test-Path (Join-Path $Env:USERPROFILE ".gitmessage"     )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".gitmessage"   )}
If (Test-Path (Join-Path $Env:USERPROFILE ".profile"        )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".profile"      )}
If (Test-Path (Join-Path $Env:USERPROFILE ".tmux.conf"      )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".tmux.conf"    )}
If (Test-Path (Join-Path $Env:USERPROFILE ".vimrc"          )) { Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $Env:USERPROFILE   ".vimrc"        )}


# Making Symlinks
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $Env:USERPROFILE ".bash"          ) ( Join-Path $PSScriptRoot "bash"           )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $Env:USERPROFILE ".bin"           ) ( Join-Path $PSScriptRoot "bin-win"        )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $Env:USERPROFILE ".conan_my"      ) ( Join-Path $PSScriptRoot "conan"          )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $Env:USERPROFILE ".git.d"         ) ( Join-Path $PSScriptRoot "git.d"          )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $Env:USERPROFILE ".tmux"          ) ( Join-Path $PSScriptRoot "tmux"           )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $Env:USERPROFILE ".vim"           ) ( Join-Path $PSScriptRoot "vim"            )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".bash_profile"  ) ( Join-Path $PSScriptRoot "bash_profile"   )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".profile"       ) ( Join-Path $PSScriptRoot "bash_profile"   )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".bashrc"        ) ( Join-Path $PSScriptRoot "bashrc"         )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".gemrc"         ) ( Join-Path $PSScriptRoot "gemrc"          )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".gitconfig"     ) ( Join-Path $PSScriptRoot ".gitconfig-win" )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".gitmessage"    ) ( Join-Path $PSScriptRoot ".gitmessage"    )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".tmux.conf"     ) ( Join-Path $PSScriptRoot "tmux.conf"      )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $Env:USERPROFILE ".vimrc"         ) ( Join-Path $PSScriptRoot "vimrc"          )

# Set dot source string to default PS profile for Current User
if (Test-Path $profile) { Remove-Item -Force -Confirm:$false $profile }
". `"$PSScriptRoot\powershell\profile_loader.ps1`"" | Out-File $profile

# Install Nuget package provide if needed
if (-Not (Get-packageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue))
{
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

# Make PSGallery Trusted if needed
if (-Not (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue).InstallationPolicy -eq 'Trusted')
{
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

# $NormalizationPath = Join-Path $dotfilesProfileDir "normalization-done"
# if (![System.IO.File]::Exists($NormalizationPath)) {
#     . (Join-Path $dotfilesScriptsDir "Normalilze-Manually-Installed-Modules.ps1") -force
#     Normalilze-Manually-Installed-Modules
#     New-Item (Join-Path $dotfilesProfileDir "normalization-done") -ItemType file
# }

#if (Get-Command chef -ErrorAction SilentlyContinue | Test-Path) {
#  chef gem install knife-block
#}

Import-Module -FullyQualifiedName (Join-Path $dotfilesModulesDir "ApplicationCompatibility")

# ConEmu
if (Test-Path "C:\Program Files\ConEmu\ConEmu64.exe")
{
    Set-ApplicationCompatibility -CurrentUser -ApplicationLocation "C:\Program Files\ConEmu\ConEmu64.exe" -PrivilegeLevel
}
Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path ${Env:APPDATA} "ConEmu.xml")
cmd /c mklink (Join-Path ${Env:APPDATA} "ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\ConEmu.xml")

# if (Get-Command cmder.exe -ErrorAction SilentlyContinue | Test-Path)
# {
#     $cmder_home = Get-Command cmder.exe | Select-Object -ExpandProperty Definition | Split-Path
#     Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "config\user-ConEmu.xml")
#     Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "config\user-aliases.cmd")
#     Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "vendor\init.bat")
#     Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "vendor\profile.ps1")
#     Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "vendor\conemu-maximus5\ConEmu.xml")
#
#     C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "config\user-ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\user-ConEmu.xml")
#     C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "config\user-aliases.cmd") (Join-Path $PSScriptRoot "data\conemu\useuser-aliasesr_aliases.cmd")
#     C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\init.bat") (Join-Path $PSScriptRoot "data\conemu\init.bat")
#     C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\profile.ps1") (Join-Path $PSScriptRoot "data\conemu\profile.ps1")
#     C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\conemu-maximus5\ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\ConEmu.xml")
#
#     Set-ApplicationCompatibility -CurrentUser -ApplicationLocation (Get-Command cmder.exe | Select-Object -ExpandProperty Definition) -PrivilegeLevel
# }

$workspace_path = 'c:\ws'
New-Item $workspace_path -ItemType Directory -ErrorAction SilentlyContinue
[Environment]::SetEnvironmentVariable("WORKSPACE", $workspace_path, "Machine")
