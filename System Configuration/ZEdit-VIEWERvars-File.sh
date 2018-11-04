#!/bin/sh
##
## Nautilus
## SCRIPT: edit_VIEWERvarsFile.sh
##
## PURPOSE: This script prompts the user for a text editor to use
##          and puts the user in edit mode on the FE Nautilus Scripts
##          env var setting script '.set_VIEWERvars.shi'.
##
## HOW TO USE: Double-click on this script file in the 'nemo-scripts'
##             directory.
##
## Created: 2010sep06
## Changed: 2010

## FOR TESTING:
#  set -v
#  set -x

#####################################
## Prompt for the utility/topic name.
#####################################

if test -f /usr/bin/zenity
then

   NS_EDITOR="gedit"
   NS_EDITOR=$(zenity --entry \
        --title "EDITOR to use on the FE-NS vars-setting file." \
        --text "\
Enter an editor name --- and use it to edit the FE Nautilus Scripts
variables-setting file.  Examples:
  gedit  OR   /usr/bin/gedit   OR   kwrite  OR  /usr/bin/kwrite  OR
  nedit  OR   /usr/bin/nedit   OR   mousepad  OR  /usr/bin/mousepad
"       --entry-text "/usr/bin/gedit")

   if test "$NS_EDITOR" = ""
   then
      exit
   fi

elif -f /usr/bin/gedit
then
   NS_EDITOR="/usr/bin/gedit"

elif -f /usr/bin/kwrite
then
   NS_EDITOR="/usr/bin/kwrite"

elif -f /usr/bin/kate
then
   NS_EDITOR="/usr/bin/kate"

elif -f /usr/bin/mousepad
then
   NS_EDITOR="/usr/bin/mousepad"

elif -f /usr/bin/leafpad
then
   NS_EDITOR="/usr/bin/leafpad"

elif -f /usr/bin/nedit
then
   NS_EDITOR="/usr/bin/nedit"

else
   echo "Could not find a GUI text editor. Exiting."
   exit
fi
## END OF if test -f /usr/bin/zenity


##############################################
## Apply the editor to the FE Nautilus Scripts
## var-setting 'shell include' file.
##############################################

$NS_EDITOR $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi


