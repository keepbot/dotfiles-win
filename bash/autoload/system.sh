#!/usr/bin/env bash

alias clear_mem_1='sudo bash -c "sync; echo 1 > /proc/sys/vm/drop_caches"'
alias clear_mem_2='sudo bash -c "sync; echo 2 > /proc/sys/vm/drop_caches"'
alias clear_mem_3='sudo bash -c "sync; echo 3 > /proc/sys/vm/drop_caches"'

function list_users()
{
    cat /etc/passwd | awk -F ':' '{print $0}' | sort -nk3 -t ':'
}

function list_groups()
{
    cat /etc/group | awk -F ':' '{print $0}' | sort -nk3 -t ':'
}
