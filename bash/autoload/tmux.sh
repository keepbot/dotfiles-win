#!/usr/bin/env bash

alias tmux='tmux -2'
alias   tm='tmux'
alias  tma='tmux attach'
alias tmat='tmux attach -t'
alias tmns='tmux new-session -s'
alias tmls='tmux ls'

# With tmux mouse mode on, just select text in a pane to copy.
# Then run tcopy to put it in the OS X clipboard (assuming reattach-to-user-namespace).
alias tcopy='tmux show-buffer | pbcopy'
