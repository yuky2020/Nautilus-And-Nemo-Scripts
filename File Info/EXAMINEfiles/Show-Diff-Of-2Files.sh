#!/bin/sh
##
## Nautilus
## SCRIPT: 00_show_DIFF_of2files.sh
##
## PURPOSE: For two selected files [in a directory],
##          shows the differences in the two
##          files using the 'diff' command.
##
## HOW TO USE: In Nautilus, navigate to a directory and select 2 files,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010apr11
## Changed: 

## FOR TESTING:
# set -v
# set -x

####################################
## Get the 2 filenames.
####################################

FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

## FOR TESTING:
# xterm -hold -e echo "$FILENAMES"
#
# NUMFILES=`echo "$FILENAMES" | wc -l`
# xterm -hold -e echo "$NUMFILES"

if test ! `echo "$FILENAMES" | wc -l` = 3
then
   exit
fi

FILENAM1=`echo "$FILENAMES" | head -1`
FILENAM2=`echo "$FILENAMES" | head -2 | tail -1`

## FOR TESTING:
#  xterm -hold -e echo "$FILENAM1 $FILENAM2"

## ALTERNATIVE WAYS of getting the 2 filenames:

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"

# FILENAMES="$@"

#  FILENAM1="$1"
#  FILENAM2="$2"

####################################
## Get the current working directory.
####################################

#  CURDIR="$NAUTILUS_SCRIPT_CURRENT_URI"
   CURDIR="`pwd`"

################################################
## Check that the 2 selected files are 'text' files,
## i.e. NOT 'binary' files.
################################################

  FILECHECK=`file "$FILENAM1" | grep 'text'`
 
  if test "$FILECHECK" = ""
  then
     exit
  fi

  FILECHECK=`file "$FILENAM2" | grep 'text'`
 
  if test "$FILECHECK" = ""
  then
     exit
  fi


######################################
## Initialize the output file.
##
## NOTE: If the two files are in a directory
##       for which the user does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
######################################

OUTFILE="00_temp_diff_of2files.lis"
if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f  "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

#####################################
## Generate the list, with heading.
#####################################

HOST_ID="`hostname`"
BASENAM1=`basename "$FILENAM1"`
BASENAM2=`basename "$FILENAM2"`

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
DIFFERENCES in the two files
  $BASENAM1
and
  $BASENAM2
in directory
  $CURDIR
................... START OF 'diff' ................................
" >  "$OUTFILE"

diff "$FILENAM1" "$FILENAM2" >> "$OUTFILE"


##################################
## Add report 'TRAILER'.
##################################

# BASENAME=`basename $0`

echo "
.........................  END OF 'diff'  ........................

     The output above is from script

$0

     which ran the 'diff' command on host  $HOST_ID .

.............................................................................
NOTE1: You can see the 'man' help on 'diff' to see a description of
       the formatting of the 'diff' report.

NOTE2: You can use a GUI alternative to 'diff' to see some other
       ways of presenting the differences. Example: 'tkdiff'
       ('xdiff' is available on some Unix OSes.)

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> $OUTFILE


###################################
## Show the list.
###################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



