make_kernel() {
    sudo make
    sudo make modules_install
    sudo make install
    sudo emerge @module-rebuild
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}
