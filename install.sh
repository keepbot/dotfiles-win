#!/usr/bin/env bash

# Environment
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Script
case $1 in
	# Cases for users that know what to do
	prod)
		echo "PRODUCTION"  > "$DOTFILES_DIR/bash/var.env"
		echo "COMPLEX"     > "$DOTFILES_DIR/bash/var.prompt"
		;;
	dev)
		echo "DEVELOPMENT" > "$DOTFILES_DIR/bash/var.env"
		echo "COMPLEX"     > "$DOTFILES_DIR/bash/var.prompt"
		;;
	*)
		#Interactive mode
		echo "=== Welcome to installation of DotFiles server version ==="
		echo "    Please be careful"
		echo "!!! Warninng: some of your current home files echo will be deleted !!!"
		read -r -n 1 -p "    Do you really want to install custom dot-files? (y/[a]): " AMSURE
		[ "$AMSURE" = "y" ] || exit
		echo "" 1>&2

		PS3="   Select the name of environment for this server: "
		ENVS=("PRODUCTION" "DEVELOPMENT" "TEST")
		select ENVRM in "${ENVS[@]}"; do
		echo "$ENVRM" > "$DOTFILES_DIR/bash/var.env"
		break
		done

		echo ""
		PS3="   Select complexity of bash prompt:"
		PRPTS=("COMPLEX" "SIMPLE")
		select PRPT in "${PRPTS[@]}"; do
		echo "$PRPT" > "$DOTFILES_DIR/bash/var.prompt"
		break
		done
		;;
esac

mkdir -p "$HOME/.local/bin"

rm -rf "$HOME/.bash"                        2> /dev/null
rm -rf "$HOME/.bash_profile"                2> /dev/null
rm -rf "$HOME/.bashrc"                      2> /dev/null
rm -rf "$HOME/.bin"                         2> /dev/null
rm -rf "$HOME/.gemrc"                       2> /dev/null
rm -rf "$HOME/.git.d"                       2> /dev/null
rm -rf "$HOME/.gitconfig"                   2> /dev/null
rm -rf "$HOME/.gitmessage"                  2> /dev/null
rm -rf "$HOME/.profile"                     2> /dev/null
rm -rf "$HOME/.stack/config.yaml"           2> /dev/null
rm -rf "$HOME/.tmux"                        2> /dev/null
rm -rf "$HOME/.tmux.conf"                   2> /dev/null
rm -rf "$HOME/.vim"                         2> /dev/null
rm -rf "$HOME/.vimrc"                       2> /dev/null

ln -sf "$DOTFILES_DIR/bash"                 "$HOME/.bash"
ln -sf "$DOTFILES_DIR/bash_profile"         "$HOME/.bash_profile"
ln -sf "$DOTFILES_DIR/bash_profile"         "$HOME/.profile"
ln -sf "$DOTFILES_DIR/bashrc"               "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/gemrc"                "$HOME/.gemrc"
ln -sf "$DOTFILES_DIR/git.d"                "$HOME/.git.d"
ln -sf "$DOTFILES_DIR/.gitmessage"          "$HOME/.gitmessage"
if [ ! -d "$HOME/.stack" ]; then
	mkdir "$HOME/.stack"
fi
ln -sf "$DOTFILES_DIR/stack/config.yaml"    "$HOME/.stack/config.yaml"
ln -sf "$DOTFILES_DIR/tmux"                 "$HOME/.tmux"
ln -sf "$DOTFILES_DIR/tmux.conf"            "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/vim"                  "$HOME/.vim"
ln -sf "$DOTFILES_DIR/vimrc"                "$HOME/.vimrc"

if [ -f /proc/version_signature ] ; then
    kernel=$(cat /proc/version_signature)
    kernelWSL="Microsoft"
    if [[ "${kernel}" =~ "${kernelWSL}" ]]; then
    	sudo rm -rf "/etc/wsl.conf"               2> /dev/null
    	sudo ln -sf "$DOTFILES_DIR/data/wsl.conf" "/etc/wsl.conf"
    fi
fi
ln -sf "$DOTFILES_DIR/bin-nix"              "$HOME/.bin"

platform=`uname`
case $platform in
	Linux )
		mkdir -p "$HOME/.config"
		rm -rf "$HOME/.Xresources"               2> /dev/null
		rm -rf "$HOME/.config/alacritty"         2> /dev/null

		ln -sf "$DOTFILES_DIR/.gitconfig-nix"    "$HOME/.gitconfig"
		ln -sf "$DOTFILES_DIR/Xresources"        "$HOME/.Xresources"
		ln -sf "$DOTFILES_DIR/config/alacritty"  "$HOME/.config/alacritty"
		;;
	Darwin )
		mkdir -p "$HOME/.config"
		rm -rf "$HOME/.config/alacritty"         2> /dev/null

		ln -sf "$DOTFILES_DIR/.gitconfig-nix"    "$HOME/.gitconfig"
		ln -sf "$DOTFILES_DIR/config/alacritty"  "$HOME/.config/alacritty"
		;;
	MSYS_NT-10.0 )
		ln -sf "$DOTFILES_DIR/.gitconfig-win"    "$HOME/.gitconfig"
		ln -sf "$DOTFILES_DIR/bin-win"           "$HOME/.bin"
		;;
esac

touch "$HOME/.localenv"
