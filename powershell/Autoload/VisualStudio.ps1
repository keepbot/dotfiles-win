#!/usr/env/pwsh
function VSToolArchx64 {
    [CmdletBinding()]

    param (
        [switch]$On,
        [switch]$Off
    )
    if ($On) {
        Set-Item -Path Env:PreferredToolArchitecture -Value "x64"
        Write-Host "Preferred Tool Architecture for MSBuild is set to x64" -ForegroundColor Yellow
    } elseif ($Off) {
        Set-Item -Path Env:PreferredToolArchitecture -Value "x86"
        Remove-Item -Path Env:PreferredToolArchitecture
        Write-Host "Preferred Tool Architecture for MSBuild is set to x86" -ForegroundColor Yellow
    } else {
        if ($Env:PreferredToolArchitecture -eq "x64") {
            Write-Host "Preferred Tool Architecture for MSBuild is set to x64" -ForegroundColor Yellow
        } else {
            Write-Host "Preferred Tool Architecture for MSBuild is set to x86" -ForegroundColor Yellow
        }
    }
}

function Find-VC {
    $VS_Community_2017      = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community'
    $VS_BuildTools_2017     = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools'
    $VS_Professional_2017   = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional'
    $VS_Enterprise_2017     = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise'
    $VS_Preview_2019        = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview'
    $VS_Community_2019      = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community'
    $VS_BuildTools_2019     = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools'
    $VS_Professional_2019   = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional'
    $VS_Enterprise_2019     = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise'

    # if (Test-Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\')
    if (Test-Path "$VS_Community_2017\VC\Tools\MSVC\") {
        $CommunityVersions2017 = $((Get-ChildItem "$VS_Community_2017\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_BuildTools_2017\VC\Tools\MSVC\") {
        $BuildToolsVersions2017 = $((Get-ChildItem "$VS_BuildTools_2017\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_Professional_2017\VC\Tools\MSVC\") {
        $ProfessionalVersions2017 = $((Get-ChildItem "$VS_Professional_2017\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_Enterprise_2017\VC\Tools\MSVC\") {
        $EnterpriseVersions2017 = $((Get-ChildItem "$VS_Enterprise_2017\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_Preview_2019\VC\Tools\MSVC\") {
        $PreviewVersions2019 = $((Get-ChildItem "$VS_Preview_2019\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_Community_2019\VC\Tools\MSVC\") {
        $CommunityVersions2019 = $((Get-ChildItem "$VS_Community_2019\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_BuildTools_2019\VC\Tools\MSVC\") {
        $BuildToolsVersions2019 = $((Get-ChildItem "$VS_BuildTools_2019\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_Professional_2019\VC\Tools\MSVC\") {
        $ProfessionalVersions2019 = $((Get-ChildItem "$VS_Professional_2019\VC\Tools\MSVC\").Name)
    }
    if (Test-Path "$VS_Enterprise_2019\VC\Tools\MSVC\") {
        $EnterpriseVersions2019 = $((Get-ChildItem "$VS_Enterprise_2019\VC\Tools\MSVC\").Name)
    }
    Write-Host "List of VC versions on this PC:"
    if ($CommunityVersions2017) {
        foreach($v in $CommunityVersions2017) {Write-Host " -" $v " (VS Community 2017)"}
    }
    if ($BuildToolsVersions2017) {
        foreach($v in $BuildToolsVersions2017) {Write-Host " -" $v " (VS BuildTools 2017)"}
    }
    if ($ProfessionalVersions2017) {
        foreach($v in $ProfessionalVersions2017) {Write-Host " -" $v " (VS Professional 2017)"}
    }
    if ($EnterpriseVersions2017) {
        foreach($v in $EnterpriseVersions2017) {Write-Host " -" $v " (VS Enterprise 2017)"}
    }
    if ($PreviewVersions2019) {
        foreach($v in $PreviewVersions2019) {Write-Host " -" $v " (VS Preview 2019)"}
    }
    if ($CommunityVersions2019) {
        foreach($v in $CommunityVersions2019) {Write-Host " -" $v " (VS Community 2019)"}
    }
    if ($BuildToolsVersions2019) {
        foreach($v in $BuildToolsVersions2019) {Write-Host " -" $v " (VS BuildTools 2019)"}
    }
    if ($ProfessionalVersions2019) {
        foreach($v in $ProfessionalVersions2019) {Write-Host " -" $v " (VS Professional 2019)"}
    }
    if ($EnterpriseVersions2019) {
        foreach($v in $EnterpriseVersions2019) {Write-Host " -" $v " (VS Enterprise 2019)"}
    }
}

function Set-VC {
    $tools = @(
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise'
    )

    $VCVersions = @()
    foreach($tool in $tools) {
        if (Test-Path "$tool\VC\Tools\MSVC\") {
            foreach($ver in $(Get-ChildItem "$tool\VC\Tools\MSVC").Name ) {
                $VCVersions += $(Get-ChildItem "$tool\VC\Tools\MSVC\$ver\bin\Hostx86").FullName
                $VCVersions += $(Get-ChildItem "$tool\VC\Tools\MSVC\$ver\bin\Hostx64").FullName
            }
        }
    }

    $ChoosenVCVersion = Select-From-List $VCVersions "Visual Compiler Version"
    [Environment]::SetEnvironmentVariable("VC_PATH", $ChoosenVCVersion, "Machine")
    Set-Env
}

function Set-VC-IDE {
    $ideList = @(
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE'
    )

    $VCIDEVersions = @()
    foreach($ide in $ideList) {
        if (Test-Path "$ide") {
            $VCIDEVersions += $ide
        }
    }

    $ChoosenVCIDEVersion = Select-From-List $VCIDEVersions "Visual Studio IDE Version: "
    [Environment]::SetEnvironmentVariable("VC_IDE", $ChoosenVCIDEVersion, "Machine")
    Set-Env
}

function Clear-VC {
    [Environment]::SetEnvironmentVariable("VC_IDE", $null, "Machine")
    [Environment]::SetEnvironmentVariable("VC_PATH", $null, "Machine")
    if ($env:VC_PATH) {
        Remove-Item Env:VC_IDE
        Remove-Item Env:VC_PATH
    }
    Set-Env
}

function Get-VS {
    $ideList = @(
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview\Common7\IDE\devenv.exe'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Preview\Common7\IDE\devenv.exe'

    )
    foreach($ide in $ideList) {
        if (Test-Path "$ide") {
            return $ide
        }
    }
}

function Set-VC-Vars-All {
    <#
    .SYNOPSIS
        Script to initialize all VC Variables.
    .DESCRIPTION
        Script to initialize all VC Variables.
    .PARAMETER Arch
        Architecture.
    .PARAMETER SDK
        Version of Windows SDK.
    .PARAMETER Platform
        Microsoft platform None, store or uwp.
    .PARAMETER VC
        Version Visual Studio.
    .PARAMETER Spectre
        Use for VS 2017 libraries with spectre mitigations.
    .PARAMETER Help
        Show help message.
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Version:        1.0
        Author:         Dmitriy Ivanov
        Creation Date:  2019-01-14
    .EXAMPLE
        VC-Vars-All x86_amd64
        VC-Vars-All x86_amd64 10.0.10240.0
        VC-Vars-All x86_arm uwp 10.0.10240.0
        VC-Vars-All x86_arm onecore 10.0.10240.0 -vcvars_ver=14.0
        VC-Vars-All x64 8.1
        VC-Vars-All x64 store 8.1
    #>
    [CmdletBinding()]

    param (
        [ValidateNotNullOrEmpty()]
        [string]$Arch   = "x64",
        [string]$SDK,
        [string]$Platform,
        [string]$VC,
        [switch]$Spectre,
        [switch]$Help
    )

    if ($Help) {
        Write-Host '
        Syntax:
            VC-Vars-All [-Arch <string>] [-SDK <string>] [-Platform <string>] [-VC <string>] [-Spectre] [-Help]
        where :
            [Arch]    : x86 | amd64 | x86_amd64 | x86_arm | x86_arm64 | amd64_x86 | amd64_arm | amd64_arm64
            [SDK]     : full Windows 10 SDK number (e.g. 10.0.10240.0) or "8.1" to use the Windows 8.1 SDK.
            [Platform]: {empty} | store | uwp
            [VC]      : {none} for default VS 2017 VC++ compiler toolset |
                        "14.0" for VC++ 2015 Compiler Toolset |
                        "14.1x" for the latest 14.1x.yyyyy toolset installed (e.g. "14.11") |
                        "14.1x.yyyyy" for a specific full version number (e.g. 14.11.25503)
            [Spectre] : Flag to set -vcvars_spectre_libs=spectre
            [Help]    : Flag to show this help message, all other parameters will be ignored
        '
        return
    }

    $VC_Distros = @(
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional'
        'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Preview'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional'
        'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise'
    )

    $cmd_string = "cmd /c "

    foreach($distro in $VC_Distros) {
        $vars_file = $distro + "\VC\Auxiliary\Build\vcvarsall.bat"
        if (Test-Path "$vars_file") {
            $cmd_string += "`'`"" + $vars_file + "`" " + $Arch
            break
        }
    }

    If ($Arch -eq "x64" -Or $Arch -eq "x64_x86"){
        Set-Item -Path Env:PreferredToolArchitecture -Value "x64"
    }

    if ($Platform) {
        $cmd_string += " " + $Platform
    }

    if ($SDK) {
        $cmd_string += " " + $SDK
    }

    if ($VC) {
        $cmd_string += " -vcvars_ver=" + $VC
    }

    if ($Spectre) {
        $cmd_string += " -vcvars_spectre_libs=spectre"
    }

    $cmd_string += "` & set'"

    Write-Host "$cmd_string"

    Invoke-Expression $cmd_string |
    ForEach-Object {
        if ($_ -match "=") {
            $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
        }
    }
}

${function:vs}              = { & $(Get-VS) @args }
${function:vssafe}          = { vs /SafeMode @args }
${function:vsix}            = { Set-VC-Vars-All; VSIXInstaller.exe @args }
# color picker: 11559f0c-c44f-4a26-98e7-f5015f07d691
${function:vsix_remove}     = { Set-VC-Vars-All; VSIXInstaller.exe /u:@args }

