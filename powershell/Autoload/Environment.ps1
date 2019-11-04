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

${function:env} = {Get-ChildItem Env:}
${function:List-Env} = { Get-ChildItem Env: }
${function:List-Paths} = { $Env:Path.Split(';') }

function Initialize-Paths-APP {
    $paths = @(
        "C:\ProgramData\chocolatey\bin"
        "C:\usr\bin"
        "C:\Program Files\Git LFS"
        "C:\Program Files\Git\cmd"
        "C:\Program Files (x86)\GitExtensions\"
        "C:\Program Files\KDiff3"
        "C:\Program Files\KDiff3\bin"
        "C:\tools\vim\vim81"
        "C:\Program Files\OpenSSL\bin"
        "C:\Program Files\OpenSSH-Win64"
        "C:\Program Files\OpenVPN\bin"
        "C:\Program Files\TAP-Windows\bin"
        "C:\Program Files\Amazon\AWSCLI\bin"
        "C:\Program Files\CMake\bin"
        "C:\Program Files\LLVM\bin"
        "C:\Program Files\BinDiff\bin"
        "${Env:M2_HOME}/bin"
        "C:\tools\vcpkg"
        "C:\boost\dist\bin"
        "C:\Go\bin"
        "C:\Program Files\Rust stable MSVC 1.33\bin"
        "C:\Program Files\Rust stable MSVC 1.32\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.8.1\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.4\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.2\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.1\bin"
        # "C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin"
        "C:\Strawberry\c\bin"
        "C:\Strawberry\perl\site\bin"
        "C:\Strawberry\perl\bin"
        "C:\tools\msys64"
        "C:\tools\swig"
        "C:\Program Files\Microsoft VS Code\bin"
        "C:\Program Files\Microsoft VS Code Insiders\bin"
        "C:\HashiCorp\Vagrant\bin"
        "C:\Program Files (x86)\Nmap"
        "C:\opscode\chefdk\bin"
        "C:\Program Files (x86)\Gpg4win\..\GnuPG\bin"
        "C:\Program Files (x86)\GNU\GnuPG\pub"
        "C:\Program Files\Sublime Text 3"
        "C:\Program Files\nodejs"
        "C:\Program Files (x86)\Yarn\bin"
        "C:\Program Files\Mercurial"
        "C:\Program Files (x86)\Subversion\bin"
        "C:\tools\ruby26\bin"
        "C:\tools\ruby25\bin"
        "C:\tools\cmdermini"
        "C:\tools\cmdermini\bin"
        "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu"
        "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu\wsl"
        # "C:\Qt\Qt5.12.1\5.12.1\msvc2017\bin"
        # "C:\Qt\Qt5.11.1\5.11.1\msvc2015\bin"
        # "C:\Qt\Qt5.9.5\5.9.5\msvc2015\bin"
        "C:\Program Files\ImageMagick-7.0.8-Q16"
        "C:\Program Files\MiKTeX 2.9\miktex\bin\x64"
        "C:\Program Files\Pandoc"
        "C:\Program Files\grepWin"
        "C:\tools\Atlassian\atlassian-plugin-sdk-8.0.16\bin"
        "C:\tools\Atlassian\atlassian-plugin-sdk-6.3.10\bin"
        "C:\Program Files\Calibre2"
        "C:\Program Files (x86)\Dr. Memory\bin64"
        "C:\Program Files (x86)\IncrediBuild"
        "C:\tools\CppDepend"
        "C:\Program Files\MySQL\MySQL Workbench 8.0 CE"
        "c:\Program Files\NASM"
        "C:\Program Files\S3 Browser"
        "C:\Program Files\VcXsrv"
        "C:\Program Files (x86)\Graphviz2.38\bin\"
        "C:\Program Files (x86)\pgAdmin 4\v3\runtime"
        "C:\Program Files (x86)\pgAdmin 4\v4\runtime"
        "C:\tools\ProccessHacker"
        "C:\tools\doublecmd"
        "C:\tools\wsl\arch"
        "C:\tools\wsl\debian"
        "C:\tools\wsl\kali"
        "C:\tools\wsl\ubuntu"
        "C:\tools\emsdk"
    )

    $final_path = "C:\tools\bin"

    foreach ($path in $paths) {
        If (Test-Path $path)  {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PathsApp", "$final_path", "Machine")
}

function Initialize-Paths-SYS {
    $paths = @(
        "$env:SystemRoot"
        "$env:SystemRoot\System32\Wbem"
        "$env:SYSTEMROOT\System32\WindowsPowerShell\v1.0"
        "$env:SYSTEMROOT\System32\OpenSSH"
        "C:\ProgramData\DockerDesktop\version-bin"
        "C:\Program Files\Docker\Docker\Resources\bin"
        "C:\Program Files\Microsoft MPI\Bin\"
        "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\bin"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\libnvvp"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\libnvvp"
        "C:\Program Files\NVIDIA Corporation\Nsight Compute 2019.4.0\"
        "C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common"
        "C:\Program Files\Intel\TXE Components\TCS"
        "C:\Program Files\Intel\TXE Components\IPT"
        "C:\Program Files\Intel\TXE Components\DAL"
        "C:\Program Files (x86)\Intel\TXE Components\TCS"
        "C:\Program Files (x86)\Intel\TXE Components\DAL"
        "C:\Program Files (x86)\Intel\TXE Components\IPT"
        "C:\Program Files\Common Files\Intel\WirelessCommon"
        "C:\Program Files\Intel\WiFi\bin"
        "C:\Program Files\dotnet"
        "C:\Program Files\Microsoft SQL Server\130\Tools\Binn\"
        "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\"
        "C:\Program Files (x86)\Common Files\Oracle\Java\javapath"
        "C:\Program Files (x86)\Windows Kits\8.1\Windows Performance Toolkit\"
    )

    $final_path = "$env:SystemRoot\system32"

    foreach ($path in $paths) {
        If (Test-Path $path)  {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PathsSys", "$final_path", "Machine")
}
function Initialize-Paths-User {
    $paths = @(
        "${env:GOPATH}\bin"
        # "${env:USERPROFILE}\go\bin"
        "${env:USERPROFILE}\.cargo\bin"
        "${env:USERPROFILE}\.dotnet\tools"
        "${env:USERPROFILE}\AppData\Roaming\npm"
        "${env:USERPROFILE}\AppData\Local\Pandoc"
        "${env:USERPROFILE}\AppData\Local\Yarn\bin"
        "${env:USERPROFILE}\AppData\Roaming\local\bin"
        "${env:USERPROFILE}\AppData\Roaming\cabal\bin"
        "${env:USERPROFILE}\AppData\Local\Android\Sdk\platform-tools\"
        "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin"
    )

    $final_path = "${env:USERPROFILE}\AppData\Local\Microsoft\WindowsApps"

    foreach ($path in $paths) {
        If (Test-Path $path)  {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PATH", "$final_path", "User")

}

function Set-Env {
    # PATHs
    Initialize-Paths-APP
    Initialize-Paths-SYS
    Initialize-Paths-User
    Reset-Environment
    $system_path = "$env:USERPROFILE\workspace\my\dotfiles\bin-win"
    if ($env:PYTHON_PATH) {
        $system_path += ";$env:PYTHON_PATH\Scripts"
        $system_path += ";$env:PYTHON_PATH"
    }
    if ($env:JAVA_HOME) {
        $system_path += ";$env:JAVA_HOME\bin"
    }
    if ($env:VC_IDE) {
        $system_path += ";$env:VC_IDE"
    }
    # if ($env:VC_PATH) {
    #     $system_path += ";$env:VC_PATH"
    # }
    if ($env:QTDIR) {
        $system_path += ";$env:QTDIR\bin"
    }
    $system_path += ";$env:PathsApp"
    $system_path += ";$env:PathsSys"
    [Environment]::SetEnvironmentVariable("PATH", "$system_path", "Machine")
    [Environment]::SetEnvironmentVariable("PathsSys", $null, "Machine")
    [Environment]::SetEnvironmentVariable("PathsApp", $null, "Machine")

    # LANG
    [Environment]::SetEnvironmentVariable("LANG", "en_US", "Machine")

    # Development Env
    If (Test-Path "C:\Program Files\Git LFS")  {
        [Environment]::SetEnvironmentVariable("GIT_LFS_PATH", "C:\Program Files\Git LFS", "Machine")
    }
    If (Test-Path "$env:HOME\workspace\ormco\common\aligner-thirdparty")  {
        [Environment]::SetEnvironmentVariable("THIRDPARTY_LOCATION", "$env:HOME\workspace\ormco\common\aligner-thirdparty", "Machine")
    }
    If (Test-Path "$env:HOME\workspace\ormco\aligner\testdataaligner")  {
        [Environment]::SetEnvironmentVariable("TESTDATA_LOCATION", "$env:HOME\workspace\ormco\aligner\testdataaligner", "Machine")
    }
    Reset-Environment
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Reload the $env object from the registry
function Reset-Environment {
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

if (Test-Path "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin") { ${function:icode} = {code-insiders.cmd @args} }
if (Test-Path "C:\Program Files\Microsoft VS Code Insiders\bin") { ${function:icode} = {code-insiders.cmd @args} }
If (Test-Path "C:\Program Files\Microsoft VS Code\bin") { ${function:vscode} = {code.cmd @args} }
