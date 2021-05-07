#!/usr/bin/env bash

platform=`uname`
if [ ! "${platform}" != "Darwin"  ]
then
    alias  lib_arch='lipo -info'
    alias  lib_object='otools -L'
    alias  lib_object_v='otools -Lv'
fi

alias show_opscodes_b='objdump -d /bin/* | cut -f3 | grep -oE "^[a-z]+" | sort | uniq -c'
alias show_opscodes_ub='objdump -d /usr/bin/* | cut -f3 | grep -oE "^[a-z]+" | sort | uniq -c'
alias show_opscodes_sb='objdump -d /sbin/* | cut -f3 | grep -oE "^[a-z]+" | sort | uniq -c'
