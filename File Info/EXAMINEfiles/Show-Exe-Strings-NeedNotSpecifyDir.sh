#!/bin/sh
##
## Nautilus
## SCRIPT: 00_show_exe_strings_fromAnyDir.sh
##
## PURPOSE: Shows the human-readable strings in an executable file,
##          using the 'strings' command.
##
##          This script uses a zenity prompt for an executable name
##          and then uses the 'which' or 'whereis' command to get the
##          fully-qualified name of the executable file. Then
##          'strings' is applied to that full filename.
##
## HOW TO USE: In Nautilus, navigate to any directory, any file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010apr11
## Changed: 

## FOR TESTING:
# set -v
# set -x

#################################
## Prompt for the executable name.
#################################

    EXENAME=""
    EXENAME=$(zenity --entry --title "Show strings in an executable." \
           --text "\
Enter an executable name.
    If the name begins with '/', it is assumed that you gave the fully qualified
    name. The command 'strings' will be executed on that filename.
    Otherwise, 'which' is used to try to get the full filename. ('whereis' is
    tried if 'which' fails.)
        NOTE: If the executable is a script, all the text in the script is shown." \
                --entry-text "/usr/bin/nautilus")

    if test "$EXENAME" = ""
    then
       exit
    fi

###############################################
## Check for '/' in the first char of $EXENAME.
###############################################

## FOR TESTING:
# set -v
# set -x

FIRSTCHAR=`echo "$EXENAME" | cut -c1`

if ! test "$FIRSTCHAR" = "/"
then
   EXENAME_FULL=`which "$EXENAME"`
   FIRSTCHAR=`echo "$EXENAME_FULL" | cut -c1`
   if ! test "$FIRSTCHAR" = "/"
   then
      EXENAME_FULL=`whereis "$EXENAME" | awk '{print $2}'`
      FIRSTCHAR=`echo "$EXENAME_FULL" | cut -c1`
      if ! test "$FIRSTCHAR" = "/"
      then
         exit
      fi
   fi
else
   EXENAME_FULL="$EXENAME"
fi


#######################################################
## Check that the specified file is an executable file.
#######################################################

## FOR TESTING:
# set -v
  set -x

  FILECHECK=`file "$EXENAME_FULL" | egrep 'executable|link'`
 
  if test "$FILECHECK" = ""
  then
     exit
  fi


#######################################
## Initialize the output file.
##
## NOTE: If the executable file is in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
#######################################
CURDIR="`pwd`"
OUTFILE="00_temp_strings4exe.txt"
if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then 
   rm -f "$OUTFILE"
fi

#######################################
## Generate the list, with heading.
#######################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
STRINGS in the executable
  $EXENAME_FULL

.................. START OF 'strings' OUTPUT ............................
" >  "$OUTFILE"

strings "$EXENAME_FULL" >> "$OUTFILE"


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
NOTE1: Some alphanumeric characters and punctuation may be shown that are
       actually strings of binary codes in the file that just happened to
       correspond to the ASCII codes for alphanumeric and punctuation characters.

NOTE2: You can use a hex-editor like 'bless' to examine the hex and ASCII
       strings in the file more thoroughly.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> $OUTFILE


############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



