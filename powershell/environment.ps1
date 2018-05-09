#!/usr/bin/env powershell

# Make vim the default editor
$Env:EDITOR = "gvim --nofork"
$Env:GIT_EDITOR = $Env:EDITOR

# Language
$Env:LANG = "en"

# Virtual Env Fix (if prompt in ReadOnly mode)
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

### KEYS:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Ctrl+e -Function DeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord

function Reload-Paths {
  $paths = @(
  "C:\Program Files\Docker\Docker\Resources\bin"
  "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"
  "C:\Python36\"
  "C:\Python36\Scripts\"
  "C:\Python27\"
  "C:\Python27\Scripts"
  "C:\ProgramData\chocolatey\bin"
  "C:\Program Files (x86)\vim80"
  "C:\usr\bin"
  "C:\Program Files\Microsoft VS Code\bin"
  "C:\Program Files (x86)\Nmap"
  "C:\Program Files\OpenSSH-Win64"
  "C:\tools\mingw64\bin"
  "C:\Strawberry\c\bin"
  "C:\Strawberry\perl\site\bin"
  "C:\Strawberry\perl\bin"
  "C:\tools\go\bin"
  "C:\Program Files\MiKTeX 2.9\miktex\bin\x64\"
  "C:\Program Files (x86)\Subversion\bin"
  "C:\Program Files\LLVM\bin"
  "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\bin\Hostx64\x64"
  "C:\HashiCorp\Vagrant\bin"
  "C:\PostgreSQL\pg10\bin"
  "C:\Program Files\Amazon\AWSCLI\"
  "C:\opscode\chefdk\bin\"
  "C:\Program Files (x86)\Gpg4win\..\GnuPG\bin"
  "C:\Program Files\nodejs\"
  "C:\Program Files (x86)\Yarn\bin\"
  "C:\Program Files\Git\cmd"
  "C:\tools\ruby25\bin"
  "C:\Program Files\Sublime Text 3"
  "C:\Program Files\Mercurial"
  )

  $final_path = "C:\Users\dkiva\workspace\my\dotfiles\bin-win"

  foreach ($path in $paths) {
    $final_path += ";$path"
  }

  [Environment]::SetEnvironmentVariable("MyPaths", "$final_path", "Machine")
}
