#!/usr/bin/env bash

# Digital converter: d - decimal h - hexadecimal b - binary
h2d() {
	echo "ibase=16; $@"|bc
}
d2h() {
	echo "obase=16; $@"|bc
}
b2d() {
	echo "ibase=2; $@"|bc
}
d2b() {
	echo "obase=2; $@"|bc
}

# Escape UTF-8 characters into their 3-byte format
escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	echo # newline
}

calc() {
	echo "scale=3;$@" | bc -l
}
