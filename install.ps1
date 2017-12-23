#!/usr/bin/env powershell

$profileDir         = Split-Path -Parent $profile
$dotfilesProfileDir = Join-Path $PSScriptRoot "powershell"

"DEVELOPMENT" | Out-File ( Join-Path $PSScriptRoot "bash/var.env"    )
"COMPLEX"     | Out-File ( Join-Path $PSScriptRoot "bash/var.prompt" )

# Initial - Dirty SO Dirty
Remove-Item -Force -Confirm:$false -Recurse $profileDir
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bash"         )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bash_profile" )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bashrc"       )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bin"          )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gemrc"        )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gitconfig"    )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gitmessage"   )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".profile"      )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".tmux"         )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".tmux.conf"    )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".vim"          )
Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".vimrc"        )

cmd /c mklink /d $profileDir $dotfilesProfileDir
cmd /c mklink /d ( Join-Path $HOME ".bash"         ) ( Join-Path $PSScriptRoot "bash"         )
cmd /c mklink    ( Join-Path $HOME ".bash_profile" ) ( Join-Path $PSScriptRoot "bash_profile" )
cmd /c mklink    ( Join-Path $HOME ".profile"      ) ( Join-Path $PSScriptRoot "bash_profile" )
cmd /c mklink    ( Join-Path $HOME ".bin"          ) ( Join-Path $PSScriptRoot "bin-win"      )
cmd /c mklink    ( Join-Path $HOME ".bashrc"       ) ( Join-Path $PSScriptRoot "bashrc"       )
cmd /c mklink    ( Join-Path $HOME ".gemrc"        ) ( Join-Path $PSScriptRoot "gemrc"        )
cmd /c mklink    ( Join-Path $HOME ".gitconfig"    ) ( Join-Path $PSScriptRoot ".gitconfig"   )
cmd /c mklink    ( Join-Path $HOME ".gitmessage"   ) ( Join-Path $PSScriptRoot ".gitmessage"  )
cmd /c mklink /d ( Join-Path $HOME ".tmux"         ) ( Join-Path $PSScriptRoot "tmux"         )
cmd /c mklink    ( Join-Path $HOME ".tmux.conf"    ) ( Join-Path $PSScriptRoot "tmux.conf"    )
cmd /c mklink /d ( Join-Path $HOME ".vim"          ) ( Join-Path $PSScriptRoot "vim"          )
cmd /c mklink    ( Join-Path $HOME ".vimrc"        ) ( Join-Path $PSScriptRoot "vimrc-win"    )



#Write-Host "mklink $profileDir ./powershell"
#cmd /c mklink c:\path\to\symlink c:\target\file



# if (!(Verify-Elevated)) {
#   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
#   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
#   $newProcess.Verb = "runas";
#   [System.Diagnostics.Process]::Start($newProcess);

#   exit
# }

# Write-Warning "aaa"

# cmd /c mklink c:\path\to\symlink c:\target\file



# #!/usr/bin/env bash

# # Environment
# DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# # Script
# case $1 in
# 	# Cases for users that know what to do
# 	prod)
# 		echo "PRODUCTION"  > "$DOTFILES_DIR/bash/var.env"
# 		echo "COMPLEX"     > "$DOTFILES_DIR/bash/var.prompt"
# 		;;
# 	dev)
# 		echo "DEVELOPMENT" > "$DOTFILES_DIR/bash/var.env"
# 		echo "COMPLEX"     > "$DOTFILES_DIR/bash/var.prompt"
# 		;;
# 	*)
# 		#Interactive mode
# 		echo "=== Welcome to installation of DotFiles server version ==="
# 		echo "    Please be careful"
# 		echo "!!! Warninng: some of your current home files echo will be deleted !!!"
# 		read -r -n 1 -p "    Do you really want to install custom dot-files? (y/[a]): " AMSURE
# 		[ "$AMSURE" = "y" ] || exit
# 		echo "" 1>&2

# 		PS3="   Select the name of environment for this server: "
# 		ENVS=("PRODUCTION" "DEVELOPMENT" "TEST")
# 		select ENVRM in "${ENVS[@]}"; do
# 		echo "$ENVRM" > "$DOTFILES_DIR/bash/var.env"
# 		break
# 		done

# 		echo ""
# 		PS3="   Select complexity of bash prompt:"
# 		PRPTS=("COMPLEX" "SIMPLE")
# 		select PRPT in "${PRPTS[@]}"; do
# 		echo "$PRPT" > "$DOTFILES_DIR/bash/var.prompt"
# 		break
# 		done
# 		;;
# esac

# mkdir -p "$HOME/.local/bin"



# platform=`uname`
# case $platform in
# 	Linux )
# 		mkdir -p "$HOME/.config"
# 		rm -rf "$HOME/.Xresources"               2> /dev/null
# 		rm -rf "$HOME/.config/alacritty"         2> /dev/null

# 		ln -sf "$DOTFILES_DIR/bin-wsl"           "$HOME/.bin"
# 		ln -sf "$DOTFILES_DIR/Xresources"        "$HOME/.Xresources"
# 		ln -sf "$DOTFILES_DIR/config/alacritty"  "$HOME/.config/alacritty"
# 		;;
# 	Darwin )
# 		mkdir -p "$HOME/.config"
# 		rm -rf "$HOME/.config/alacritty"         2> /dev/null

# 		ln -sf "$DOTFILES_DIR/bin-mac"           "$HOME/.bin"
# 		ln -sf "$DOTFILES_DIR/config/alacritty"  "$HOME/.config/alacritty"
# 		;;
# 	MSYS_NT-10.0 )
# 		ln -sf "$DOTFILES_DIR/bin-win"           "$HOME/.bin"
# 		;;
# esac

# ln -sf "$DOTFILES_DIR/data/gruvbox/gruvbox-256-palette.sh" "$HOME/.bin/gruvbox-256-palette.sh"

# touch "$HOME/.localenv"
