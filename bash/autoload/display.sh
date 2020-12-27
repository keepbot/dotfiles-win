#!/usr/bin/env bash

alias c='clear'

# Export DISPLAY variable. If local than it exports localhost, if remole it exports SSH Client
alias disp='source ~/.bin/export-display.sh'


# Export display for WSL:
if [[ $WSL_DISTRO_NAME ]]; then
    export DISPLAY=$(ip route | grep default | awk '{print $3}'):0.0
fi
