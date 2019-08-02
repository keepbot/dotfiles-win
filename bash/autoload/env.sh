#!/usr/bin/env bash
umask 022

export EDITOR='vim'
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
#export TERM='xterm-256color'

# Pow shouldn't hide errors in non-ASCII apps:
# https://github.com/37signals/pow/issues/268
# Also fixes UTF-8 display in e.g. git log.
export LANG=en_US.UTF-8
export LC_ALL=$LANG
#export LC_ALL=C
export LC_CTYPE=$LANG
#export LC_CTYPE=C
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=00;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:ow=00;32:'
export GPG_TTY=$(tty)
export XZ_OPT="--threads=0"
export LIBGL_ALWAYS_INDIRECT=1
# Set PATHs
platform=`uname`
case $platform in
    Linux )
        # Local
        [[ -d $HOME/.bin ]]                         && export PATH=$HOME/.bin
        [[ -d $HOME/.local/bin ]]                   && export PATH=$PATH:$HOME/.local/bin
        # Root binaries
        [[ -d /sbin ]]                              && export PATH=$PATH:/sbin
        [[ -d /usr/sbin ]]                          && export PATH=$PATH:/usr/sbin
        [[ -d /usr/local/sbin ]]                    && export PATH=$PATH:/usr/local/sbin
        [[ -d /opt/local/sbin ]]                    && export PATH=$PATH:/opt/local/sbin
        # User's
        [[ -d /bin ]]                               && export PATH=$PATH:/bin
        [[ -d /usr/bin ]]                           && export PATH=$PATH:/usr/bin
        [[ -d /usr/local/bin ]]                     && export PATH=$PATH:/usr/local/bin
        [[ -d /opt/local/bin ]]                     && export PATH=$PATH:/opt/local/bin
        [[ -d /opt/bin ]]                           && export PATH=$PATH:/opt/bin
        # Ubuntu games
        [[ -d /usr/games ]]                         && export PATH=$PATH:/usr/games
        [[ -d /usr/local/games ]]                   && export PATH=$PATH:/usr/local/games
        # LLVM
        [[ -d /usr/lib/llvm/6/bin ]]                && export PATH=$PATH:/usr/lib/llvm/6/bin
        # Ruby
        [[ -s "$HOME/.rvm/scripts/rvm" ]]           && source "$HOME/.rvm/scripts/rvm"
        [[ -d "$HOME/.rvm/bin" ]]                   && export PATH=$PATH:$HOME/.rvm/bin
        # [[ -d "$HOME/.rvm/rubies/ruby-2.6.1" ]]     && rvm use 2.6.1
        # Rust
        [[ -d "$HOME/.cargo/bin" ]]                 && export PATH=$PATH:$HOME/.cargo/bin
        # Yarn
        [[ -d "$HOME/.yarn/bin" ]]                  && export PATH=$PATH:$HOME/.yarn/bin
        # Android
        [[ -d "$HOME/Android/Sdk/platform-tools" ]] && export PATH=$PATH:$HOME/Android/Sdk/platform-tools
        # Python
        # [[ -f $HOME/.bash/venv.sh ]]                && source ~/.bash/venv.sh
        ;;
    Darwin )
        [[ -d /usr/local/bin ]]                     && export PATH=/usr/local/bin
        [[ -d /usr/local/sbin ]]                    && export PATH=$PATH:/usr/local/sbin
        [[ -d /usr/local/opt/python3/bin ]]         && export PATH=$PATH:/usr/local/opt/python3/bin
        [[ -d $HOME/Library/Python/3.6/bin ]]       && export PATH=$PATH:Library/Python/3.6/bin
        [[ -d /usr/local/opt/python2/bin ]]         && export PATH=$PATH:/usr/local/opt/python2/bin
        [[ -d $HOME/Library/Python/2.7/bin ]]       && export PATH=$PATH:Library/Python/2.7/bin
        [[ -d /usr/bin ]]                           && export PATH=$PATH:/usr/bin
        [[ -d /bin ]]                               && export PATH=$PATH:/bin
        [[ -d /usr/sbin ]]                          && export PATH=$PATH:/usr/sbin
        [[ -d /sbin ]]                              && export PATH=$PATH:/sbin
        [[ -d $HOME/.bin ]]                         && export PATH=$PATH:$HOME/.bin
        [[ -d $HOME/.local/bin ]]                   && export PATH=$PATH:$HOME/.local/bin
        # Ruby
        [[ -s "$HOME/.rvm/scripts/rvm" ]]           && source "$HOME/.rvm/scripts/rvm"
        # VS Code
        [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && \
            export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        [[ -f "/usr/libexec/java_home" ]]           && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
        
        # Work
        [[ -d $HOME/thirdparty ]]                   && export THIRDPARTY_LOCATION=$HOME/thirdparty
        [[ -d $HOME/testdata ]]                     && export TESTDATA_LOCATION=$HOME/testdata

        ;;
    MSYS_NT-10.0 )
        [[ -d $HOME/.bin ]]                         && export PATH=$HOME/.bin:$PATH
        echo
        ;;
esac

[[ -f $HOME/.localenv ]]                            && source ~/.localenv

# Finout linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    export OS_DISTRIBUTION=$NAME
elif type lsb_release >/dev/null 2>&1; then
    export OS_DISTRIBUTION=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    export OS_DISTRIBUTION=$DISTRIB_ID
else
    export OS_DISTRIBUTION=$(uname -s)
fi

list-paths() {
    for path in $(echo $PATH | tr ":" "\n"); do
        echo $path
    done
}
