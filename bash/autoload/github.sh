#!/usr/bin/env bash

# Clone all users repos in current folder
gh_get_all_repos_https () {
	if [ -z "$1" ] || [ $2 ]; then
		echo "You should enter name of GitHub user."
		echo "Usage: gh_get_all_repos_https <github_username>"
		echo
	else
		curl -s https://api.github.com/users/$1/repos?per_page=1000 > repo.list.json
		python -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'git clone ';[os.system(cmd + obj[x]['clone_url']) for x in range(0, obj_size)];file.close()"
		rm repo.list.json
	fi
	return 0
}

gh_get_all_repos_ssh () {
	if [ -z "$1" ] || [ $2 ]; then
		echo "You should enter name of GitHub user."
		echo "Usage: gh_get_all_repos_ssh <github_username>"
		echo
	else
		curl -s https://api.github.com/users/$1/repos?per_page=1000 > repo.list.json
		python -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'git clone ';[os.system(cmd + obj[x]['ssh_url']) for x in range(0, obj_size)];file.close()"
		rm repo.list.json
	fi
	return 0
}

# Clone all users repos in current folder
gh_list_all_repos_https () {
	if [ -z "$1" ] || [ $2 ]; then
		echo "You should enter name of GitHub user."
		echo "Usage: gh_list_all_repos_https <github_username>"
		echo
	else
		curl -s https://api.github.com/users/$1/repos?per_page=1000 > repo.list.json
		python -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'echo ';[os.system(cmd + obj[x]['clone_url']) for x in range(0, obj_size)];file.close()"
		rm repo.list.json
	fi
	return 0
}

gh_list_all_repos_ssh () {
	if [ -z "$1" ] || [ $2 ]; then
		echo "You should enter name of GitHub user."
		echo "Usage: gh_list_all_repos_ssh <github_username>"
		echo
	else
		curl -s https://api.github.com/users/$1/repos?per_page=1000 > repo.list.json
		python -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'echo ';[os.system(cmd + obj[x]['ssh_url']) for x in range(0, obj_size)];file.close()"
		rm repo.list.json
	fi
	return 0
}

