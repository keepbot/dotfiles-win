#!/usr/bin/env bash

if [ ! "${OS_DISTRIBUTION}" != "Gentoo"  ]
then
    alias addpkg='sudo emerge --ask'
    alias check_bb='eix -I "(bumblebee|virtualgl|primus|bbswitch)"'
    alias rmpkg='sudo emerge --ask --unmerge'
    alias update='sudo emerge --ask --update --deep --newuse @world'
    alias where='e-file'
fi
