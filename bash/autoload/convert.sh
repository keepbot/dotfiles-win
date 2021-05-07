#!/usr/bin/env bash

# Digital converter: d - decimal h - hexadecimal b - binary
h2d()
{
    echo "ibase=16; $@"|bc
}

d2h()
{
    echo "obase=16; $@"|bc
}

b2d()
{
    echo "ibase=2; $@"|bc
}

d2b()
{
    echo "obase=2; $@"|bc
}

# Escape UTF-8 characters into their 3-byte format
escape()
{
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    echo # newline
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode()
{
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    echo # newline
}

calc()
{
    echo "scale=3;$@" | bc -l
}

resize_pdf()
{
    # Input:
    if [ -z "$1" ]
    then
        Usage: $0 input_file [resolution_in_dpi=72] [output_file=input_file_72dpi.pdf]
        exit 1
    fi

    input_directory=$(dirname -- "$1")
    input_basename=$(basename -- "$1")
    input_extension="${input_basename##*.}"
    input_filename="${input_basename%.*}"
    input_fullname="${input_directory}/${input_basename}"
    echo $input_fullname

    # Output resolution
    if [ ! -z "$2" ]
    then
        DPI="$2"
    else
        DPI="72"
    fi
    echo "  DPI set to ${DPI}"

    # Output:
    if [ ! -z "$3" ]
    then
        output_directory=$(dirname -- "$3")
        output_basename=$(basename -- "$3")
        output_extension="${output_basename##*.}"
        output_filename="${output_filename%.*}"
    else
        output_directory=${input_directory}
        output_basename="${input_filename}_${DPI}dpi.pdf"
        output_extension="${output_basename##*.}"
        output_filename="${output_filename%.*}"
    fi
    output_fullname="${output_directory}/${output_basename}"
    echo "  Output file name set to ${output_fullname}"

    gs                                          \
        -q -dNOPAUSE -dBATCH -dSAFER            \
        -sDEVICE=pdfwrite                       \
        -dCompatibilityLevel=1.3                \
        -dPDFSETTINGS=/screen                   \
        -dEmbedAllFonts=true                    \
        -dSubsetFonts=true                      \
        -dAutoRotatePages=/None                 \
        -dColorImageDownsampleType=/Bicubic     \
        -dColorImageResolution=$DPI             \
        -dGrayImageDownsampleType=/Bicubic      \
        -dGrayImageResolution=$DPI              \
        -dMonoImageDownsampleType=/Subsample    \
        -dMonoImageResolution=$DPI              \
        -sOutputFile="$output_fullname"         \
        "$input_fullname"
}
