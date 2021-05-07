#!/usr/bin/env bash

function __git_prompt
{
    # preserve exit status
    local exit=$?
    local PROMPT="`cat ~/.bash/var.prompt`"

    # Colors:
    local  K="\033[0;30m"   # black
    local  R="\033[0;31m"   # red
    local  G="\033[0;32m"   # green
    local  Y="\033[0;33m"   # yellow
    local  B="\033[0;34m"   # blue
    local  M="\033[0;35m"   # magenta
    local  C="\033[0;36m"   # cyan
    local  W="\033[0;37m"   # white
    local GR="\033[0;090m"  # gray
    local BK="\033[1;30m"   # bolded black
    local BR="\033[1;31m"   # bolded red
    local BG="\033[1;32m"   # bolded green
    local BY="\033[1;33m"   # bolded yellow
    local BB="\033[1;34m"   # bolded blue
    local BM="\033[1;35m"   # bolded magenta
    local BC="\033[1;36m"   # bolded cyan
    local BW="\033[1;37m"   # bolded white
    local ZZ="\033[0m"      # Reset

    if [ ${PROMPT} == "COMPLEX" ]
    then
        # Classic Git-Prompt
        # GIT_PS1_SHOWDIRTYSTATE=1
        # GIT_PS1_STATESEPARATOR=""
        # GIT_PS1_SHOWUNTRACKEDFILES=1
        # GIT_PS1_SHOWSTASHSTATE=1
        # GIT_PS1_SHOWCOLORHINTS=1
        # [ `git config user.pair` ] && GIT_PS1_PAIR="`git config user.pair`@"
        # __git_ps1 "${BY}[${BC}$GIT_PS1_PAIR%s${BY}]${ZZ}"

        # Git Prompt from Git-Posh
        local gitstring=$(__posh_git_echo)
        echo -en "$gitstring"
    else
        # Classic Git-Prompt
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_STATESEPARATOR=""
        # GIT_PS1_SHOWUNTRACKEDFILES=1
        # GIT_PS1_SHOWSTASHSTATE=1
        # GIT_PS1_SHOWCOLORHINTS=1

        [ `git config user.pair` ] && GIT_PS1_PAIR="`git config user.pair`@"
        # __git_ps1 "${BY}[${BC}$GIT_PS1_PAIR%s${BY}]${ZZ}"
        __git_ps1 "${BC}$GIT_PS1_PAIR%s${ZZ}" | sed 's/ \([+*%]\{1,\}\)$/\1/'
    fi

    return $exit
}

function __prompt_rvm
{
    # preserve exit status
    local exit=$?
    local PROMPT="`cat ~/.bash/var.prompt`"
    if [ `command -v rvm-prompt` ]
    then
        rbv=$(rvm-prompt)
    fi
    [[ -z ${rbv} ]] && exit
    rbv=${rbv#ruby-}
    [[ $rbv == *"@"* ]] || rbv="${rbv}@default"
    if [ ${PROMPT} == "COMPLEX" ]
    then
        echo "[ Ruby: $rbv ]"
    else
        echo "$rbv"
    fi
    return $exit
}

function __prompt_time
{
    # preserve exit status
    local exit=$?
    if [ ! -z ${timer_output} ]
    then
        printf ${timer_output}
    fi
    return $exit
}

bash_prompt()
{
    # Colors:
    local  K="\[\033[0;30m\]"   # black
    local  R="\[\033[0;31m\]"   # red
    local  G="\[\033[0;32m\]"   # green
    local  Y="\[\033[0;33m\]"   # yellow
    local  B="\[\033[0;34m\]"   # blue
    local  M="\[\033[0;35m\]"   # magenta
    local  C="\[\033[0;36m\]"   # cyan
    local  W="\[\033[0;37m\]"   # white
    local GR="\[\033[0;090m\]"  # gray
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
    if [ -n "$SSH_CLIENT" ]
    then
        local SSHIP=$(echo $SSH_CLIENT | awk '{print $1}')
        local SSHPRPT="SSH from $SSHIP"
    else
        local SSHPRPT=""
    fi

    case $PROMPT in
        COMPLEX)
            if [ $ENVRM == "PRODUCTION" ]
            then
                PS1="${R}[${BY}\${?}${R}] [\$(__prompt_time)${R}] [${BR}\w${R}] \$(__git_prompt) ${M}\$(__prompt_rvm) ${BR}$SSHPRPT \n${BK}\t \u@\H λ${ZZ} "
            else
                PS1="${G}[${BY}\${?}${G}] [\$(__prompt_time)${G}] [${BC}\w${G}] \$(__git_prompt) ${M}\$(__prompt_rvm) ${BB}$SSHPRPT \n${BK}\t \u@\H λ${ZZ} "
            fi
            ;;
        SIMPLE)
            if [ $ENVRM == "PRODUCTION" ]
            then
                PS1="${R}[${BY}\${?}${R}] \u@\h${BY}:${R}\W \$(__git_prompt) ${M}\$(__prompt_rvm) ${BK}λ ${ZZ}"
            else
                PS1="${G}[${BY}\${?}${G}] \u@\h${BY}:${G}\W \$(__git_prompt) ${M}\$(__prompt_rvm) ${BK}λ ${ZZ}"
            fi
            ;;
    esac
}

preexec_functions+=(timer_start)
precmd_functions+=(timer_stop)
bash_prompt
unset bash_prompt
