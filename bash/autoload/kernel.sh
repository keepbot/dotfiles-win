#!/usr/bin/env bash

make_kernel()
{
    sudo make
    sudo make modules_install
    sudo make install
    sudo emerge @module-rebuild
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

update_kernel()
{
    sudo bash -c 'zcat /proc/config.gz > /usr/src/linux/.config'
    sudo make olddefconfig
    make_kernel
}
