#!/usr/bin/env powershell

# Make vim the default editor
$Env:EDITOR = "vim --nofork"
$Env:GIT_EDITOR = $Env:EDITOR

# Language
$Env:LANG = "en"
