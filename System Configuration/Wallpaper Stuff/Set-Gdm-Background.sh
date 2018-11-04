#!/bin/bash

#Set Gnome3 GDM background
#mReschke 2011-05-06

echo $1 > /tmp/gdm_background
su - gdm -s /bin/bash --command='
    img=`cat /tmp/gdm_background`;
    for line in `dbus-launch`; do export "$line"; done;
    /usr/lib/dconf/dconf-service &
    echo "Current GDM Background:";
    GSETTINGS_BACKEND=dconf gsettings get org.gnome.desktop.background picture-uri;    
    echo;echo "Setting new GDM Background to:";echo $img;
    GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-uri "file://$img";
    exit' 2> /dev/null
rm -rf /tmp/gdm_background
echo "Done"
