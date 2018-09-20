#!/usr/bin/env powershell

# Make vim the default editor
$Env:EDITOR = "gvim --nofork"
$Env:GIT_EDITOR = $Env:EDITOR

# Language
$Env:LANG = "en_US"
$Env:LC_ALL = "C.UTF-8"

# Virtual Env Fix (if prompt in ReadOnly mode)
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

### KEYS:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Ctrl+e -Function DeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Tab -Function Complete

function Reload-Paths-My {
  $paths = @(
    "C:\ProgramData\chocolatey\bin"
    "C:\tools\python3\Scripts\"
    "C:\tools\python3\"
    "C:\tools\python2\Scripts"
    "C:\tools\python2\"
    "C:\usr\bin"
    "C:\Program Files (x86)\vim\vim81"
    "C:\Program Files\OpenSSL\bin"
    "C:\Program Files\OpenSSH-Win64"
    "C:\Program Files\Amazon\AWSCLI\"
    "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.4.3\bin"
    "C:\tools\mingw64\bin"
    "C:\tools\go\bin"
    "C:\Program Files\LLVM\bin"
    "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.15.26726\bin\Hostx64\x64"
    "C:\HashiCorp\Vagrant\bin"
    "C:\Program Files (x86)\Nmap"
    "C:\opscode\chefdk\bin\"
    "C:\Program Files (x86)\Gpg4win\..\GnuPG\bin"
    "C:\Program Files\Microsoft VS Code\bin"
    "C:\Program Files\nodejs\"
    "C:\Program Files (x86)\Yarn\bin\"
    "C:\Program Files\Git\cmd"
    "C:\Program Files\Git LFS"
    "C:\Program Files\Mercurial"
    "C:\Program Files (x86)\Subversion\bin"
    "C:\tools\ruby25\bin"
    "C:\tools\cmdermini"
    "C:\Strawberry\c\bin"
    "C:\Strawberry\perl\site\bin"
    "C:\Strawberry\perl\bin"
    "C:\Qt\Qt5.11.1\5.11.1\msvc2015\bin"
    "C:\Program Files\ImageMagick-7.0.8-Q16"
    "C:\Program Files\MiKTeX 2.9\miktex\bin\x64\"
    "C:\Program Files\Pandoc\"
    "C:\Program Files\grepWin"
  )

  $final_path = "C:\Users\dmitriy.ivanov\workspace\my\dotfiles\bin-win"

  foreach ($path in $paths) {
    $final_path += ";$path"
  }

  [Environment]::SetEnvironmentVariable("PathsMy", "$final_path", "Machine")
}

function Reload-Paths-Orig {
  $paths = @(
    "%SystemRoot%"
    "%SystemRoot%\System32\Wbem"
    "%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\"
    "%SYSTEMROOT%\System32\OpenSSH\"
    "C:\Program Files (x86)\Common Files\Oracle\Java\javapath"
    "C:\Program Files\Docker\Docker\Resources\bin"
  )

  $final_path = "%SystemRoot%\system32"

  foreach ($path in $paths) {
    $final_path += ";$path"
  }

  [Environment]::SetEnvironmentVariable("PathsOrig", "$final_path", "Machine")
}

function Set-Envs {
  Reload-Paths-My
  Reload-Paths-Orig
  # [Environment]::SetEnvironmentVariable("PATH", "%PathsMy%;%PathsOrig%", "Machine")

  [Environment]::SetEnvironmentVariable("LANG", "en_US", "Machine")
  [Environment]::SetEnvironmentVariable("GIT_LFS_PATH", "C:\Program Files\Git LFS", "Machine")
  [Environment]::SetEnvironmentVariable("QTDIR", "C:\Qt\Qt5.11.1\5.11.1\msvc2015", "Machine")
  [Environment]::SetEnvironmentVariable("QMAKESPEC", "C:\Qt\Qt5.11.1\5.11.1\msvc2015\mkspecs\win32-msvc", "Machine")
}
