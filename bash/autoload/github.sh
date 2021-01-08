#!/usr/bin/env bash

# TODO: Implement same function as in powereshell profile (WIP)
github_repos() {
    # A POSIX variable
    OPTIND=1         # Reset in case getopts has been used previously in the shell.

    # Initialize our own variables:
    clone=0
    organization=0
    protocol="SSH"

    show_help() {
        printf "Usage: \n"
        printf "  github_repos [-c] [-h[?]] -n NAME -o -p PROTOCOL \n\n"
        printf "  Options:\n"
        printf "    -n NAME     | Github user or organization name \n"
        printf "    -p PROTOCOL | Protocol: GIT, HTTPS, SSH or SVN \n"

    }

    while getopts "h?vfno:" opt; do
        case "$opt" in
        h|\?)
            show_help
            return
            ;;
        c)  clone=1
            ;;
        f)  output_file=$OPTARG
            ;;
        n)  name=$OPTARG
            ;;
        o)  organization=1
            ;;
        o)  protocol=$OPTARG
            ;;
        esac
    done

    shift $((OPTIND-1))

    [ "${1:-}" = "--" ] && shift

    if [ -z $name ]; then
        show_help
        return
    fi

    echo "                              \
        clone=$clone,                   \
        organization='$organization',   \
        protocol='$protocol',           \
        name='$name',                   \
        Leftovers: $@"
}

# Clone all users repos from GitHub
gh_get_user_repos_https () {
    if [ -z "$1" ] || [ $2 ]; then
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

gh_get_user_repos_ssh () {
    if [ -z "$1" ] || [ $2 ]; then
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
gh_list_user_repos_https () {
    if [ -z "$1" ] || [ $2 ]; then
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

gh_list_user_repos_ssh () {
    if [ -z "$1" ] || [ $2 ]; then
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

