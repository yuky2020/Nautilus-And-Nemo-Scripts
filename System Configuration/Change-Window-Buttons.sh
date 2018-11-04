#!/bin/bash
#Thanks Translate http://pastebin.com/i0rNwsHd
export a="Move window buttons to the 'right' side"
export b="Move window buttons to the 'left' side"
export c="Indicate changes for the buttons 'manually' "
export e="'Delete' settings that have been set as default"
ans=$(zenity --title " Change Window Buttons" --window-icon='/usr/share/pixmaps/gnome-gnomoku.png' --width="390" --height="236" --list --text="<big>Which side do window buttons been?</big>" --radiolist --column "Select" --column "Change buttons" TRUE "$a" TRUE2 "$b" TRUE3 "$c" True4 "$e" );   echo $ans
if [ $? -eq 1 ] ; then
exit 1
fi

case $ans in
"$a")
gconftool -s --type string /apps/metacity/general/button_layout ":minimize,maximize,close";
gconftool -s --type bool /apps/panel/toplevels/panel_0/background/stretch "True";
gconftool -s --type bool /apps/panel/toplevels/top_panel_screen0/background/stretch "True";
gconftool -s --type bool /desktop/gnome/interface/hide_decorator_tooltip "TRUE" ;
zenity --question --text="<b>For this settings always be protected, the settings that have been chosen by</b> <i>Configuration Editor</i> application should be default!\n\n<i>Shall Configuraiton Editor</i> open?"
if [ $? -eq 1 ] ; then
exit 1
fi
gconf-editor '/apps/metacity/general/button_layout' ;;
"$b")
gconftool -s --type string /apps/metacity/general/button_layout "maximize,minimize,close:";
gconftool -s --type bool /apps/panel/toplevels/panel_0/background/stretch "True";
gconftool -s --type bool /apps/panel/toplevels/top_panel_screen0/background/stretch "True";
 gconftool -s --type bool /desktop/gnome/interface/hide_decorator_tooltip "TRUE" ;
zenity --question --text="<b>For this settings always be protected, the settings that have been chosen by</b> <i>Configuration Editor</i> application should be default!\n\n<i>Shall Configuraiton Editor</i> open?"
 if [ $? -eq 1 ] ; then
exit 1
fi
gconf-editor '/apps/metacity/general/button_layout' ;;
"$c")
d=`zenity  ":minimize,maximize,close"   "maximize,minimize,close:"  --entry --text="Select the arrangement or add new input."`;
if [ $? -eq 1 ] ; then
exit 1
fi
gconftool -s --type string /apps/metacity/general/button_layout "$d";
gconftool -s --type bool /apps/panel/toplevels/panel_0/background/stretch "True";
gconftool -s --type bool /apps/panel/toplevels/top_panel_screen0/background/stretch "True";
gconftool -s --type bool /desktop/gnome/interface/hide_decorator_tooltip "TRUE" ;
zenity --question --text="<b>For this settings always be protected, the settings that have been chosen by</b> <i>Configuration Editor</i> application should be default!\n\n<i>Shall Configuraiton Editor</i> open?"
 if [ $? -eq 1 ] ; then
exit 1
fi
 gconf-editor '/apps/metacity/general/button_layout' ;;
"$e")
gksu Remove
sudo rm -rf /etc/gconf/gconf.xml.mandatory/%gconf-tree.xml
zenity --question --text="You need to log out and login for this changes have been applied\n<b>Do you want to close your session now?</b>"
if [ $? -eq 1 ] ; then
exit 1
fi
pkill -KILL -u $USER
esac
