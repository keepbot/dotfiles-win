#!/bin/bash

for i in {0..255}
do
    printf "\x1b[38;5;${i}mcolour%03d\t" ${i}
    if ((${i} % 7  == 0 ))
    then
        printf "\n"
    fi
done
