#!/usr/bin/env bash

if [ ! "${OS_DISTRIBUTION}" != "Gentoo"  ]; then
    alias pkga='sudo emerge --ask'
    alias pkgd='sudo emerge --ask --unmerge'
fi
