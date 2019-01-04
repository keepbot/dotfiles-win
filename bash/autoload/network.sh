#!/usr/bin/env bash

# IP addresses
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# View HTTP traffic
alias sniffe="sudo ngrep -d 'enp0s31f6' -t '^(GET|POST) ' 'tcp and port 80'"
alias sniffw="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
