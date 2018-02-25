#!/usr/bin/env bash

mkcdir() {
	mkdir -p -- "${1}" &&
	cd -P -- "${1}"
}

clone_update_repo() {
	if [ -z "${1}" ] || [ "${2}" ]; then
		echo "Usage: clone_update_repo <NAMESPACE/TO/REPO>"
		echo
	else
		repofolder=$(basename "$1")
		if [ -d "${repofolder}" ]; then
			echo "${repofolder} exists, will try to fetch"
			pushd "${repofolder}" >/dev/null
			git fetch --tags
			popd >/dev/null
		else
			if [ $(git ls-remote "gitolite@git:${1}" | grep -c HEAD) -gt 0 ]; then
				echo "$1 will be cloned into ${rootdir}/${repofolder}"
				git clone gitolite@git:"${1}" "${repofolder}"
			else
				echo "${1} seems to be empty, skipping..."
			fi
		fi
	fi
}

clone_update_group() {
	if [ -z "${2}" ] || [ "${3}" ]; then
		echo "Usage: clone_update_group <NAMESPACE/SUBSPACE> <DESTINATION_FOLDER>"
		echo
	else
		mkcdir "$2"
		for i in $(ssh gitolite@git 2>/dev/null | grep -E "$1" | grep -v '\[' | sed -E "s/^.*($1.*)/\1/g"); do
			clone_update_repo "$i"
		done
		cd - || return 1
	fi
}

get_cbk() {
	cd ~/workspace/Chef/cookbooks || return 1
	git clone "gitolite@git.aligntech.com:chef/cookbooks/${1}.git"
	cd "${1}" || return 1
}

kb() {
	cd ~ || return 1
	knife block "${1}"
	cd - >/dev/null || return 1
}

function kne() {
	cd ~ || return 1
	knife node edit "${1}" -a
	cd - >/dev/null || return 1
}

ksn() {
	cd ~ || return 1
	envupper=$(echo "${1}" | tr '[:lower:]' '[:upper:]')
	if [ $# -eq 1 ]; then
		recipe_term=""
	else
		recipe_term="AND recipe:*${2}*"
	fi
	knife search node "chef_env*:${envupper} ${recipe_term}" -i;
	cd - >/dev/null || return 1
}

ksni() {
	cd ~ || return 1
	knife search node "ipaddress:${1}" -i;
	cd - >/dev/null || return 1
}

wso2creds() {
	cd ~ || return 1
	envupper=$(echo "${1}" | tr '[:lower:]' '[:upper:]')
	knife block itio-vault > /dev/null
	knife vault show wso2creds "${envupper}" --mode client --format json | ruby -e "require 'json'; puts(JSON.parse(ARGF.read)['users']['${2}'])"
	knife block itio > /dev/null
	cd - >/dev/null || return 1
}

