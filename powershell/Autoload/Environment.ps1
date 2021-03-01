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

# C:\Program Files\       --> C:\PROGRA~1\
# C:\Program Files (x86)\ --> C:\PROGRA~2\
# C:\ProgramData\         --> C:\PROGRA~3\
function Initialize-Paths-APP
{
    $paths = @(
        "C:\PROGRA~1\PowerShell\7\"
        "${env:USERPROFILE}\OneDrive\bin"
        "C:\usr\bin"
        "C:\ProgramData\chocolatey\bin"
        "C:\tools\cmdermini"
        "C:\tools\cmdermini\bin"
        "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu"
        "C:\tools\cmdermini\vendor\conemu-maximus5\ConEmu\wsl"
        "C:\PROGRA~1\Amazon\AWSCLI\bin"
        "C:\PROGRA~1\Amazon\AWSCLIV2\"
        "C:\PROGRA~1\BinDiff\bin"
        "C:\PROGRA~1\Calibre2"
        "C:\PROGRA~1\CMake\bin"
        "C:\PROGRA~1\f3d\bin"
        "C:\PROGRA~1\Git LFS"
        "C:\PROGRA~1\Git\cmd"
        "C:\PROGRA~1\grepWin"
        "C:\PROGRA~1\gs\gs9.53.1\bin"
        "C:\PROGRA~1\ImageMagick-7.0.10-Q16-HDRI"
        "C:\PROGRA~1\KDiff3"
        "C:\PROGRA~1\KDiff3\bin"
        "C:\PROGRA~1\LLVM\bin"
        "C:\PROGRA~1\Mercurial"
        "C:\PROGRA~1\Microsoft VS Code Insiders\bin"
        "C:\PROGRA~1\Microsoft VS Code\bin"
        "C:\PROGRA~1\MiKTeX\miktex\bin\x64"
        "C:\PROGRA~1\MySQL\MySQL Workbench 8.0 CE"
        "C:\PROGRA~1\NASM"
        "C:\PROGRA~1\nodejs"
        "C:\PROGRA~1\Go\bin\"
        "C:\PROGRA~1\OpenSSH-Win64"
        "C:\PROGRA~1\OpenSSL\bin"
        "C:\PROGRA~1\OpenVPN\bin"
        "C:\PROGRA~1\Pandoc"
        "C:\PROGRA~1\Rust stable MSVC 1.33\bin"
        "C:\PROGRA~1\S3 Browser"
        "C:\PROGRA~1\Sublime Text 3"
        "C:\PROGRA~1\TAP-Windows\bin"
        "C:\PROGRA~1\VcXsrv"
        "C:\PROGRA~2\Dr. Memory\bin64"
        "C:\PROGRA~2\GitExtensions\"
        "C:\PROGRA~2\GNU\GnuPG\pub"
        "C:\PROGRA~2\Gpg4win\..\GnuPG\bin"
        "C:\PROGRA~2\Graphviz2.38\bin\"
        "C:\PROGRA~2\Microsoft SDKs\Azure\CLI2\wbin"
        "C:\PROGRA~2\Nmap"
        "C:\PROGRA~2\pgAdmin 4\v4\runtime"
        "C:\PROGRA~2\Subversion\bin"
        "C:\PROGRA~2\Yarn\bin"
        "C:\ProgramData\chocolatey\lib\ghc\tools\ghc-8.10.4\bin"
        # "C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin"
        "C:\ProgramData\chocolatey\lib\pulumi\tools\Pulumi\bin"
    )

    $final_path = "C:\tools\bin"

    foreach ($path in $paths)
    {
        If (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PathsApp", "$final_path", "Machine")
}

# C:\Program Files\       --> C:\PROGRA~1\
# C:\Program Files (x86)\ --> C:\PROGRA~2\
# C:\ProgramData\         --> C:\PROGRA~3\
function Initialize-Paths-SYS
{
    $paths = @(
        "$env:SystemRoot"
        "$env:SystemRoot\System32\Wbem"
        "$env:SYSTEMROOT\System32\WindowsPowerShell\v1.0"
        "$env:SYSTEMROOT\System32\OpenSSH"
        "C:\ProgramData\DockerDesktop\version-bin"
        "C:\PROGRA~1\Common Files\Intel\WirelessCommon"
        "C:\PROGRA~1\Docker\Docker\resources\bin"
        "C:\PROGRA~1\dotnet"
        "C:\PROGRA~1\Intel\TXE Components\DAL"
        "C:\PROGRA~1\Intel\TXE Components\IPT"
        "C:\PROGRA~1\Intel\TXE Components\TCS"
        "C:\PROGRA~1\Intel\WiFi\bin"
        "C:\PROGRA~1\Microsoft MPI\Bin\"
        "C:\PROGRA~1\Microsoft SQL Server\130\Tools\Binn\"
        "C:\PROGRA~1\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\"
        "C:\PROGRA~1\NVIDIA Corporation\Nsight Compute 2020.3.1\"
        "C:\PROGRA~1\NVIDIA Corporation\Nsight Compute 2019.5.0\"
        "C:\PROGRA~1\NVIDIA GPU Computing Toolkit\CUDA\v11.2\bin"
        "C:\PROGRA~1\NVIDIA GPU Computing Toolkit\CUDA\v11.2\libnvvp"
        "C:\PROGRA~1\NVIDIA GPU Computing Toolkit\CUDA\v11.2\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA GPU Computing Toolkit\CUDA\v10.2\bin"
        "C:\PROGRA~1\NVIDIA GPU Computing Toolkit\CUDA\v10.2\libnvvp"
        "C:\PROGRA~2\Common Files\Oracle\Java\javapath"
        "C:\PROGRA~2\Intel\TXE Components\DAL"
        "C:\PROGRA~2\Intel\TXE Components\IPT"
        "C:\PROGRA~2\Intel\TXE Components\TCS"
        "C:\PROGRA~2\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn\"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\Community\MSBuild\16.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\Preview\MSBuild\Current\Bin\Roslyn"
        "C:\PROGRA~2\NVIDIA Corporation\PhysX\Common"
        "C:\PROGRA~2\Windows Kits\8.1\Windows Performance Toolkit\"
    )

    $final_path = "$env:SystemRoot\system32"

    foreach ($path in $paths)
    {
        If (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PathsSys", "$final_path", "Machine")
}

# C:\Program Files\       --> C:\PROGRA~1\
# C:\Program Files (x86)\ --> C:\PROGRA~2\
# C:\ProgramData\         --> C:\PROGRA~3\
function Initialize-Paths-User
{
    $paths = @(
        "${env:USERPROFILE}\scoop\shims"
        "${env:GOPATH}\bin"
        "${env:M2_HOME}\bin"
        "${env:USERPROFILE}\go\bin"
        "${env:USERPROFILE}\.elan\bin"
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
        "C:\Go\bin"
        "C:\HashiCorp\Vagrant\bin"
        "C:\msys64"
        "C:\opscode\chefdk\bin"
        "C:\Strawberry\perl\bin"
        "C:\Strawberry\perl\site\bin"
        "C:\tools\Atlassian\atlassian-plugin-sdk-8.0.16\bin"
        "C:\tools\BCURRAN3"
        "C:\tools\CppDepend"
        "C:\tools\doublecmd"
        "C:\tools\emsdk"
        "C:\tools\fasm"
        "C:\tools\gnuplot\bin"
        "C:\tools\msys64"
        "C:\tools\ProccessHacker"
        "C:\tools\sonar-scanner-4.4.0.2170-windows\bin"
        "C:\tools\swig"
        "C:\tools\vcpkg"
        "C:\tools\vim\vim82"
        "C:\tools\wabt\1.0.20"
        "C:\tools\wsl\arch"
        "C:\tools\wsl\debian"
        "C:\tools\wsl\kali"
        "C:\tools\wsl\ubuntu"
    )

    $final_path = "${env:USERPROFILE}\AppData\Local\Microsoft\WindowsApps"

    foreach ($path in $paths)
    {
        If (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PATH", "$final_path", "User")
}

function Set-Env
{
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

    # Set-PowershellEnvironment

    Set-WorkEnv

    Reset-Environment
}

function Set-WorkEnv
{
    # If (Test-Path "$env:HOME\workspace\ormco\common\aligner-thirdparty")  {
    #     [Environment]::SetEnvironmentVariable("THIRDPARTY_LOCATION", "$env:HOME\workspace\ormco\common\aligner-thirdparty", "Machine")
    # }
    # If (Test-Path "$env:HOME\workspace\ormco\aligner\testdataaligner")  {
    #     [Environment]::SetEnvironmentVariable("TESTDATA_LOCATION", "$env:HOME\workspace\ormco\aligner\testdataaligner", "Machine")
    # }
}

# C:\Program Files\       --> C:\PROGRA~1\
# C:\Program Files (x86)\ --> C:\PROGRA~2\
# C:\ProgramData\         --> C:\PROGRA~3\
function Set-PowershellEnvironment
{
    $paths = @(
        # "C:\Program Files\PowerShell\7\Modules"
        "C:\Program Files\WindowsPowerShell\Modules"
        "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules"
        "C:\opscode\chefdk\modules"
        "C:\ProgramData\chocolatey\lib\Paket.PowerShell\tools"
        # "${env:USERPROFILE}\Documents\PowerShell\Modules"
        # "${env:USERPROFILE}\OneDrive\Documents\PowerShell\Modules"
        # "${env:USERPROFILE}\OneDrive\Documents\WindowsPowerShell\Modules"
        # "C:\Program Files\PowerShell\6\Modules"
        # "C:\Program Files\PowerShell\Modules"
    )

    $final_path = "C:\Program Files\PowerShell\7\Modules"

    foreach ($path in $paths)
    {
        If (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    Set-Item -Path Env:PSModulePath -Value "${final_path}"
    # [Environment]::SetEnvironmentVariable("PSModulePath", "$final_path", "Machine")
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value)
{
    Set-ItemProperty -Path "HKCU:\Environment" -Name $variable -Value $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Reload the $env object from the registry
function Reset-Environment
{
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
