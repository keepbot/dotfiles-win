#requires -version 3
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser

$profileDir         = Split-Path -Parent $profile
$dotfilesProfileDir = Join-Path $PSScriptRoot "powershell"
$dotfilesModulesDir = Join-Path $dotfilesProfileDir "Modules"
$dotfilesScriptsDir = Join-Path $dotfilesProfileDir "Scripts"


"DEVELOPMENT" | Out-File ( Join-Path $PSScriptRoot "bash/var.env"    )
"COMPLEX"     | Out-File ( Join-Path $PSScriptRoot "bash/var.prompt" )

# Making Symlinks
If (Test-Path $profileDir                      )  {[System.IO.Directory]::Delete(                $profileDir              , $true)}
If (Test-Path (Join-Path $HOME ".bash"        ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".bash" ), $true)}
If (Test-Path (Join-Path $HOME ".bin"         ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".bin"  ), $true)}
If (Test-Path (Join-Path $HOME ".git.d"       ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".git.d"  ), $true)}
If (Test-Path (Join-Path $HOME ".tmux"        ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".tmux" ), $true)}
If (Test-Path (Join-Path $HOME ".vim"         ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".vim"  ), $true)}

If (Test-Path (Join-Path $HOME ".bash_profile"))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bash_profile" )}
If (Test-Path (Join-Path $HOME ".bashrc"      ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bashrc"       )}
If (Test-Path (Join-Path $HOME ".gemrc"       ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gemrc"        )}
If (Test-Path (Join-Path $HOME ".gitconfig"   ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gitconfig"    )}
If (Test-Path (Join-Path $HOME ".gitmessage"  ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gitmessage"   )}
If (Test-Path (Join-Path $HOME ".profile"     ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".profile"      )}
If (Test-Path (Join-Path $HOME ".tmux.conf"   ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".tmux.conf"    )}
If (Test-Path (Join-Path $HOME ".vimrc"       ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".vimrc"        )}

If (Test-Path "C:\sr\config.yaml"              )  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path "C:\sr" "config.yaml"           )}

C:\Windows\System32\cmd.exe /c mklink /d $profileDir $dotfilesProfileDir
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".bash"         ) ( Join-Path $PSScriptRoot "bash"              )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".bin"          ) ( Join-Path $PSScriptRoot "bin-win"           )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".git.d"          ) ( Join-Path $PSScriptRoot "git.d"           )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".tmux"         ) ( Join-Path $PSScriptRoot "tmux"              )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".vim"          ) ( Join-Path $PSScriptRoot "vim"               )

C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".bash_profile" ) ( Join-Path $PSScriptRoot "bash_profile"      )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".profile"      ) ( Join-Path $PSScriptRoot "bash_profile"      )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".bashrc"       ) ( Join-Path $PSScriptRoot "bashrc"            )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".gemrc"        ) ( Join-Path $PSScriptRoot "gemrc"             )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".gitconfig"    ) ( Join-Path $PSScriptRoot ".gitconfig-win"    )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".gitmessage"   ) ( Join-Path $PSScriptRoot ".gitmessage"       )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".tmux.conf"    ) ( Join-Path $PSScriptRoot "tmux.conf"         )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".vimrc"        ) ( Join-Path $PSScriptRoot "vimrc"             )

C:\Windows\System32\cmd.exe /c mklink      "C:\sr\config.yaml"               ( Join-Path $PSScriptRoot "stack\config.yaml" )

Write-Host ""
Write-Host "Initialization of PowerShell profile and installing applications. Be patient. It's hurt only first time..."
Write-Host ""

$NormalizationPath = Join-Path $dotfilesProfileDir "normalization-done"
if(![System.IO.File]::Exists($NormalizationPath)) {
  . (Join-Path $dotfilesScriptsDir "Normalilze-Manually-Installed-Modules.ps1") -force
  Normalilze-Manually-Installed-Modules
  New-Item (Join-Path $dotfilesProfileDir "normalization-done") -ItemType file
}

# Load Modules
If (Test-Path (Join-Path $dotfilesProfileDir "modules.ps1"))  { . (Join-Path $dotfilesProfileDir "modules.ps1"            ) }

# Chocolatey
If (-Not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
  Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
If (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe") {
  $candies = @(
  "7zip.install"
  "adobereader"
  # "azure-cli"
  "awscli"
  "bind-toolsonly"
  "calibre"
  "ccleaner"
  "chefdk"
  "cmdermini"
  "cmake.portable"
  # "consul"
  "curl"
  # "cyberduck"
  "doublecmd"
  "du"
  "drmemory"
  "etcher"
  "far"
  "foobar2000"
  "ftpdmin"
  "gimp"
  "git"
  "git-lfs"
  # "gnuwin32-coreutils.install"
  "golang"
  "gpg4win"
  "gradle"
  "graphviz"
  "greenshot"
  "grepwin"
  # Haskell
  "ghc"
  "cabal"
  "haskell-stack"
  "hg"
  "hxd"
  ###
  "imagemagick"
  "irfanview"
  "irfanviewplugins"
  # "itunes"
  "ldapadmin"
  # Decided to install java manually: Java-11 latest
  # "jdk8"
  # "jre8"
  # "jdk10"
  # "jre10"
  "jq"
  "kdiff3"
  "keepass"
  "keystore-explorer.portable"
  "kubernetes-cli"
  "kubernetes-helm"
  "llvm"
  "lockhunter"
  "make"
  "maven"
  "meld"
  "mingw"
  "minikube"
  "miktex"
  "mremoteng"
  #"mysql.workbench"
  "nasm"
  "nmap"
  "nodejs-lts"
  "notepadplusplus"
  "notepadplusplus-npppluginmanager"
  # "nomad"
  "nuget.commandline"
  "nugetpackageexplorer"
  "nssm"
  "octopustools"
  "openssh"
  "openssl.light"
  "paket.powershell"
  "packer"
  "paint.net"
  "pandoc"
  "pdfsam"
  "pgadmin3"
  "pgadmin4"
  # "pgina"
  "putty"
  "python3 --params /InstallDir:C:\tools\python3"
  "python2 --params /InstallDir:C:\tools\python2"
  "qbittorrent"
  # "qtcreator"
  "rdcman"
  "reshack"
  "robo3t"
  "ruby"
  "ruby2.devkit"
  "rufus"
  "slack"
  "strawberryperl"
  # "studio3t"
  # "sumatrapdf"
  "superputty"
  "svn"
  "swissfileknife"
  "sysinternals"
  "telegram.install"
  "terraform"
  "tftpd32"
  "tightvnc"
  "tor-browser"
  "vagrant"
  "vagrant-manager"
  "vcxsrv"
  # "vim" - should be installed manually to cover python 3.6 support
  "vscode"
  "vlc"
  "wget"
  "wincdemu"
  "windjview"
  "windirstat"
  "winmerge"
  "winscp"
  "wireshark"
  "wmiexplorer"
  "x64dbg.portable"
  "xpdf-utils"
  "yarn"
  "yasm"
  # "yed --params /Associate"
  # "zoom"
  )

#   foreach ($mars in $candies) {
#     choco install -y -r $mars
#   }
}

#if (Get-Command chef -ErrorAction SilentlyContinue | Test-Path) {
#  chef gem install knife-block
#}

# ConEmu profile
If (Get-Command cmder.exe -ErrorAction SilentlyContinue | Test-Path) {
  $cmder_home = Get-Command cmder.exe | Select-Object -ExpandProperty Definition | Split-Path
  Remove-Item -Force -Confirm:$false -Recurse (Join-Path $cmder_home "config\user-ConEmu.xml")
  Remove-Item -Force -Confirm:$false -Recurse (Join-Path $cmder_home "vendor\init.bat")
  Remove-Item -Force -Confirm:$false -Recurse (Join-Path $cmder_home "vendor\profile.ps1")
  Remove-Item -Force -Confirm:$false -Recurse (Join-Path $cmder_home "vendor\conemu-maximus5\ConEmu.xml")

  C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "config\user-ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\user-ConEmu.xml")
  C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\init.bat") (Join-Path $PSScriptRoot "data\conemu\init.bat")
  C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\profile.ps1") (Join-Path $PSScriptRoot "data\conemu\profile.ps1")
  C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\conemu-maximus5\ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\ConEmu.xml")

  Set-ApplicationCompatibility -CurrentUser -ApplicationLocation (Get-Command cmder.exe | Select-Object -ExpandProperty Definition) -PrivilegeLevel
}

