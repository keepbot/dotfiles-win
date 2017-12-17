#!/usr/bin/env bash

# Environment
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Script
case $1 in
# Cases for users that know what to do
prod)
	echo "PRODUCTION"  > $DOTFILES_DIR/bash/var.env
	echo "COMPLEX"     > $DOTFILES_DIR/bash/var.prompt
	;;
dev)
	echo "DEVELOPMENT" > $DOTFILES_DIR/bash/var.env
	echo "COMPLEX"     > $DOTFILES_DIR/bash/var.prompt
	;;
*)
	#Interactive mode
	echo "=== Welcome to installation of DotFiles server version ==="
	echo "    Please be careful and read all instructions."
	echo ""
	echo "!!! Warninng: your current files: "
	echo "$HOME/.bash"
	echo "$HOME/.bash_profile"
  echo "$HOME/.profile"
	echo "$HOME/.bashrc"
	echo "$HOME/.bin"
	echo "$HOME/.fonts.conf"
	echo "$HOME/.gemrc"
	echo "$HOME/.gitconfig"
	echo "$HOME/.gitmessage"
	echo "$HOME/.tmux"
	echo "$HOME/.tmux.conf"
	echo "$HOME/.vim"
	echo "$HOME/.vimrc"
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

mkdir -p $HOME/.local/bin

rm -rf $HOME/.bash                         2> /dev/null
rm -rf $HOME/.bash_profile                 2> /dev/null
rm -rf $HOME/.bashrc                       2> /dev/null
rm -rf $HOME/.bin                          2> /dev/null
rm -rf $HOME/.gemrc                        2> /dev/null
rm -rf $HOME/.gitconfig                    2> /dev/null
rm -rf $HOME/.gitmessage                   2> /dev/null
rm -rf $HOME/.profile                      2> /dev/null
rm -rf $HOME/.tmux                         2> /dev/null
rm -rf $HOME/.tmux.conf                    2> /dev/null
rm -rf $HOME/.vim                          2> /dev/null
rm -rf $HOME/.vimrc                        2> /dev/null

ln -sf $DOTFILES_DIR/bash              $HOME/.bash
ln -sf $DOTFILES_DIR/bash_profile      $HOME/.bash_profile
ln -sf $DOTFILES_DIR/bash_profile      $HOME/.profile
ln -sf $DOTFILES_DIR/bashrc            $HOME/.bashrc
ln -sf $DOTFILES_DIR/bin-wsl           $HOME/.bin
ln -sf $DOTFILES_DIR/gemrc             $HOME/.gemrc
ln -sf $DOTFILES_DIR/.gitconfig        $HOME/.gitconfig
ln -sf $DOTFILES_DIR/.gitmessage       $HOME/.gitmessage
ln -sf $DOTFILES_DIR/tmux              $HOME/.tmux
ln -sf $DOTFILES_DIR/tmux.conf         $HOME/.tmux.conf
ln -sf $DOTFILES_DIR/vim               $HOME/.vim
ln -sf $DOTFILES_DIR/vimrc             $HOME/.vimrc

touch $HOME/.localenv

