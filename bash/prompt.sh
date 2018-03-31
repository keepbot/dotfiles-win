#!/usr/bin/env bash

function __git_prompt {
	# preserve exit status
	local exit=$?
	local PROMPT="`cat ~/.bash/var.prompt`"
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_STATESEPARATOR=" "
	# GIT_PS1_SHOWUNTRACKEDFILES=1
	# GIT_PS1_SHOWSTASHSTATE=1
	# GIT_PS1_SHOWCOLORHINTS=1
	[ `git config user.pair` ] && GIT_PS1_PAIR="`git config user.pair`@"

	if [ ${PROMPT} == "COMPLEX" ]; then
		__git_ps1 "[ Git: $GIT_PS1_PAIR%s ]"
	else
		__git_ps1 "$GIT_PS1_PAIR%s" | sed 's/ \([+*%]\{1,\}\)$/\1/'
	fi
	return $exit
}

function prompt_rvm {
	# preserve exit status
	local exit=$?
	local PROMPT="`cat ~/.bash/var.prompt`"
	if [ `command -v rvm-prompt` ]; then
		rbv=$(rvm-prompt)
	fi
	[[ -z ${rbv} ]] && exit
	rbv=${rbv#ruby-}
	[[ $rbv == *"@"* ]] || rbv="${rbv}@default"
	if [ ${PROMPT} == "COMPLEX" ]; then
		echo "[ Ruby: $rbv ]"
	else
		echo "$rbv"
	fi
	return $exit
}

bash_prompt() {
	# Colors:
	local K="\[\033[0;30m\]"    # black
	local R="\[\033[0;31m\]"    # red
	local G="\[\033[0;32m\]"    # green
	local Y="\[\033[0;33m\]"    # yellow
	local B="\[\033[0;34m\]"    # blue
	local M="\[\033[0;35m\]"    # magenta
	local C="\[\033[0;36m\]"    # cyan
	local W="\[\033[0;37m\]"    # white
	local BK="\[\033[1;30m\]"   # bolded black
	local BR="\[\033[1;31m\]"   # bolded red
	local BG="\[\033[1;32m\]"   # bolded green
	local BY="\[\033[1;33m\]"   # bolded yellow
	local BB="\[\033[1;34m\]"   # bolded blue
	local BM="\[\033[1;35m\]"   # bolded magenta
	local BC="\[\033[1;36m\]"   # bolded cyan
	local BW="\[\033[1;37m\]"   # bolded white
	local ZZ="\[\033[0m\]"      # Reset

	local ENVRM="`cat ~/.bash/var.env`"
	local PROMPT="`cat ~/.bash/var.prompt`"

	# Environment:
	if [ -n "$SSH_CLIENT" ]; then
		local SSHIP=$(echo $SSH_CLIENT | awk '{print $1}')
		local SSHPRPT="SSH from $SSHIP"
	else
		local SSHPRPT=""
	fi

	case $PROMPT in
		COMPLEX)
			if [ $ENVRM == "PRODUCTION" ]; then
				PS1="${R}[${BY}\${?}${R}] [ ${B}\w ${R}] ${C}\$(__git_prompt) ${M}\$(prompt_rvm) ${C}$SSHPRPT$BC \n$R\t \u (at) \H ${ZZ}\$ "
			else
				PS1="${G}[${BY}\${?}${G}] [ ${B}\w ${G}] ${C}\$(__git_prompt) ${M}\$(prompt_rvm) ${C}$SSHPRPT$BC \n$G\t \u (at) \H ${ZZ}\$ "
			fi
			;;
		SIMPLE)
			if [ $ENVRM == "PRODUCTION" ]; then
				PS1="${R}[${BY}\${?}${R}] ${R}\u (at) \h${W}:${B}\w${C}\$(__git_prompt) ${M}\$(prompt_rvm) ${ZZ}\$ "
			else
				PS1="${G}[${BY}\${?}${G}] ${G}\u (at) \h${W}:${B}\w${C}\$(__git_prompt) ${M}\$(prompt_rvm) ${ZZ}\$ "
			fi
			;;
  esac
}

bash_prompt
unset bash_prompt
