#!/usr/bin/env bash

# Environment
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Script
case $1 in
# Cases for users that know what to do
prod)
	echo "PRODUCTION" > $DOTFILES_DIR/bash/var.env
	echo "COMPLEX" > $DOTFILES_DIR/bash/var.prompt
	;;
dev)
	echo "DEVELOPMENT" > $DOTFILES_DIR/bash/var.env
	echo "COMPLEX" > $DOTFILES_DIR/bash/var.prompt
	;;
*)
	#Interactive mode
	echo "=== Welcome to installation of DotFiles server version ==="
	echo "    Please be careful and read all instructions."
	echo ""
	echo "!!! Warninng: your current files: "
	echo "~/.bash"
	echo "~/.bash_profile"
	echo "~/.bashrc"
	echo "~/.bin"
	echo "~/.data"
	echo "~/.fonts.conf"
	echo "~/.gemrc"
	echo "~/.gitconfig"
	echo "~/.gitmessage"
	echo "~/.tmux"
	echo "~/.tmux.conf"
	echo "~/.vim"	
	echo "~/.vimrc"
	echo "will be deleted !!!"
	read -n 1 -p "    Do you really want to install custom dot-files? (y/[a]): " AMSURE
	[ "$AMSURE" = "y" ] || exit
	echo "" 1>&2

	PS3="   Select the name of environment for this server: "
	ENVS=("PRODUCTION" "DEVELOPMENT" "TEST")
	select ENVRM in "${ENVS[@]}"; do
	echo $ENVRM > $DOTFILES_DIR/bash/var.env
	break
	done

	echo ""
	PS3="   Select complexity of bash prompt:"
	PRPTS=("COMPLEX" "SIMPLE")
	select PRPT in "${PRPTS[@]}"; do
	echo $PRPT > $DOTFILES_DIR/bash/var.prompt
	break
	done
	;;
esac

/bin/rm -rf ~/.bash               2> /dev/null
/bin/rm -rf ~/.bash_profile       2> /dev/null
/bin/rm -rf ~/.bashrc             2> /dev/null
/bin/rm -rf ~/.bin                2> /dev/null
/bin/rm -rf ~/.data               2> /dev/null
/bin/rm -rf ~/.gemrc              2> /dev/null
/bin/rm -rf ~/.gitconfig          2> /dev/null
/bin/rm -rf ~/.gitmessage         2> /dev/null
/bin/rm -rf ~/.tmux               2> /dev/null
/bin/rm -rf ~/.tmux.conf          2> /dev/null
/bin/rm -rf ~/.vim                2> /dev/null
/bin/rm -rf ~/.vimrc              2> /dev/null

/bin/ln -sf $DOTFILES_DIR/bash              ~/.bash
/bin/ln -sf $DOTFILES_DIR/bash_profile      ~/.bash_profile
/bin/ln -sf $DOTFILES_DIR/bashrc            ~/.bashrc
/bin/ln -sf $DOTFILES_DIR/bin               ~/.bin
/bin/ln -sf $DOTFILES_DIR/data              ~/.data
/bin/ln -sf $DOTFILES_DIR/gemrc             ~/.gemrc
/bin/ln -sf $DOTFILES_DIR/.gitconfig        ~/.gitconfig
/bin/ln -sf $DOTFILES_DIR/.gitmessage       ~/.gitmessage
/bin/ln -sf $DOTFILES_DIR/tmux              ~/.tmux
/bin/ln -sf $DOTFILES_DIR/tmux.conf         ~/.tmux.conf
/bin/ln -sf $DOTFILES_DIR/vim               ~/.vim
/bin/ln -sf $DOTFILES_DIR/vimrc             ~/.vimrc

touch ~/.localenv

