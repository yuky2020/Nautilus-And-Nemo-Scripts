#!/bin/sh
##
## Nautilus
## SCRIPT: 00_show_exe_strings_exeInThisDir.sh
##
## PURPOSE: Shows the human-readable strings in an executable file,
##          using the 'strings' command.
##
## HOW TO USE: In Nautilus, navigate to an executable file, select it,
##             right-click and choose this Nautilus script to run.
##
## NOTE: Made another version of this script, to do a
##       'zenity' prompt for an executable name and, if the
##       file name is not fully qualified,
##       use the 'which' or 'whereis' command to get the
##       fully-qualified name of the executable file. Then
##       apply 'strings' to that full filename.
##
## Created: 2010apr11
## Changed: 

## FOR TESTING:
# set -v
# set -x

#######################################
## Get the filename.
#######################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# FILENAME="$@"
  FILENAME="$1"

#  CURDIR="$NAUTILUS_SCRIPT_CURRENT_URI"
   CURDIR="`pwd`"


#######################################################
## Check that the selected file is an executable file.
#######################################################

  FILECHECK=`file "$FILENAME" | grep 'executable'`
 
  if test "$FILECHECK" = ""
  then
     zenity --info --title "Exiting." \
           --text "The file $FILENAME' does not seem to be an executable."
     exit
  fi


##############################################################
## Initialize the output file.
##
## NOTE: Since the executable file is typically in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
#############################################################

  OUTFILE="/tmp/00_temp_strings4exe.txt"

  rm -f "$OUTFILE"


#######################################
## Generate the list, with heading.
#######################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
STRINGS in the executable
  $FILENAME
in directory
  $CURDIR
.................... START OF 'strings' OUTPUT ......................
" >  "$OUTFILE"

strings "$FILENAME" >> "$OUTFILE"


###########################
## Add report 'TRAILER'.
###########################

# BASENAME=`basename $0`

echo "




.........................  END OF 'strings' OUTPUT  ........................

     The output above is from script

$0

     which ran the 'strings' command on host  $HOST_ID .

.............................................................................
NOTE1: Some alphanumeric characters and punctuation may show that are
       actually strings of binary data in the file that just happened
       to correspond to the ASCII codes for such characters.

NOTE2: You can use a hex-editor like 'bless' to examine the hex and ASCII
       strings in the file more thoroughly.

NOTE3: If the executable is a script, all the lines will be shown (except
       the null/empty lines).

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



