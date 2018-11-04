#!/bin/sh
##
## Nautilus
## SCRIPT: 00_findSTR_in_dirTEXTFILS_recursive.sh
##
## PURPOSE: This is a 'wrapper' script that starts script
##               .findSTR_in_dirTEXTFILS_recursive.sh
##          in an 'xterm' --- so that that script can show
##          progress indicators (filenames) in the xterm.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus
##             directory list. Then choose this Nautilus script (name above).
##
## Created: 2010sep19 As a 'wrapper' script to start script
##                    '.findSTR_in_dirTEXTFILS_recursive.sh' in an xterm.
## Changed: 2010

## FOR TESTING: (turn ON display of executed-statements)
#  set -x

######################################################################
## Ask user whether a 'progress window' is wanted.
######################################################################

ANS=$(zenity --list --radiolist \
             --title "Progress Window" \
             --text "\
If this is a 'deep' directory, you may want
a 'Progress Window' to let you know how the
'find' is progressing.

Progress Window - Yes, No, Cancel?" \
             --column "" --column "" \
            Yes Yes No No)

## FOR TESTING: (turn ON display of executed-statements)
#   set -x

if test "$ANS" = ""
then
   exit
fi

if test "$ANS" = "Yes"
then

   xterm -T "Progress Window for Find-String-In-Text-Files (recursive)" \
         -bg black -fg white -hold -geometry 80x40+0+25 -sb -leftbar -sl 1000 \
         -e ~/.gnome2/nemo-scripts/"File Info"/FINDlists/.findSTR_in_dirTEXTFILS_recursive.sh noquiet
else
   ~/.gnome2/nemo-scripts/"File Info"/FINDlists/.findSTR_in_dirTEXTFILS_recursive.sh quiet
fi
