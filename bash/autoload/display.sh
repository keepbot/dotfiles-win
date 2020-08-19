#!/usr/bin/env bash

alias c='clear'

# Export DISPLAY variable. If local than it exports localhost, if remole it exports SSH Client
alias disp='source ~/.bin/export-display.sh'


# Export display for WSL:
if [[ $WSL_DISTRO_NAME ]]; then
    export DISPLAY=$(ip route | grep default | awk '{print $3}'):0.0
fi

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
