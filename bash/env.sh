export EDITOR='vim'
#export OCTOPRESS_EDITOR='vim +'  # Go to last line.
# No duplicates in history.
export HISTCONTROL=ignoredups
# Big history
export HISTSIZE=1000000
export HISTFILESIZE=1000000
PROMPT_COMMAND="history -a"

# Append to the history file, don't overwrite it
shopt -s histappend
# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# Colors in Vim and TMUX. Do not set this variables if you not shure why.
# https://wiki.archlinux.org/index.php/Home_and_End_keys_inot_working
#export TERM='screen-256color'
export TERM='xterm-256color'

# Pow shouldn't hide errors in non-ASCII apps:
# https://github.com/37signals/pow/issues/268
# Also fixes UTF-8 display in e.g. git log.
export LANG=en_US.UTF-8
export LC_ALL=$LANG
#export LC_ALL=C
export LC_CTYPE=$LANG
#export LC_CTYPE=C
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

export XZ_OPT="--threads=0"
# export SHLVL=1

# Set PATHs
[[ -d $HOME/.local/bin ]]         			&& export PATH=$HOME/.local/bin:$PATH
[[ -d $HOME/bin ]]         					    && export PATH=$HOME/bin:$PATH
# Ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] 			&& source "$HOME/.rvm/scripts/rvm"
[[ -d "$HOME/.rvm/bin" ]]         			&& export PATH=$HOME/.rvm/bin:$PATH
# Rust
[[ -d "$HOME/.cargo/bin" ]]       			&& export PATH=$PATH:$HOME/.cargo/bin
# Yarn
[[ -d "$HOME/.yarn/bin" ]]        			&& export PATH=$PATH:$HOME/.yarn/bin
# Android
[[ -d "$HOME/Android/Sdk/platform-tools" ]]	&& export PATH=$PATH:$HOME/Android/Sdk/platform-tools


umask 022

