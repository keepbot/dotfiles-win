#!/usr/bin/env bash

alias    di='docker images'
alias    dc='docker ps -a'
alias  dcle='docker rm $(docker ps -aqf status=exited)'
alias  dclc='docker rm $(docker ps -aqf status=created)'
alias  dcla='docker rm $(docker ps -aqf status=exited) || docker rmi $(docker images -qf dangling=true) || docker volume rm $(docker volume ls -qf dangling=true)'
alias  dcli='docker rmi $(docker images -q)'
alias dclif='docker rmi -f $(docker images -q)'

# Run docker container in interactive mode
alias dri='docker run --rm -it'
# Rewrite entry point to shell
alias desh='docker run --rm -it --entrypoint /bin/sh'

# inspect docker images
function dc_trace_cmd()
{
    local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
    declare -i level=$2
    echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
    level=level+1
    if [ "${parent}" != "" ]
    then
        echo ${level}: $parent
        dc_trace_cmd $parent $level
    fi
}

function docker_search_logs()
{
    if [ -z "${1}" ]
    then
        echo "Usage: docker_search_logs Search_String"
        echo
    else
        docker ps -a --format "{{.Names}}" | xargs -i bash -c "docker logs {} |& sed -ne 's/^\[\(2020[0-9.:T-]*Z\)\(.*\)/\1 {}\t\2/p'" | grep "${1}" | sort -st ' ' -nk1 | less
    fi
}
