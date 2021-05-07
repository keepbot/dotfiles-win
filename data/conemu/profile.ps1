# Init Script for PowerShell
# Created as part of cmder project

# !!! THIS FILE IS OVERWRITTEN WHEN CMDER IS UPDATED
# !!! Use "%CMDER_ROOT%\config\user-profile.ps1" to add your own startup commands

# Compatibility with PS major versions <= 2
#if (!$PSScriptRoot)
# {
#    $PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path
#}

# We do this for Powershell as Admin Sessions because CMDER_ROOT is not beng set.
if (! $ENV:CMDER_ROOT )
{
    if ( $ENV:ConEmuDir )
    {
        $ENV:CMDER_ROOT = resolve-path( $ENV:ConEmuDir + "\..\.." )
    }
    else
    {
        $ENV:CMDER_ROOT = resolve-path( $PSScriptRoot + "\.." )
    }
}

# Remove trailing '\'
$ENV:CMDER_ROOT = (($ENV:CMDER_ROOT).trimend("\"))

function checkGit($Path)
{
    if (Test-Path -Path (Join-Path $Path '.git'))
    {
        # $gitLoaded = Import-Git $gitLoaded
        Write-VcsStatus
        return
    }
    $SplitPath = split-path $path
    if ($SplitPath)
    {
        checkGit($SplitPath)
    }
}

# Move to the wanted location
# This is either a env variable set by the user or the result of
# cmder.exe setting this variable due to a commandline argument or a "cmder here"
if ( $ENV:CMDER_START )
{
    Set-Location -Path "$ENV:CMDER_START"
}

if (Get-Module PSReadline -ErrorAction "SilentlyContinue")
{
    Set-PSReadlineOption -ExtraPromptLineCount 1
}

# Enhance Path
$env:Path = "$Env:CMDER_ROOT\bin;$env:Path;$Env:CMDER_ROOT"

#
# Prompt Section
#   Users should modify their user-profile.ps1 as it will be safe from updates.
#

# Pre assign the hooks so the first run of cmder gets a working prompt.
[ScriptBlock]$PrePrompt = {}
[ScriptBlock]$PostPrompt = {}
[ScriptBlock]$CmderPrompt = {
    $Host.UI.RawUI.ForegroundColor = "White"
    Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    checkGit($pwd.ProviderPath)
}

<#
This scriptblock runs every time the prompt is returned.
Explicitly use functions from MS namespace to protect from being overridden in the user session.
Custom prompt functions are loaded in as constants to get the same behaviour
#>
[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    Microsoft.PowerShell.Utility\Write-Host "[$realLASTEXITCODE] " -NoNewLine -ForegroundColor "Yellow"
    $host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
    PrePrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    CmderPrompt
    Microsoft.PowerShell.Utility\Write-Host "`nλ " -NoNewLine -ForegroundColor "DarkGray"
    PostPrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

Set-Item -Path function:\PrePrompt   -Value $PrePrompt
Set-Item -Path function:\CmderPrompt -Value $CmderPrompt
Set-Item -Path function:\PostPrompt  -Value $PostPrompt
Set-Item -Path function:\prompt  -Value $Prompt
