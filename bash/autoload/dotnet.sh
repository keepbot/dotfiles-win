#!/usr/bin/env bash

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# bash parameter completion for the dotnet CLI
_dotnet_bash_complete()
{
    local word=${COMP_WORDS[COMP_CWORD]}

    local completions
    completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)"
    if [ $? -ne 0 ]
    then
        completions=""
    fi

    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}
complete -f -F _dotnet_bash_complete dotnet

install_dotnet_2004()
{
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-5.0
}
