#!/bin/sh
##
## SCRIPT: 00_list_allOfDirFiles_recursive.sh
##
## PURPOSE: List ALL files in a directory AND in its
##          subdirectories at ALL levels below ---
##          and show the list in an editor of your choice.
##
## HOW TO USE: In Nautilus, select any file in the directory. Then
##             right-click and choose this Nautilus script to run.
##
## Created: 2010mar17
## Changed: 2010apr11 Touched up the comments. Added logic to
##                    determine the directory for the OUTFILE.
## Changed: 2010sep16 Added header and trailer to listing.

## FOR TESTING:
# set -v
# set -x

#################################################
## Prepare the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
#################################################

CURDIR="`pwd`"

OUTFILE="00_temp_dirAllFilesRecursiveLIST.txt"
if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the list.
#####################################

DATETIME=`date '+%Y %b %d  %a  %T%p'`

echo "\
..................... $DATETIME ............................

Current directory: $CURDIR

List of files (and directories) there-under follows.

...........................................................................
" >  "$OUTFILE"


######################
## Generate the list.
######################

# ls -alR  > "$OUTFILE"
# ls -aR  > "$OUTFILE"
# find . -type f -name '*' -print |  sort >> "$OUTFILE"
find . -name '*' -print |  sort >> "$OUTFILE"


#####################################
## Generate a trailer for the list.
#####################################
BASENAME=`basename $0`
DIRNAME=`dirname $0`

echo "\
...........................................................................
 
This list was generated by script
   $BASENAME
in directory
   $DIRNAME

Used command

     find .  -name '*' -print |  sort

..................... $DATETIME ............................
" >>  "$OUTFILE"


######################
## Show the list.
######################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &


