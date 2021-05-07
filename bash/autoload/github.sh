#!/usr/bin/env bash

function set_github_secret_file
{
    local github_secret_file="${HOME}/.github.secrets"

    if [ -f ${github_secret_file} ]
    then
        echo ">>> Warning: ${github_secret_file} already exist!"
        read -n 1 -p "Do you want to replace it? (y/[Any key to cancel]): " WANT_REPLACE
        [ "${WANT_REPLACE}" = "y" ] || exit 2
        echo
    fi

    read -p "Enter Github username: " gh_username
    read -p "Enter Github token: "    gh_token
    echo

    touch $github_secret_file
    echo "$gh_username" > $github_secret_file
    echo "$gh_token" >> $github_secret_file
}

function get_github_secrets
{
    local github_secret_file="${HOME}/.github.secrets"

    if [ ! -f ${github_secret_file} ]
    then
        echo ">>> Error: Github secret file is missing!"
        echo "Please run set_github_secret_file to configure your github secterts"
        read -n 1 -p "Do you want to do it right now? (y/[Any key to cancel]): " WANT_INIT
        [ "${WANT_INIT}" = "y" ] || exit 1
        echo
        set_github_secret_file
        echo
    fi

    local username=$(head -1 ${github_secret_file})
    local token=$(head -2 ${github_secret_file} | tail -1)

    printf "${username}:${token}"
}

function github_repos()
{
    # Reset 'OPTARG' in case getopts has been used previously in the shell
    OPTIND=1

    # Initialize option variables
    local all_repos=0
    local clone=0
    local gh_name=''
    local github_secret_file="${HOME}/.github.secrets"
    local organization=0
    local protocol="SSH"

    show_help()
    {
        printf "Usage: \n"
        printf "  github_repos [-a] [-c] [-h|?] -n NAME [-o] [-p PROTOCOL] \n\n"
        printf "  Options:\n"
        printf "    -a          | Get all repositories with forks                 \n"
        printf "    -c          | Clone repositories instead of printing          \n"
        printf "    -h|?        | Show this help message                          \n"
        printf "    -n NAME     | Github user or organization name                \n"
        printf "    -o          | Get organization repos instead of user          \n"
        printf "    -p PROTOCOL | Protocol: GIT, HTTPS, SSH or SVN (Default: SSH) \n"
    }

    while getopts "ach?n:op:" opt
    do
        case "$opt" in
            a)  all_repos=1
                ;;
            c)  clone=1
                ;;
            h|\?)
                show_help
                return
                ;;
            n)  gh_name=$OPTARG
                ;;
            o)  organization=1
                ;;
            p)  protocol=$OPTARG
                ;;
        esac
    done

    shift $((OPTIND-1))

    [ "${1:-}" = "--" ] && shift

    if [ -z $gh_name ]
    then
        show_help
        return
    fi

    if [ $clone -eq 1 ]
    then
        BaseCommand='git clone --recurse-submodules'
    else
        BaseCommand='echo'
    fi

    local BasicCreds=$(get_github_secrets)
    local GithubHeaders="Accept: application/vnd.github.v3+json"

    if [ $organization -eq 1 ]
    then
        BaseApiUrl="https://api.github.com/orgs/${gh_name}/repos?sort=pushed&per_page=100"
    else
        BaseApiUrl="https://api.github.com/users/${gh_name}/repos?sort=pushed&per_page=100"
    fi

    local ResponceCode=$(curl -I -s -u $BasicCreds $BaseApiUrl 2>/dev/null | head -n 1 | cut -d$' ' -f2)
    if [ ${ResponceCode} -ne "200" ]
    then
        echo "Error: Github User or Organization not found. Exiting..."
        echo
        return
    fi

    RequestAnswerFile='/tmp/github_repos_RequestAnswer.json'
    TempAnswerFile1='/tmp/github_repos_TempAnswer1.json'
    TempAnswerFile2='/tmp/github_repos_TempAnswer2.json'
    touch ${RequestAnswerFile}
    touch ${TempAnswerFile1}
    touch ${TempAnswerFile2}
    trap "{ rm -f ${RequestAnswerFile}; }" RETURN
    trap "{ rm -f ${TempAnswerFile1};   }" RETURN
    trap "{ rm -f ${TempAnswerFile2};   }" RETURN

    local last_page=$(curl -I -s -u $BasicCreds -H $GithubHeaders $BaseApiUrl | grep '^Link:' | sed -e 's/^Link:.*page=//g' -e 's/>.*$//g')
    if [ -z "$last_page" ]
    then
        printf "Processing single page: \n"
        curl -s -u $BasicCreds $BaseApiUrl > ${RequestAnswerFile}
    else
        printf "Processing pages: "
        for p in $(seq 1 $last_page)
        do
            printf "${p} "
            curl -s -u $BasicCreds "$BaseApiUrl&page=${p}" > ${TempAnswerFile1}
            jq -s add ${RequestAnswerFile} ${TempAnswerFile1} > ${TempAnswerFile2}
            mv ${TempAnswerFile2} ${RequestAnswerFile}
            if [[ $p -eq 2 ]]
            then
                break
            fi
        done
        printf "\n"
    fi

    for repo in $(jq -r '.[] | @base64' ${RequestAnswerFile})
    do
        _jq()
        {
            echo ${repo} | base64 --decode | jq -r ${1}
        }

        if [[ $all_repos == 0  ]] && [[ $(_jq '.fork') == 'true' ]]
        then
            continue
        fi

        case "$protocol" in
            GIT)
                $BaseCommand $(_jq '.git_url')
                ;;
            HTTPS)
                $BaseCommand $(_jq '.clone_url')
                ;;
            SSH)
                $BaseCommand $(_jq '.ssh_url')
                ;;
            SVN)
                $BaseCommand $(_jq '.svn_url')
                ;;
        esac
    done

    rm -f ${RequestAnswerFile}
    rm -f ${TempAnswerFile1}
    rm -f ${TempAnswerFile2}
}

# Clone all users repos from GitHub
gh_get_user_repos_https()
{
    if [ -z "$1" ] || [ $2 ]
    then
        echo "You should enter name of GitHub user."
        echo "Usage: gh_get_all_repos_https <github_username>"
        echo
    else
        curl -s "https://api.github.com/users/${1}/repos?sort=pushed&per_page=100" > repo.list.json
        python3 -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'git clone ';[os.system(cmd + obj[x]['clone_url']) for x in range(0, obj_size)];file.close()"
        rm repo.list.json
    fi
    return 0
}

gh_get_user_repos_ssh()
{
    if [ -z "$1" ] || [ $2 ]
    then
        echo "You should enter name of GitHub user."
        echo "Usage: gh_get_all_repos_ssh <github_username>"
        echo
    else
        curl -s "https://api.github.com/users/${1}/repos?sort=pushed&per_page=100" > repo.list.json
        python3 -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'git clone ';[os.system(cmd + obj[x]['ssh_url']) for x in range(0, obj_size)];file.close()"
        rm repo.list.json
    fi
    return 0
}

# List users repos on GitHub
gh_list_user_repos_https()
{
    if [ -z "$1" ] || [ $2 ]
    then
        echo "You should enter name of GitHub user."
        echo "Usage: gh_list_all_repos_https <github_username>"
        echo
    else
        curl -s "https://api.github.com/users/${1}/repos?sort=pushed&per_page=100" > repo.list.json
        python3 -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'echo ';[os.system(cmd + obj[x]['clone_url']) for x in range(0, obj_size)];file.close()"
        rm repo.list.json
    fi
    return 0
}

gh_list_user_repos_ssh()
{
    if [ -z "$1" ] || [ $2 ]
    then
        echo "You should enter name of GitHub user."
        echo "Usage: gh_list_all_repos_ssh <github_username>"
        echo
    else
        curl -s "https://api.github.com/users/${1}/repos?sort=pushed&per_page=100" > repo.list.json
        python3 -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'echo ';[os.system(cmd + obj[x]['ssh_url']) for x in range(0, obj_size)];file.close()"
        rm repo.list.json
    fi
    return 0
}
