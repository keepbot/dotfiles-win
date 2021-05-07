#!/usr/bin/env bash

# print available colors and their numbers
print_colors()
{
    for i in {0..255}
    do
        printf "\x1b[38;5;${i}m colour${i}"
        if (( $i % 5 == 0 ))
        then
            printf "\n"
        else
            printf "\t"
        fi
    done
}

print_colors_bash()
{
    printf "\[\033[0;30m\] black          \n" # black
    printf "\[\033[0;31m\] red            \n" # red
    printf "\[\033[0;32m\] green          \n" # green
    printf "\[\033[0;33m\] yellow         \n" # yellow
    printf "\[\033[0;34m\] blue           \n" # blue
    printf "\[\033[0;35m\] magenta        \n" # magenta
    printf "\[\033[0;36m\] cyan           \n" # cyan
    printf "\[\033[0;37m\] white          \n" # white
    printf "\[\033[0;090m\] gray          \n" # gray
    printf "\[\033[1;30m\] bolded black   \n" # bolded black
    printf "\[\033[1;31m\] bolded red     \n" # bolded red
    printf "\[\033[1;32m\] bolded green   \n" # bolded green
    printf "\[\033[1;33m\] bolded yellow  \n" # bolded yellow
    printf "\[\033[1;34m\] bolded blue    \n" # bolded blue
    printf "\[\033[1;35m\] bolded magenta \n" # bolded magenta
    printf "\[\033[1;36m\] bolded cyan    \n" # bolded cyan
    printf "\[\033[1;37m\] bolded white   \n" # bolded white
    printf "\[\033[0m\] reset \n"             # Reset
}

print_colors_16()
{
    #Foreground
    for clbg in {40..47} {100..107} 49
    do
        #Foreground
        for clfg in {30..37} {90..97} 39
        do
            #Formatting
            for attr in 0 1 2 4 5 7
            do
                #Print the result
                echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
            done
            echo #Newline
        done
    done
}

print_colors_256()
{
    for fgbg in 38 48
    do # Foreground / Background
        for color in {0..255}
        do # Colors
            # Display the color
            printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
            # Display 6 colors per lines
            if [ $((($color + 1) % 6)) == 4 ]
            then
                echo # New line
            fi
        done
        echo # New line
    done
}
