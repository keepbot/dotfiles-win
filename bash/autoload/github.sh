#!/usr/bin/env bash

# TODO:
get_gh_repos() {
    # A POSIX variable
    OPTIND=1         # Reset in case getopts has been used previously in the shell.

    # Initialize our own variables:
    output_file=""
    verbose=0
    show_help() {
        echo "$0 -h -v -f"
    }

    while getopts "h?vf:" opt; do
        case "$opt" in
        h|\?)
            show_help
            return
            ;;
        v)  verbose=1
            ;;
        f)  output_file=$OPTARG
            ;;
        esac
    done

    shift $((OPTIND-1))

    [ "${1:-}" = "--" ] && shift

    echo "verbose=$verbose, output_file='$output_file', Leftovers: $@"
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

