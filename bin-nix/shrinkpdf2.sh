#!/bin/sh

### DRAFT with basic usage

shrink ()
{
    /usr/local/bin/ps2df $1 $2
    /usr/local/bin/pdf2ps $2 $1
}

check_smaller ()
{
    # If $1 and $2 are regular files, we can compare file sizes to
    # see if we succeeded in shrinking. If not, we copy $1 over $2:
    if [ ! -f "$1" -o ! -f "$2" ]
    then
        return 0;
    fi
    ISIZE="$(echo $(wc -c "$1") | cut -f1 -d\ )"
    OSIZE="$(echo $(wc -c "$2") | cut -f1 -d\ )"
    if [ "$ISIZE" -lt "$OSIZE" ]
    then
        echo "Input smaller than output, doing straight copy" >&2
        cp "$1" "$2"
    fi
}

usage ()
{
    echo "Reduces PDF filesize by lossy recompressing with PDFTK."
    echo "Not guaranteed to succeed, but usually works."
    echo "  Usage: $1 infile [outfile]"
}

IFILE="$1"

# Need an input file:
if [ -z "$IFILE" ]
then
    usage "$0"
    exit 1
fi

# Output filename defaults to "-" (stdout) unless given:
if [ ! -z "$2" ]
then
    OFILE="$2"
else
    OFILE="-"
fi

shrink "$IFILE" "$OFILE" || exit $?

check_smaller "$IFILE" "$OFILE"
