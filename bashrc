#!/usr/bin/env bash
# Test for interactiveness
[[ $- == *i* ]] || return

# Include https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
[[ -f $HOME/.bash/git-prompt.sh ]]          && source ~/.bash/git-prompt.sh
# Set Prompt
[[ -f $HOME/.bash/prompt.sh ]]              && source ~/.bash/prompt.sh

# gruvbox colors
[[ -f $HOME/.data/gruvbox_256palette.sh ]]  && source ~/.data/gruvbox_256palette.sh

# Include https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
[[ -f $HOME/.bash/git-completion.bash ]]    && source ~/.bash/git-completion.bash

# Import ENVIRONMENT
[[ -f $HOME/.bash/env.sh ]]                 && source ~/.bash/env.sh

# Import Aliases
[[ -f $HOME/.bash/aliases.sh ]]             && source ~/.bash/aliases.sh

# Import Functions
[[ -f $HOME/.bash/functions.sh ]]           && source ~/.bash/functions.sh

#Import Rust env
[[ -f $HOME/.cargo/env ]]                   && source $HOME/.cargo/env

# Include EncFS aliases. For private use only:
[[ -f $HOME/.bash/encfs.sh ]]               && source ~/.bash/encfs.sh

# Auto .env
[[ -f $HOME/.bash/venv.sh ]]                && source ~/.bash/venv.sh

[[ -f $HOME/.localenv ]]                    && source ~/.localenv
