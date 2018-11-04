#!/bin/bash
if [ -f ~/Pictures/Backgrounds/mercator.jpg ] ; then rm -f ~/Pictures/Backgrounds/mercator.jpg ; fi
wget -r -N http://static.die.net/earth/mercator/1600.jpg -O $HOME/Pictures/Backgrounds/mercator.jpg

# GNOME2 use
#gconftool-2 --type string --set /desktop/gnome/background/picture_filename $HOME/Pictures/Backgrounds/mercator.jpg
# GNOME3 use
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Backgrounds/mercator.jpg"
