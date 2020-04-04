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
If (Test-Path (Join-Path $HOME ".bash"        ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME    ".bash" ), $true)}
If (Test-Path (Join-Path $HOME ".bin"         ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME    ".bin"  ), $true)}
If (Test-Path (Join-Path $HOME ".git.d"       ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME    ".git.d"), $true)}
If (Test-Path (Join-Path $HOME ".tmux"        ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME    ".tmux" ), $true)}
If (Test-Path (Join-Path $HOME ".vim"         ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME    ".vim"  ), $true)}
If (Test-Path (Join-Path $HOME ".bash_profile"))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".bash_profile" )}
If (Test-Path (Join-Path $HOME ".bashrc"      ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".bashrc"       )}
If (Test-Path (Join-Path $HOME ".gemrc"       ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".gemrc"        )}
If (Test-Path (Join-Path $HOME ".gitconfig"   ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".gitconfig"    )}
If (Test-Path (Join-Path $HOME ".gitmessage"  ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".gitmessage"   )}
If (Test-Path (Join-Path $HOME ".profile"     ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".profile"      )}
If (Test-Path (Join-Path $HOME ".tmux.conf"   ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".tmux.conf"    )}
If (Test-Path (Join-Path $HOME ".vimrc"       ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME    ".vimrc"        )}
If (Test-Path "C:\sr\config.yaml"              )  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path "C:\sr"  "config.yaml"   )}

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

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

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
        "7zip.install"                      # Archive manager
        "adobereader"                       # PDF reader
        "audacity"                          # Audio editor (oficial site preffered)
        "awscli"                            # Command line tools for AWS
        # "azure-cli"                       # Command line tools for Azure
        # mkdir $env:SystemRoot\System32\Drivers\etc\
        # echo 'nameserver 8.8.8.8' > $env:SystemRoot\System32\Drivers\etc\resolv.conf
        # echo 'nameserver 77.88.8.8' >> $env:SystemRoot\System32\Drivers\etc\resolv.conf
        "bind-toolsonly"                    # DIG and other DNS tools
        "buckaroo"                          # The decentralized package manager for C++ and friends
        # "cabal"                             # Haskell package manager comes with ghc package
        "calibre"                           # Book manager and reader
        "ccleaner"                          # Garbage Collection for Windows
        "chefdk"                            # Chef SDK
        "choco-cleaner"                     # Garbage Collection for Chocolatey
        "chocolateygui"                     # GUI for Chocolate
        "cmake"                             # Build tools generator
        "cmdermini"                         # CoolTerminal manager for Windows
        # "consul"                          # Service networking solution to connect and secure services across any runtime
        "curl"                              # HTTP/WEB Tool
        # "cyberduck"                       # Multi-protocol, remote connections manager
        "dependencywalker"                  # Dependency viewer
        "doublecmd"                         # Two-Panel File Manager
        "drmemory"                          # Memory Debugger
        "du"                                # Disk Usage tool
        # "etcher"                            # Boot ISO creator (Rapspberry)
        "far"                               # Two-Panel File Manager
        "foobar2000"                        # Music player
        # "foxitreader"                       # PDF Reader alternative
        "ftpdmin"                           # FTP explorer
        "fsviewer"                          # FastStone Image viewer
        "ghc"                               # Haskell compiler
        "Ghostscript.app"                   # GhostScript
        "gimp"                              # Image manipulation program
        "git-lfs"                           # Git plugin for Large File Storage
        "git"                               # Git SCM
        "gitextensions"                     # Git repository explorer
        # "gnuwin32-coreutils.install"      # GNU Utils
        "golang"                            # Go programming language
        "gpg4win"                           # GPG for Windows
        "gradle"                            # Build Tools for Java (mostly)
        "graphviz"                          # Graph visualizer
        "greenshot"                         # Screenshot creator
        "grepwin"                           # Grep for Windows (GUI)
        # "haskell-stack"                     # Haskell programming language
        "hg"                                # Mercurial SCM
        "hxd"                               # HEX editor
        "imagemagick"                       # Image manipulation tools
        "imdisk-toolkit"                    # Mount image files of hard drive, cd-rom or floppy, and create one or several ramdisks with various parameters
        "inkscape"                          # Vector graphics software
        "irfanview"                         # Image viewer
        "irfanviewplugins"                  # Image viewer
        # "itunes"                          # Music manager
        # "jdk8"                            # Java 8
        # "jre8"                            # Java 8
        # "jdk10"                           # Java 10
        # "jre10"                           # Java 10
        "jq"                                # JSON parser
        "julia"                             # Julia programming lanuage
        "kdiff3"                            # File comparison
        "keepass"                           # Password Manager
        "keystore-explorer.portable"        # JKS Explorer
        "krita"                             # Painting program
        "kubernetes-cli"                    # Kubernetes command line tools
        "kubernetes-helm"                   # The package manager for Kubernetes
        "kubernetes-kompose"                # A conversion tool to go from Docker Compose to Kubernetes
        "ldapadmin"                         # LDAP Explorer
        "lein"                              # Leiningen - Clojure Project Automation
        "librecad"                          # CAD software
        "libreoffice-fresh"                 # Office package
        "llvm"                              # LLVM compiler collection
        "lockhunter"                        # Unlock ocupied files and folders
        "lunacy"                            # Native Windows app that works offline and supports .sketch files
        "make"                              # Build Tools
        "maven"                             # Java Package Manager
        "maxima"                            # Math software
        "meld"                              # File comparison
        "miktex"                            # TeX tools
        # "mingw"                             # GCC for windows
        "minikube"                          # Mini Kuberneted for Dev
        "mremoteng"                         # Open source, tabbed, multi-protocol, remote connections manager
        "mysql.workbench"                   # MySQL Admin and Explorer
        "nasm"                              # Assebler
        "ninja"                             # Small build system with a focus on speed
        "nmap"                              # Network Scanner
        "nodejs-lts"                        # JavaScript interpreter
        # "nomad"                           # Deploy and Manage Any Containerized, Legacy, or Batch Application
        "notepadplusplus-npppluginmanager"  # Notepad++ Text Editor
        "notepadplusplus"                   # Notepad++ Text Editor
        "nssm"                              # Non-Sucking Service Manager for windows
        "nuget.commandline"                 # NuGet command line tools
        "nugetpackageexplorer"              # NuGet Package Explorer
        "octopustools"                      # Automated release management tool
        "ollydbg"                           # Olly Debugger
        "openshot"                          # OpenShot Video Editor
        "openssh"                           # OpenSSH
        "openssl.light"                     # OpenSSL
        "openvpn"                           # VPN Client
        "packer"                            # VM, Docker, Cloud Image creator
        "paint.net"                         # Image Editor
        "paket.powershell"                  # A dependency manager for .NET with support for NuGet packages and git repositories.
        "pandoc"                            # MarkDown document converter
        "pdfsam"                            # PDF Tools
        "pencil"                            # Pencil Project - UI prototyping tool
        # "pgadmin3"                        # PostgreSQL Administrator
        "pgadmin4"                          # PostgreSQL Administrator
        # "pgina"                           # Pluggable, open source credential provider (and GINA) replacement
        "putty"                             # SSH Client
        "python3"                           # Python 3
        "qbittorrent"                       # Torrent Downloader
        # "qtcreator"                       # Use Native QT installer instead
        "rdcman"                            # Remote Desktop Connection Manager
        "reshack"                           # Resource Hacker
        "robo3t"                            # MongoDB exprlorer
        "ruby"                              # Ruby: cinst msys2 --params "/NoUpdate"; Update-SessionEnvironment; ridk install 2 3
        # choco install -y ruby --version 2.3.3 --params "/NoPath '/InstallDir:C:\tools\ruby23\'"`
        # choco install -y ruby --version 2.6.3 --params "/NoPath '/InstallDir:C:\tools\ruby26\'"`
        # choco install -y ruby --version 2.7.0 --params "/NoPath '/InstallDir:C:\tools\ruby27\'"`
        # "ruby2.devkit"                      # Ruby
        "rufus"                             # Boot USB creation
        # "rust-ms"                         # Use rustup-init instead
        "sandboxie"                         # Isolation technology to separate programs from your underlying OS
        "slack"                             # Slack messanger
        "screentogif"                       # Converts Screenshot secries to GIF
        "strawberryperl"                    # Perl
        # "studio3t"                        # MongoDB exprlorer
        "sublimetext3"                      # Text editor
        # "sumatrapdf"                      # PDF viewer
        "superputty"                        # SSH Client (wrapper on PuTTY)
        "svn"                               # Subversion VCS
        "sqlitebrowser.install"             # SQLite DB Browser
        "swissfileknife"                    # The Swiss File Knife
        "sysinternals"                      # Windows Sysinternals
        "telegram.install"                  # Telegram messanger
        "terraform"                         # Cloud orchestration
        "tftpd32"                           # TFTP server
        "tightvnc"                          # VNC server and client
        "tor-browser"                       # TOR
        "tree"                              # List contents of directories in a tree-like format
        "vagrant-manager"                   # VM Manager
        "vagrant"                           # VM and CLoud Creator
        "vcxsrv"                            # X server for Windows
        "vlc"                               # VLC player
        "vscode"                            # Text editor
        "vscode-insiders"                   # Text editor
        # "vim"                             # Text editor: should be installed manually to cover python 3.6 support
        "whatsapp"                          # Messanger
        "wget"                              # HTTP/WEB Downloader
        "wifiinfoview"                      # WiFi Scanner for Windows 7/8/Vista
        "wincdemu"                          # Virtual CD
        "windirstat"                        # Files and Forlders statistics
        "windjview"                         # DJVU viewer
        "winmerge"                          # File comparison
        "winscp"                            # SCP Client
        "wireshark"                         # Network Analyzer
        "wixtoolset"                        # WIX Tolset
        "wmiexplorer"                       # WMI Explorer
        "x64dbg.portable"                   # X Debugger
        "XnView"                            # Image Viewer
        "xpdf-utils"                        # PDF utils
        "yarn"                              # JS Fast, reliable, and secure dependency management.
        # "yed"                             # Diagram editor: use with '--params /Associate"'
        "yasm"                              # Assembler
        "youtube-dl"                        # YouTube Downloader
        # "zoom"                            # Zoom conference client
    )

    # foreach ($mars in $candies) {
    #     choco install -y -r $mars
    # }
}

#if (Get-Command chef -ErrorAction SilentlyContinue | Test-Path) {
#  chef gem install knife-block
#}

# ConEmu profile
If (Get-Command cmder.exe -ErrorAction SilentlyContinue | Test-Path) {
    $cmder_home = Get-Command cmder.exe | Select-Object -ExpandProperty Definition | Split-Path
    Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "config\user-ConEmu.xml")
    Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "config\user-aliases.cmd")
    Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "vendor\init.bat")
    Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "vendor\profile.ps1")
    Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path $cmder_home "vendor\conemu-maximus5\ConEmu.xml")

    C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "config\user-ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\user-ConEmu.xml")
    C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "config\user-aliases.cmd") (Join-Path $PSScriptRoot "data\conemu\useuser-aliasesr_aliases.cmd")
    C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\init.bat") (Join-Path $PSScriptRoot "data\conemu\init.bat")
    C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\profile.ps1") (Join-Path $PSScriptRoot "data\conemu\profile.ps1")
    C:\Windows\System32\cmd.exe /c mklink (Join-Path $cmder_home "vendor\conemu-maximus5\ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\ConEmu.xml")

    $dep_modules                     = @("ApplicationCompatibility")
    foreach($module in $dep_modules)    { Import-Module (Join-Path $dotfilesModulesDir $module) }
    Set-ApplicationCompatibility -CurrentUser -ApplicationLocation (Get-Command cmder.exe | Select-Object -ExpandProperty Definition) -PrivilegeLevel
}

