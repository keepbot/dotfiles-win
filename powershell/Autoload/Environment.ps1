#!/usr/bin/env powershell

# Make vim the default editor
# $Env:EDITOR = "gvim --nofork"
$Env:EDITOR = "vim --nofork"
$Env:GIT_EDITOR = $Env:EDITOR
# Set-Alias vim gvim

function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Language
$Env:LANG = "en_US"
$Env:LC_ALL = "C.UTF-8"

# Init of directory envs:
$env:PWD = Get-Location
$env:OLDPWD = Get-Location

# Virtual Env Fix (if prompt in ReadOnly mode)
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# PS Readline:
$PSReadLineOptions = @{
  # EditMode = "Vi"
  EditMode = "Emacs"
  MaximumHistoryCount = 32767
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  ShowToolTips = $false
}
Set-PSReadLineOption @PSReadLineOptions

### KEYS:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Ctrl+e -Function DeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Tab -Function Complete

#  1..50000 | % {Set-Variable -Name MaximumHistoryCount -Value $_ }
Set-Variable -Name MaximumHistoryCount -Value 32767

function Reload-Paths-My {
  $paths = @(
    "C:\tools\bin"
    "C:\tools\python3\Scripts"
    "C:\tools\python3"
    "C:\tools\python2\Scripts"
    "C:\tools\python2"
    "C:\usr\bin"
    "C:\Program Files\KDiff3"
    "C:\Program Files\KDiff3\bin"
    "C:\tools\vim\vim81"
    "C:\Program Files\OpenSSL\bin"
    "C:\Program Files\OpenSSH-Win64"
    "C:\Program Files\OpenVPN\bin"
    "C:\Program Files\TAP-Windows\bin"
    "C:\Program Files\Amazon\AWSCLI\bin"
    "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.1\bin"
    "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.2\bin"
    "C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin"
    "C:\Go\bin"
    "C:\Program Files\CMake\bin"
    "C:\Program Files\LLVM\bin"
    "C:\tools\vcpkg"
    "C:\boost\dist\bin"
    "C:\HashiCorp\Vagrant\bin"
    "C:\Program Files (x86)\Nmap"
    "C:\opscode\chefdk\bin"
    "C:\Program Files (x86)\Gpg4win\..\GnuPG\bin"
    "C:\Program Files\Microsoft VS Code\bin"
    "C:\Program Files\Sublime Text 3"
    "C:\Program Files\nodejs"
    "C:\Program Files (x86)\Yarn\bin"
    "C:\Program Files\Git\cmd"
    "C:\Program Files\Git LFS"
    "C:\Program Files\Mercurial"
    "C:\Program Files (x86)\Subversion\bin"
    "C:\tools\ruby26\bin"
    "C:\tools\cmdermini"
    "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu"
    "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu\wsl"
    "C:\Strawberry\c\bin"
    "C:\Strawberry\perl\site\bin"
    "C:\Strawberry\perl\bin"
    "C:\Qt\Qt5.12.1\5.12.1\msvc2017\bin"
    "C:\Qt\Qt5.11.1\5.11.1\msvc2015\bin"
    "C:\Qt\Qt5.9.5\5.9.5\msvc2015\bin"
    "C:\Program Files\ImageMagick-7.0.8-Q16"
    "C:\Program Files\MiKTeX 2.9\miktex\bin\x64"
    "C:\Program Files\Pandoc"
    "C:\Program Files\grepWin"
    "C:\tools\Atlassian\atlassian-plugin-sdk-6.3.10\bin"
    "C:\Program Files\Calibre2"
    "C:\Program Files (x86)\Dr. Memory\bin64"
    "C:\ProgramData\chocolatey\bin"
    "C:\Program Files (x86)\IncrediBuild"
    "C:\tools\CppDepend"
    "C:\Program Files\MySQL\MySQL Workbench 8.0 CE"
    "c:\Program Files\NASM"
    "C:\Program Files\S3 Browser"
    "C:\Program Files\VcXsrv"
    "C:\Program Files (x86)\Graphviz2.38\bin\"
    "C:\Program Files (x86)\pgAdmin 4\v3\runtime"
    "C:\tools\ProccessHacker"
    "C:\Program Files\Rust stable MSVC 1.32\bin"
    "C:\tools\doublecmd"
    "C:\msys64"
    )

  $final_path = "$env:USERPROFILE\workspace\my\dotfiles\bin-win"

  foreach ($path in $paths) {
    If (Test-Path $path)  {
      $final_path += ";$path"
    }
  }

  [Environment]::SetEnvironmentVariable("PathsMy", "$final_path", "Machine")
}

function Reload-Paths-Orig {
  $paths = @(
    "$env:SystemRoot"
    "$env:SystemRoot\System32\Wbem"
    "$env:SYSTEMROOT\System32\WindowsPowerShell\v1.0"
    "$env:SYSTEMROOT\System32\OpenSSH"
    "C:\ProgramData\DockerDesktop\version-bin"
    "C:\Program Files\Docker\Docker\Resources\bin"
    "C:\Program Files\Microsoft MPI\Bin\"
    "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\"
    "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin"
    "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\libnvvp"
    "C:\Program Files\Intel\TXE Components\TCS"
    "C:\Program Files (x86)\Intel\TXE Components\TCS"
    "C:\Program Files\Intel\TXE Components\DAL"
    "C:\Program Files (x86)\Intel\TXE Components\DAL"
    "C:\Program Files\Intel\TXE Components\IPT"
    "C:\Program Files (x86)\Intel\TXE Components\IPT"
    "C:\Program Files\Common Files\Intel\WirelessCommon"
    "C:\Program Files\Intel\WiFi\bin"
    "C:\Program Files\dotnet"
    "C:\Program Files\Microsoft SQL Server\130\Tools\Binn"
    "C:\Program Files (x86)\Common Files\Oracle\Java\javapath"
    "C:\tools\wsl\arch"
    "C:\tools\wsl\debian"
    "C:\tools\wsl\kali"
    "C:\tools\wsl\ubuntu"
  )

  $final_path = "$env:SystemRoot\system32"

  foreach ($path in $paths) {
    If (Test-Path $path)  {
      $final_path += ";$path"
    }
  }

  [Environment]::SetEnvironmentVariable("PathsOrig", "$final_path", "Machine")
}
function Reload-Paths-User {
  $paths = @(
    "${env:USERPROFILE}\.cargo\bin"
    "${env:USERPROFILE}\AppData\Roaming\local\bin"
    "${env:GOPATH}\bin"
    "${env:USERPROFILE}\AppData\Roaming\npm"
    "${env:USERPROFILE}\AppData\Local\Pandoc"
    "${env:USERPROFILE}\AppData\Local\Yarn\bin"
  )

  $final_path = "${env:USERPROFILE}\AppData\Local\Microsoft\WindowsApps"

  foreach ($path in $paths) {
    If (Test-Path $path)  {
      $final_path += ";$path"
    }
  }

  [Environment]::SetEnvironmentVariable("PATH", "$final_path", "User")

}

function Set-Base-Env {
  Reload-Paths-My
  Reload-Paths-Orig
  # $system_path = "%PathsMy%"
  # $system_path += ";%JAVA_HOME%\bin"
  # $system_path += ";%VC_PATH%"
  # $system_path += ";%PathsOrig%"
  $system_path = "$env:PathsMy"
  $system_path += ";$env:JAVA_HOME\bin"
  $system_path += ";$env:VC_PATH"
  $system_path += ";$env:PathsOrig"
  # if (Test-Path env:JAVA_HOME) {
  # }
  # if (Test-Path env:VC_PATH) {
  # }
  [Environment]::SetEnvironmentVariable("PATH", "$system_path", "Machine")
  [Environment]::SetEnvironmentVariable("LANG", "en_US", "Machine")
  Reload-Paths-User
}

function Set-Dev-Env {
  If (Test-Path "C:\Program Files\Git LFS")  {
    [Environment]::SetEnvironmentVariable("GIT_LFS_PATH", "C:\Program Files\Git LFS", "Machine")
  }
  If (Test-Path "C:\Qt\Qt5.11.1\5.11.1\msvc2015")  {
    [Environment]::SetEnvironmentVariable("QTDIR", "C:\Qt\Qt5.11.1\5.11.1\msvc2015", "Machine")
  }
  If (Test-Path "C:\Qt\Qt5.12.1\5.12.1\msvc2017")  {
    [Environment]::SetEnvironmentVariable("QTDIR", "C:\Qt\Qt5.12.1\5.12.1\msvc2017", "Machine")
  }
  If (Test-Path "C:\Qt\Qt5.11.1\5.11.1\msvc2015\mkspecs\win32-msvc")  {
    [Environment]::SetEnvironmentVariable("QMAKESPEC", "C:\Qt\Qt5.11.1\5.11.1\msvc2015\mkspecs\win32-msvc", "Machine")
  }
  If (Test-Path "C:\Qt\Qt5.12.1\5.12.1\msvc2017\mkspecs\win32-msvc")  {
    [Environment]::SetEnvironmentVariable("QMAKESPEC", "C:\Qt\Qt5.12.1\5.12.1\msvc2017\mkspecs\win32-msvc", "Machine")
  }
  If (Test-Path "$env:HOME\workspace\ormco\common\aligner-thirdparty")  {
    [Environment]::SetEnvironmentVariable("THIRDPARTY_LOCATION", "$env:HOME\workspace\ormco\common\aligner-thirdparty", "Machine")
  }
}

${function:env} = {Get-ChildItem Env:}
${function:List-Env} = { Get-ChildItem Env: }
${function:List-Paths} = { $Env:Path.Split(';') }

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value) {
  Set-ItemProperty "HKCU:\Environment" $variable $value
  # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
  #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
  Invoke-Expression "`$env:${variable} = `"$value`""
}

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
