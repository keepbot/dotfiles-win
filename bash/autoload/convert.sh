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

resize_pdf() {
    # Input:
    IFILE="${1}"
    if [ -z "${IFILE}" ]; then
        Usage: ${0} input_file [output_file=input_file_72dpi.pdf] [resolution_in_dpi=72]
        exit 1
    fi

    # Output resolution
    if [ -z "${3}" ]; then
        DPI="${3}"
    else
        DPI="72"
    fi

    # Output:
    if [ ! -z "${2}" ]; then
        OFILE="${2}"
    else
        input_file_name=(basename ${IFILE})
        OFILE="${input_file_name}_${DPI}.pdf"
    fi

    gs                                          \
        -q -dNOPAUSE -dBATCH -dSAFER            \
        -sDEVICE=pdfwrite                       \
        -dCompatibilityLevel=1.3                \
        -dPDFSETTINGS=/screen                   \
        -dEmbedAllFonts=true                    \
        -dSubsetFonts=true                      \
        -dAutoRotatePages=/None                 \
        -dColorImageDownsampleType=/Bicubic     \
        -dColorImageResolution=${DPI}           \
        -dGrayImageDownsampleType=/Bicubic      \
        -dGrayImageResolution=${DPI}            \
        -dMonoImageDownsampleType=/Subsample    \
        -dMonoImageResolution=${DPI}            \
        -sOutputFile="${OFILE}"                 \
        "${IFILE}"
}
