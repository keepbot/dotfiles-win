#!/usr/bin/env bash

if [ ! "${OS_DISTRIBUTION}" != "Gentoo"  ]; then
    alias addpkg='sudo emerge --ask'
    alias rmpkg='sudo emerge --ask --unmerge'
    alias where='e-file'
    alias update='sudo emerge --ask --update --deep --newuse @world'
    alias check_bb='eix -I "(bumblebee|virtualgl|primus|bbswitch)"'
fi
