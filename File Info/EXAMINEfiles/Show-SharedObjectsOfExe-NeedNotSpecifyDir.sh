#!/bin/sh
##
## Nautilus
## SCRIPT: 00_show_sharedObjectsOFexe_needNotSpecifyDir.sh
##
## PURPOSE: Shows the shared-objects (.so dynamic executable files)
##          that may be used by the user-specified executable file.
##          Uses the 'ldd' command.
##
##          This script uses a 'zenity' prompt for an executable name
##          and then, if the name does not start with '/', this script
##          uses the 'which' or 'whereis' command to (try to)
##          get the fully-qualified name of the executable file. Then
##          'ldd' is applied to that full filename.
##
## HOW TO USE: In Nautilus, navigate to any directory, any file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may25
## Changed: 

## FOR TESTING:
# set -v
# set -x

#################################
## Prompt for the executable name.
#################################

    EXENAME=""
    EXENAME=$(zenity --entry \
           --title "Show Shared-Objects of an executable." \
           --text "\
Enter an executable name.
    If the name begins with '/', it is assumed that you gave the
    fully qualified name. The command 'ldd' will be executed on that filename.
    Otherwise, 'which' is used to try to get the full filename. ('whereis'
    is tried if 'which' fails.)" \
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
         zenity --info --title "Not Found." \
           --text "Could not find full name of executable $EXENAME."
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


##########################################################
## Initialize the output file.
##
## NOTE: If the executable file is in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
##########################################################
CURDIR="`pwd`"
OUTFILE="00_temp_sharedObjects4exe.txt"
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

SHARED OBJECTS callable by the executable
  $EXENAME_FULL

.................. START OF 'ldd' OUTPUT ............................
" >  "$OUTFILE"

ldd "$EXENAME_FULL" >> "$OUTFILE"


###########################
## Add report 'TRAILER'.
###########################

# BASENAME=`basename $0`

echo "
.........................  END OF 'ldd' OUTPUT  ........................

     The output above is from script

$0

     which ran the 'ldd' command on host  $HOST_ID .

.............................................................................

NOTE1: You can use a hex-editor like 'bless' to examine the hex and ASCII
       strings in the executable more thoroughly.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &





