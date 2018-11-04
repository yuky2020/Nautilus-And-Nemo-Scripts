#!/bin/bash

getlist=$(
for i in $(seq 1 1 12)
do
cx=$(gconftool-2 -g /apps/metacity/keybinding_commands/command_$i)
if [ -z "$cx" ];then
cx="none"
fi

if [ "$i" -eq "1" ];then
statusc="TRUE"
fi
if [ "$i" -ne "1" ];then
statusc="FALSE"
fi

cmx="command_$i $cx $(gconftool-2 -g /apps/metacity/global_keybindings/run_command_$i)"
echo $statusc $cmx
done)

command=$(zenity --width=600 --height=400  --list --radiolist --title="View / Edit Keybindings" --text="Add or edit HotKey" --column "Pick" --column "Commandname" --column "Value"  --column "Shortcut" $getlist)

if [[ $? -eq 1 ]];then
exit
fi

if [[ $? -eq 0 ]];then
pkey=`zenity --file-selection --save --title="Choose file"`
case $? in
0)
gconftool-2 -t string -s /apps/metacity/keybinding_commands/$command "$pkey"
zenity --info  --width 170 --title "Application Hot Key"  --text "OK, you can create shortcut now"
hkey=$(zenity --entry --text "Create Hot-Key (e.g. <Control>Q) and start using CTRL+Q" --entry-text "" --title "SET your Hot-Key")
gconftool-2 -t string -s /apps/metacity/global_keybindings/run_$command "$hkey"
;;
1)
gconftool-2 -t string -s /apps/metacity/keybinding_commands/$command ""
gconftool-2 -t string -s /apps/metacity/global_keybindings/run_$command "disabled"
exit 1;;
-1)
exit 1;;
esac
fi

