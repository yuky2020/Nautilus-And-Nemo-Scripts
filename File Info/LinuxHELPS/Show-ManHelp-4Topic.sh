#!/bin/sh
##
## Nautilus
## SCRIPT: 00_show_manhelp_4topic.sh
##
## PURPOSE: This script prompts the user for a name and looks
##          for man help for that name.
##              Shows the help with an editor, or whatever GUI
##              text display program the user puts below.
##
## HOW TO USE: Right-click on any file in a Nautilus directory list
##             and select this Nautilus script to run (name above).
##
## Created: 2010apr04
## Changed: 2010may17 Use 'xpg' instead of 'gedit' to show/search/extract the text.

## FOR TESTING:
#  set -v
#  set -x

#####################################
## Prompt for the utility/topic name.
#####################################

    UTIL_NAME="ls"
    UTIL_NAME=$(zenity --entry --title "Show 'man' help for a name/utility." \
           --text "Enter a name.  Examples:
    ls  OR  grep  OR  sed  OR  cut  OR  tr  OR  awk  OR  bash  OR  X OR
    find  OR  gnome-terminal  OR  xterm  OR  convert  OR  identify  OR
    mplayer  OR  vlc  OR  df  OR  du  OR  ps  OR  ifconfig  OR  netstat" \
                --entry-text "ls")

    if test "$UTIL_NAME" = ""
    then
       exit
    fi

############################################################
## Prep a temporary filename, to hold the manhelp text.
##      We put the outlist file in /tmp in case the user does
##      not have write-permission to the current directory
##      --- and because the manhelp often has nothing to do
##      with the current directory.
############################################################

  OUTFILE="/tmp/00_manhelp4_$UTIL_NAME.lis"
 
  if test -f "$OUTFILE"
  then
     rm -f "$OUTFILE"
  fi

##########################################
## Prepare the output (man help) listing.
##########################################

  echo "\
man help for '$UTIL_NAME' :
##########################
" > "$OUTFILE"

   #########################################################
   ## Use pipes 'zcat|groff|col' to format the man help text.
   #########################################################

   MANFILE=`man -w $UTIL_NAME`

   if test "$MANFILE" = ""
   then

       echo "***** man file for $UTIL_NAME not found. *****" >> "$OUTFILE"

   else

      # TERM="ansi-m"
      # export TERM


      ## On SGI-IRIX, 'pcat' with 'man -p' (and 'col' and 'ul') works.
      ##   CMD="pcat \`man -p $STRING | cut -d' ' -f2\` | col | ul -t dumb"

      ## On Mandriva 2007, 'groff -P -c' gets rid of color codes
      ## from the bz2-uncompressed man files.
      ## If '-P -c' stops working, use:   export GROFF_NO_SGR="yes"
      #   CMD="bzcat $MANFILE | /usr/bin/groff -t -Tascii -mandoc -P -c | col -b"

      ## On Ubuntu 2009 (9.10, Karmic), 'groff -P -c' gets rid of color codes
      ## from the gzip-uncompressed man files.
      ## If '-P -c' stops working, use:   export GROFF_NO_SGR="yes"
         zcat "$MANFILE" | /usr/bin/groff -t -Tascii -mandoc -P -c | col -b >> "$OUTFILE"

   fi

########################
## Show the man help.
########################
   
. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &

