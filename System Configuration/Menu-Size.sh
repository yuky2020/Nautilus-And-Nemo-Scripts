#!/bin/bash

#===============================#
# What:	GNOME 2.x MenuSize 1.0	#
# Who:	by Cooleech		#
# Use:	at your own risk	#
#===============================#

# First, thank you for your interest in this small and useful script!
# I had a lot of headaches with way too large GNOME menu on small screens such as netbooks.
# This script fixes just that, it can change menu item size to the one you see fit.
# This little script is pretty straightforward to use. Just run MenuSize.sh and pick any size.
# After you confirm your choice it will ask you to restart gnome panel in order to apply any
# changes. If you wish to make things back "to normal", just pick Remove changes.
# That's it.
#
# If any problems or questions:
#
# cooleech AT gmail DOT com

# Use at your own risk!
# Free to run, modify, share, use and abuse.
# Buy me a beer if you ever meet me!

Size=`zenity --width=500 --height=250 --list --radiolist --title "MenuSize 1.0" --text "Pick desired menu size" --column " ? " --column "Size" --column "Description" FALSE "Remove changes" "Default size (auto-restarts GNOME panel)" FALSE "20" "Medium size (screen height up to 800 pixels)" TRUE "16" "Small size (screen height up to 600 pixels)" FALSE "12" "Tiny size (if nothing else fits)"`
if [ $? != 0 ]; then
	exit
fi

if [ -e $HOME/.gtkrc-2.0 ]; then # Backup if exists
	mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.bak
fi

case "$Size" in
Remove*)
rm -f $HOME/.gtkrc-2.0
killall gnome-panel
exit
;;
20*)
Size="20"
;;
16*)
Size="16"
;;
12*)
Size="12"
;;
*)
exit
;;
esac

echo "gtk-icon-sizes = \"panel-menu=$Size,$Size:gtk-button=$Size,$Size\"

style \"menu-item\"
{
ythickness = 3
}
" > $HOME/.gtkrc-2.0

zenity --question --no-wrap --title "MenuSize 1.0" \
	--text "Apply your changes now? If so, your GNOME panel(s) will be killed.\nIf this isn't acepptable, it will be applied on next boot."
if [ $? = 0 ]; then
	killall gnome-panel
fi

exit 0
