<#
.SYNOPSIS
Environment scripts.

.DESCRIPTION
Environment scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


# Make vim the default editor\
# $Env:VISUAL = "vim --nofork"
$Env:VISUAL = "gvim --nofork"
$Env:EDITOR = "${Env:VISUAL}"
$Env:GIT_EDITOR = $Env:EDITOR
# Set-Alias vim gvim

# Language
$Env:LANG   = "en_US"
# $Env:LC_ALL = "C.UTF-8"
$Env:LC_ALL = "C"

# Init of directory envs:
$env:PWD = Get-Location
$env:OLDPWD = Get-Location

# Virtual Env Fix (if prompt in ReadOnly mode)
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# PS Readline:
$PSReadLineOptions = @{
    # EditMode = "Vi"
    EditMode = "Emacs"

    # Defaiult word delimiters
    WordDelimiters = ';:,.[]{}()/\|^&*-=+`"–—―'
    # Bash 4.0 word delimiters
    # WordDelimiters = '()<>;&|"'

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
        "${env:USERPROFILE}\OneDrive\bin"
        "C:\ProgramData\chocolatey\bin"
        "C:\usr\bin"
        "C:\Program Files\Git\cmd"
        "C:\Program Files\Git LFS"
        "C:\Program Files (x86)\GitExtensions\"
        "C:\Program Files\KDiff3"
        "C:\Program Files\KDiff3\bin"
        "C:\Program Files\OpenSSL\bin"
        "C:\Program Files\OpenSSH-Win64"
        "C:\Program Files\OpenVPN\bin"
        "C:\Program Files\TAP-Windows\bin"
        "C:\Program Files\Amazon\AWSCLIV2\"
        "C:\Program Files\Amazon\AWSCLI\bin"
        "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"
        "C:\Program Files\CMake\bin"
        "C:\Program Files\LLVM\bin"
        "C:\Program Files\BinDiff\bin"
        "C:\Go\bin"
        "C:\Program Files\Rust stable MSVC 1.33\bin"
        "C:\Program Files\Rust stable MSVC 1.32\bin"
        "C:\Strawberry\perl\bin"
        "C:\Strawberry\perl\site\bin"
        "C:\Program Files\Microsoft VS Code\bin"
        "C:\Program Files\Microsoft VS Code Insiders\bin"
        "C:\Program Files (x86)\Nmap"
        "C:\Program Files (x86)\Gpg4win\..\GnuPG\bin"
        "C:\Program Files (x86)\GNU\GnuPG\pub"
        "C:\Program Files\Sublime Text 3"
        "C:\Program Files\nodejs"
        "C:\Program Files (x86)\Yarn\bin"
        "C:\Program Files\Mercurial"
        "C:\Program Files (x86)\Subversion\bin"
        # "C:\Qt\Qt5.12.1\5.12.1\msvc2017\bin"
        # "C:\Qt\Qt5.11.1\5.11.1\msvc2015\bin"
        # "C:\Qt\Qt5.9.5\5.9.5\msvc2015\bin"
        "C:\Program Files\ImageMagick-7.0.10-Q16-HDRI"
        "C:\Program Files\ImageMagick-7.0.10-Q16"
        "C:\Program Files\ImageMagick-7.0.8-Q16"
        "C:\Program Files\MiKTeX 2.9\miktex\bin\x64"
        "C:\Program Files\Pandoc"
        "C:\Program Files\grepWin"
        "C:\Program Files\Calibre2"
        "C:\Program Files (x86)\Dr. Memory\bin64"
        "C:\Program Files (x86)\IncrediBuild"
        "C:\Program Files\MySQL\MySQL Workbench 8.0 CE"
        "c:\Program Files\NASM"
        "C:\Program Files\S3 Browser"
        "C:\Program Files\VcXsrv"
        "C:\Program Files (x86)\Graphviz2.38\bin\"
        "C:\Program Files (x86)\pgAdmin 4\v3\runtime"
        "C:\Program Files (x86)\pgAdmin 4\v4\runtime"
        "C:\Program Files\f3d\bin"
        "C:\ProgramData\chocolatey\lib\pulumi\tools\Pulumi\bin"
        "C:\Program Files\gs\gs9.53.1\bin"
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
        "C:\Program Files\Microsoft MPI\Bin\"
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\MSBuild\Current\Bin\Roslyn"
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\16.0\Bin\Roslyn"
        "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.2\bin"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\bin"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.2\libnvvp"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1\libnvvp"
        "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\libnvvp"
        "C:\Program Files\NVIDIA Corporation\Nsight Compute 2019.5.0\"
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
        "C:\Program Files\Docker\Docker\resources\bin"
        "C:\ProgramData\DockerDesktop\version-bin"
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
        "${env:M2_HOME}\bin"
        "${env:USERPROFILE}\go\bin"
        "${env:USERPROFILE}\.cargo\bin"
        "${env:USERPROFILE}\.dotnet\tools"
        "${env:USERPROFILE}\AppData\Local\Android\Sdk\platform-tools\"
        "${env:USERPROFILE}\AppData\Local\Pandoc"
        "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin"
        "${env:USERPROFILE}\AppData\Local\Yarn\bin"
        "${env:USERPROFILE}\AppData\Roaming\cabal\bin"
        "${env:USERPROFILE}\AppData\Roaming\local\bin"
        "${env:USERPROFILE}\AppData\Roaming\npm"
        "C:\boost\dist\bin"
        "C:\HashiCorp\Vagrant\bin"
        "C:\msys64"
        "C:\opscode\chefdk\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.10.2\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.10.1\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.1\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.2\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.6.4\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.8.1\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.8.3\bin"
        "C:\tools\Atlassian\atlassian-plugin-sdk-6.3.10\bin"
        "C:\tools\Atlassian\atlassian-plugin-sdk-8.0.16\bin"
        "C:\tools\BCURRAN3"
        "C:\tools\cmdermini"
        "C:\tools\cmdermini\bin"
        "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu"
        "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu\wsl"
        "C:\tools\CppDepend"
        "C:\tools\doublecmd"
        "C:\tools\emsdk"
        "C:\tools\fasm"
        "C:\tools\msys64"
        "C:\tools\ProccessHacker"
        "C:\tools\swig"
        "C:\tools\sfktrayfree"
        "C:\tools\vcpkg"
        "C:\tools\gnuplot\bin"
        "C:\tools\wsl\arch"
        "C:\tools\wsl\debian"
        "C:\tools\wsl\kali"
        "C:\tools\wsl\ubuntu"
        "C:\tools\sonar-scanner-4.4.0.2170-windows\bin"
        "C:\tools\neovim\Neovim\bin"
        "C:\tools\vim\vim82"
        # "C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin"
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
    # Save current variables
    [Environment]::SetEnvironmentVariable("PATH_PRE_SYS", "$([Environment]::GetEnvironmentVariable("PATH", "Machine"))", "Machine")
    [Environment]::SetEnvironmentVariable("PATH_PRE_USR", "$([Environment]::GetEnvironmentVariable("PATH", "User"))",    "Machine")

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
    # if ($env:PYENV) {
    #     $system_path += ";$env:PYENV\bin"
    #     $system_path += ";$env:PYENV\shims"
    # }
    if ($env:RUBY_PATH) {
        $system_path += ";$env:RUBY_PATH"
    }
    if ($env:RPROJECT_PATH) {
        $system_path += ";$env:RPROJECT_PATH"
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
    if ($env:SquishBinDir) {
        $system_path += ";$env:SquishBinDir"
    }
    if ($env:VISUALGDB_DIR) {
        $system_path += ";$env:VISUALGDB_DIR"
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

    Set-WorkEnv

    Reset-Environment
}

function Set-WorkEnv {
    If (Test-Path "$env:HOME\workspace\ormco\common\aligner-thirdparty")  {
        [Environment]::SetEnvironmentVariable("THIRDPARTY_LOCATION", "$env:HOME\workspace\ormco\common\aligner-thirdparty", "Machine")
    }
    If (Test-Path "$env:HOME\workspace\ormco\aligner\testdataaligner")  {
        [Environment]::SetEnvironmentVariable("TESTDATA_LOCATION", "$env:HOME\workspace\ormco\aligner\testdataaligner", "Machine")
    }
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

function Edit-Hosts
{
    Invoke-Expression "sudo $(
        if($null -ne $env:EDITOR)
        {
            $env:EDITOR
        }
        else
        {
            'notepad'
        }) $env:windir\system32\drivers\etc\hosts"
}

function Edit-Profile
{
    Invoke-Expression "$(
        if($null -ne $env:EDITOR)
        {
            $env:EDITOR
        }
        else
        {
            'notepad'
        }) $profile"
}
