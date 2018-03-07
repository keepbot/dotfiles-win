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
