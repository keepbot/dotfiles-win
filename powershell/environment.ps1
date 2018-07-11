#!/usr/bin/env powershell

# Make vim the default editor
$Env:EDITOR = "gvim --nofork"
$Env:GIT_EDITOR = $Env:EDITOR

# Language
$Env:LANG = "en"
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
  "C:\Program Files\grepWin"
  "C:\Program Files\Docker\Docker\Resources\bin"
  "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"
  "C:\Python36\"
  "C:\Python36\Scripts\"
  "C:\Python27\"
  "C:\Python27\Scripts"
  "C:\ProgramData\chocolatey\bin"
  "C:\Program Files\OpenSSL\bin"
  #"C:\Program Files (x86)\vim80"
  "C:\Program Files (x86)\vim\vim81"
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
  "C:\Program Files\Git LFS"
  "C:\tools\ruby25\bin"
  "C:\Program Files\Sublime Text 3"
  "C:\Program Files\Mercurial"
  "C:\Program Files (x86)\Android\android-sdk\platform-tools\"
  "C:\Program Files\ImageMagick-7.0.7-Q16"
  "C:\Program Files\Calibre2\"
  )

  $final_path = "C:\Users\dkiva\workspace\my\dotfiles\bin-win"

  foreach ($path in $paths) {
    $final_path += ";$path"
  }

  [Environment]::SetEnvironmentVariable("PathsMy", "$final_path", "Machine")
}

function Reload-Paths-Orig {
  $paths = @(
  "C:\WINDOWS"
  "C:\WINDOWS\System32\Wbem"
  "C:\WINDOWS\System32\WindowsPowerShell\v1.0\"
  "C:\WINDOWS\System32\OpenSSH\"
  "C:\Program Files (x86)\Common Files\Oracle\Java\javapath"
  "C:\ProgramData\Oracle\Java\javapath"
  "C:\Program Files\Docker\Docker\Resources\bin"
  "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.1\bin"
  "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v9.1\libnvvp"
  "C:\Program Files\Microsoft MPI\Bin\"
  "C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\iCLS\"
  "C:\Program Files\Intel\Intel(R) Management Engine Components\iCLS\"
  "C:\Program Files\Common Files\Microsoft Shared\Microsoft Online Services"
  "C:\Program Files (x86)\Common Files\Microsoft Shared\Microsoft Online Services"
  "C:\Program Files\dotnet\"
  "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\"
  "C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL"
  "C:\Program Files\Intel\Intel(R) Management Engine Components\DAL"
  "C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\IPT"
  "C:\Program Files\Intel\Intel(R) Management Engine Components\IPT"
  "C:\Program Files\Intel\WiFi\bin\"
  "C:\Program Files\Common Files\Intel\WirelessCommon\"
  "C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common"
  "C:\Program Files (x86)\Xoreax\IncrediBuild"
  "C:\VulkanSDK\1.1.70.1\Bin"
  "C:\Program Files (x86)\Skype\Phone\"
  "C:\Program Files (x86)\Microsoft Emulator Manager\1.0\"
  )

  $final_path = "C:\WINDOWS\system32"

  foreach ($path in $paths) {
    $final_path += ";$path"
  }

  [Environment]::SetEnvironmentVariable("PathsOrig", "$final_path", "Machine")
}
