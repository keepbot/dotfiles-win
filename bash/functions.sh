# Digital converter: d - decimal h - hexadecimal b - binary
h2d(){
	echo "ibase=16; $@"|bc
}
d2h(){
	echo "obase=16; $@"|bc
}
b2d(){
	echo "ibase=2; $@"|bc
}
d2b(){
	echo "obase=2; $@"|bc
}

# "git commit only"
# Commits only what's in the index (what's been "git add"ed).
# When given an argument, uses that for a message.
# With no argument, opens an editor that also shows the diff (-v).
function gco {
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
function gca {
  git add --all && gco "$1"
}

# "git get"
# Clones the given repo and then cd:s into that directory.
function gget {
  git clone $1 && cd $(basename $1 .git)
}

# Clone all users repos in current folder
function get_user_repos () {
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

# print available colors and their numbers
function colours() {
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
function md() {
    mkdir -p "$@" && cd "$@"
}

function hist() {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# find shorthand
function f() {
    find . -name "$1"
}

# All the dig info
function digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    echo # newline
}

# Extract archives - use: extract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
function extract() {
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

function exit_code() {
	echo -e '\e[1;33m'Exit code: $?'\e[m'
}

function ipif() {
	if [ ! $1 ]; then
		curl ipinfo.io
		echo
		return
	fi

	if grep -P "(([1-9]\d{0,2})\.){3}(?2)" < "$1"; then
		curl ipinfo.io/"$1"
	else
		ipawk=($(host "$1" | awk '/address/ { print $NF }'))
		curl ipinfo.io/${ipawk[1]}
	fi
	echo
	return
}

function calc() {
	echo "scale=3;$@" | bc -l
}
