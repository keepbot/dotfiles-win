#!/usr/bin/env bash

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


get_repo_with_target() {
  if [ -z "$1" ] || [ $2 ]; then
    echo "You should enter repo URI."
    echo "Usage: get_repo_with_targe <repo_url>"
    echo
  else
    scheme=$(python3 -c "from urllib.parse import urlparse; uri='${1}'; result = urlparse(uri); print(result.scheme)")
    if [[ ${scheme} = "https" ]]; then
      target=$(python3 -c "from urllib.parse import urlparse; import os.path; uri='${1}'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))")
    else
      target=$(python3 -c "from urllib.parse import urlparse; import os.path; uri='${1}'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))")
    fi
    git clone --recurse-submodules "${1}" "$target"
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

gprune() {
  CurrentBranch=$(git rev-parse --abbrev-ref HEAD)

  # Stash changes
  git stash

  # Checkout master:
  git checkout master
  git fetch

  # Run garbage collector
  git gc --prune=now

  # Prune obsolete refs in 3 turns
  git remote prune origin
  git fetch --prune
  git remote prune origin
  git fetch --prune
  git remote prune origin
  git fetch --prune

  # Return to working branch
  git checkout ${CurrentBranch}

  # Unstash work:
  git stash pop
}

alias ugr='for dir in `ls`; do echo "${dir}"; cd "${dir}"; git pull; cd ..; done' # Update all repos in current directory
alias ugrm='for dir in `ls`; do echo "${dir}"; cd "${dir}"; git checkout master; git pull; cd ..; done' # Check out to master and update all repos in current directory
alias ugrs='root=${PWD}; for dir in `ls`; do cd "${root}/${dir}" && ugr; done'    # Update all repos within all sub directories from curent
alias gsu='git submodule update --recursive --remote'
alias gll='git log --pretty=format:"%h - %an, %ar : %s"'
alias glL='git log --pretty=format:"%H - %an, %ar : %s"'
alias g="git"
alias gcr="git clone --recurse-submodules"
alias gs="git status"
alias gw="git show"
alias gw^="git show HEAD^"
alias gw^^="git show HEAD^^"
alias gw^^^="git show HEAD^^^"
alias gw^^^^="git show HEAD^^^^"
alias gw^^^^^="git show HEAD^^^^^"
alias gd="git diff HEAD"  # What's changed? Both staged and unstaged.
alias gdo="git diff --cached"  # What's changed? Only staged (added) changes.
# for gco ("git commit only") and gca ("git commit all"), see functions.sh.
# for gget (git clone and cd), see functions.sh.
alias ga="git add"
alias gc="git commit -v"
alias gcof="git commit --no-verify -m"
alias gcaf="git add --all && gcof"
alias gcac="gca Cleanup."
alias gcoc="gco Cleanup."
alias gcaw="gca Whitespace."
alias gcow="gco Whitespace."
alias gpp="git push"  # Can't pull because you forgot to track? Run this.
alias gppt="git push --tags"  # Can't pull because you forgot to track? Run this.
alias gppu="git push -u"  # Can't pull because you forgot to track? Run this.
alias gpl='git pull'
alias gplp='git pull --rebase && git push'
alias gps='(git stash --include-untracked | grep -v "No local changes to save") && gpp && git stash pop || echo "Fail!"'
alias gck="git checkout"
alias gb="git checkout -b"
alias got="git checkout -"
alias gom="git checkout master"
alias grb="git rebase -i origin/master"
alias gbr="git branch -d"
alias gbrf="git branch -D"
alias gbrr="git push origin --delete"
alias gcp="git cherry-pick"
alias gam="git commit --amend"
alias gamne="git commit --amend --no-edit"
alias gamm="git add --all && git commit --amend -C HEAD"
alias gammf="gamm --no-verify"
alias gba="git rebase --abort"
alias gbc="git add -A && git rebase --continue"
alias gbm="git fetch origin master && git rebase origin/master"
alias gfr="git fetch --all && git reset --hard origin/master"
alias GClean="git reset --hard && git clean -d -x -f"
alias grw="git review $1"
alias grb="git push origin HEAD:refs/for/$1"
alias git-home="git config --local user.email 'd.k.ivanov@live.com'"
alias git-work="git config --local user.email 'dmitriy.ivanov@ormco.com'"
alias grmt='git tag --delete'
alias grmto='git push --delete origin'
alias gabr='git branch -r | grep -v "\->" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done'
alias gcb='git clone --single-branch --branch'
alias gcrb='git clone --recurse-submodules --single-branch --branch'

# Gitolite list repos
alias ginfo='ssh gitolite@git info'

git-verbose() {
  if [ -z "${1}" ] || [ ${3} ]; then
    echo "ERROR: Wrong operation...."
    echo "Usage: Git-Verbose <On|Off> [Category]"
    echo "  Categories: curl, trace, pack, packet, perf"
    echo
    return 1
  fi

  if [ -z "${2}" ]; then
    category="all"
  else
    category="${2}"
  fi

  case $1 in
    On|on)
      if [[ "${category}" == "curl" || "${category}" == "all" ]];then
        export GIT_CURL_VERBOSE=1
        export GIT_TRACE_CURL=1
      fi
      if [[ "${category}" == "trace" || "${category}" == "all" ]];then
        export GIT_TRACE=1
      fi
      if [[ "${category}" == "pack" || "${category}" == "all" ]];then
        export GIT_TRACE_PACK_ACCESS=1
      fi
      if [[ "${category}" == "packet" || "${category}" == "all" ]];then
        export GIT_TRACE_PACKET=1
      fi
      if [[ "${category}" == "perf" || "${category}" == "all" ]];then
        export GIT_TRACE_PERFORMANCE=1
      fi
      if [[ "${category}" == "setup" || "${category}" == "all" ]];then
        export GIT_TRACE_SETUP=1
      fi
      ;;
    Off|off)
      export GIT_CURL_VERBOSE=0
      export GIT_TRACE_CURL=0
      export GIT_TRACE=0
      export GIT_TRACE_PACK_ACCESS=0
      export GIT_TRACE_PACKET=0
      export GIT_TRACE_PERFORMANCE=0
      export GIT_TRACE_SETUP=0
      ;;
    *)
      echo "ERROR: Wrong operation...."
      echo "Usage: Git-Verbose <On|Off> [Category]"
      echo "  Categories: curl, trace, pack, packet, perf"
      echo
      ;;
  esac
}
