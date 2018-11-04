#/bin/bash
gconftool-2 --shutdown
rm -rf /home/$HOME/.gconf/apps/panel
pkill gnome-panel
