#!/usr/bin/env bash

alias make_uninstall='xargs rm < install_manifest.txt'

make_uninstall_safe()
{
    sudo xargs -I{} stat -c "%z %n" "{}" < install_manifest.txt
    if [[ ! $? == 0 ]]
    then
        echo "Errors were found! Automated uninstall is not possible. Exiting..."
        return 1
    fi

    mkdir deleted-by-uninstall
    sudo xargs -I{} mv -t deleted-by-uninstall "{}" < install_manifest.txt
    if [[ ! $? == 0 ]]
    then
        echo "Errors were found! Automated uninstall was not completed."
        echo "Please check install_manifest.txt for errors. Exiting..."
        return 2
    fi

    echo "All installed files are moved to './deleted-by-uninstall'."
    echo "Please check and delete this folder. If now mistakes will be found"
}
