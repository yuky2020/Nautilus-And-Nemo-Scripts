#!/bin/sh
##
## Nautilus
## SCRIPT: 00_show_fil_with_XPG.sh
##
## PURPOSE: Shows selected file(s) [in a directory] using
##          FE system 'xpg' Tcl-Tk text-browser utility.
##
## HOW TO USE: In Nautilus, navigate to a file(s), select it/them,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010apr11
## Changed: 2010aug27 Chgd directory of xpg script.

## FOR TESTING:
# set -v
# set -x

###########################################
## Get the filename(s).
###########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
  FILENAMES="$@"
# FILENAME="$1"


#############################################
## Show the file(s).
##
## NOTE: The xpg wrapper script is written to
##       show up to 8 files.
#############################################

# XPG="$HOME/apps/feXpg_yyyymmmdd/scripts/xpg"
  XPG="$HOME/apps/feXpg/scripts/xpg"

## $XPG  "$FILENAME"
   $XPG  "$FILENAMES"




