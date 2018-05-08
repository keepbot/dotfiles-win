#!/usr/bin/env bash
# Digital converter: d - decimal h - hexadecimal b - binary
h2d() {
	echo "ibase=16; $@"|bc
}
d2h() {
	echo "obase=16; $@"|bc
}
b2d() {
	echo "ibase=2; $@"|bc
}
d2b() {
	echo "obase=2; $@"|bc
}

# "git commit only"
# Commits only what's in the index (what's been "git add"ed).
# When given an argument, uses that for a message.
# With no argument, opens an editor that also shows the diff (-v).
gco() {
	if [ -z "$1" ]; then
		git commit -v
	elif [ -z "$2" ]; then
		git commit "$1"
	else
		git commit "$1" -m "$2"
	fi
}

# "git commit all"
# Commits all changes, deletions and additions.
# When given an argument, uses that for a message.
# With no argument, opens an editor that also shows the diff (-v).
gca() {
	git add --all && gco "$1"
}

# "git get"
# Clones the given repo and then cd:s into that directory.
gget() {
	git clone "$1" && cd $( basename "$1" .git )
}

# Clone all users repos in current folder
get_user_repos () {
	if [ -z "$1" ] || [ $2 ]; then
		echo "You should enter name of GitHub user."
		echo "Usage: $0 <github_username>"
		echo
	else
		curl -s https://api.github.com/users/$1/repos?per_page=1000 > repo.list.json
		python -c "import json,sys,os;file = open('repo.list.json' ,'r');obj = json.load(file);obj_size = len(obj);cmd = 'git clone  ';[os.system(cmd + obj[x]['clone_url']) for x in range(0, obj_size)];file.close()"
		rm repo.list.json
	fi
	return 0
}


# Function to recursive clone repo from souurce URL to target direcrtory formated as <<repo_name>>-<<username>> (".git" - removed from path)
gcsr () {
	if [ -z "$1" ] || [ $2 ]; then
		echo "You should enter repo URI."
		echo "Usage: $0 <repo_url>"
		echo
	else
		target=`python -c "from urlparse import urlparse; import os.path; uri='$1';result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"`
		git clone --recurse-submodules "${1}" "${target}"
	fi
}

git-review() {
  if [ -z "$1" ] || [ "$2" ]; then
  		echo "Wrong command!"
  		echo "Usage: $0 <branch_name>"
  		echo
  	else
  		git push origin HEAD:refs/for/${1}
  	fi
}

# print available colors and their numbers
colours() {
	for i in {0..255}; do
		printf "\x1b[38;5;${i}m colour${i}"
		if (( $i % 5 == 0 )); then
			printf "\n"
		else
			printf "\t"
		fi
	done
}

# Create a new directory and enter it
md() {
	mkdir -p "$@" && cd "$@"
}

hist() {
	history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# find shorthand
f() {
	find . -name "$1"
}

# All the dig info
digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	echo # newline
}

# Extract archives - use: extract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
extract() {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xjf $1 ;;
			*.tar.gz) tar xzf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.rar) rar x $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar xf $1 ;;
			*.tbz2) tar xjf $1 ;;
			*.tgz) tar xzf $1 ;;
			*.zip) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.7z) 7z x $1 ;;
			*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

exit_code() {
	echo -e '\e[1;33m'Exit code: $?'\e[m'
}

ipif() {
	echo "Informarion about IP: ${1}"
	if [ ! $1 ]; then
		curl ipinfo.io
		echo
		return
	fi
		curl ipinfo.io/"${1}"
	echo
	return
}

calc() {
	echo "scale=3;$@" | bc -l
}

sss() {
	if [ ! "$1" ]; then
		echo "ERROR: You should enter path for searching..."
		echo "Usage: $0 \"<where>\" \"<string>\""
		echo
		exit 1
	fi
	if [ ! "$2" ]; then
		echo "ERROR: You should enter string for searching..."
		echo "Usage: $0 \"<where>\" \"<string>\""
		echo
		exit 1
	fi
	if [ "$3" ]; then
		echo "ERROR: Too many arguments..."
		echo "Usage: $0 \"<where>\" \"<string>\""
		echo
		exit 1
	fi
	grep -rnw $1 -e $2
}

sIP() {
	list=$(find . -name "$1"); grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" -h -o $list
}

# List files in current directory and replace spaces with underscores
lsD() {
	IFS=''
	for str in `find . -maxdepth 1 -type f -name "* *" |sed 's#.*/##'`; do
		echo ${str// /_}
	done
}

# Knife Aliases
kb() {
	cd ~ || return 1
	knife block "${1}"
	cd - >/dev/null || return 1
}

kne() {
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
