#!/usr/bin/env bash

if [ -f /proc/version ] && grep -q Microsoft /proc/version
then
    wsl-kali-install-full()
    {
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt install -y     \
            kali-linux-full     \
            kali-desktop-xfce   \
            xorg xrdp compton   \
            fonts-takao         \
            fonts-takao-mincho
        sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
        echo '
            sudo killall -9 esd
            export OOO_FORCE_DESKTOP=gnome
            export LANG="en_US.UTF-8"
            export LC_ALL="en_US.UTF-8"
            export LANGUAGE="en_US.UTF-8"
            export LC_CTYPE="en_US.UTF-8"
            compton --vsync opengl -b
            exec startxfce4
        ' > ~/.xinitrc
        chmod +x ~/.xinitrc
        ln -sf ~/.xinitrc ~/.xsession
        sudo cp ~/.bin/xfce/default.xml /etc/xdg/xfce4/panel/default.xml
        sudo cp ~/.bin/xfce/xfce4-session.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
        [[ -f /etc/xdg/autostart/disabled-autostart ]] || sudo mkdir -p /etc/xdg/autostart/disabled-autostart
        [[ -f /etc/xdg/autostart/nm-applet.desktop  ]] && sudo mv -f /etc/xdg/autostart/nm-applet.desktop /etc/xdg/autostart/disabled-autostart/
    }

    wsl-xfce()
    {
        export DISPLAY=localhost:0.0
        export XDG_RUNTIME_DIR=~/runtime
        export RUNLEVEL=3
        sudo /etc/init.d/dbus restart
        dbus-launch --exit-with-session ~/.xsession
    }

    wsl-xfce-stop()
    {
        sudo /etc/init.d/dbus stop
    }
fi

