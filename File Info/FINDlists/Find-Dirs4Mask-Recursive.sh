#!/bin/sh
##
## Nautilus
## SCRIPT: 00_finddirs4mask_recursive.sh
##
## PURPOSE: Finds all the DIRECTORY-names matching a user-specified mask,
##          under the current working directory, multiple levels, if any.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list. Then choose this Nautilus script (name above).
##
##        This utility will look for all filenames of DIRECTORIES
##        matching a user-specified 'mask' --- 
##        searching recursively under the 'current' directory,
##        that is, the directory in which the selected file lies.
##
## Created: 2010apr03
## Changed: 2010apr12 Touched up the comment statements. Changed
##                    the output file to go into the current working
##                    directory if the user has write-permission.
## Changed: 2010aug29 Added TXTVIEWER var.

## FOR TESTING:
#  set -v
#  set -x

######################################################################
## Prep a temporary filename, to hold the list of directory-names.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
######################################################################

CURDIR="`pwd`"
OUTFILE="00_dirs4mask_temp.lis"
if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi
 
if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################
## Prompt for the mask string, using zenity.
############################################

    MASK="*help*"
    MASK=$(zenity --entry --title "Filename MASK to use in finding DIRECTORIES." \
           --text "\
Enter a filename MASK for the DIRECTORIES search.
Examples:
    *help*  OR  *.d  OR  *blue*  OR  *.*  OR  a*  OR  .*  OR  *" \
           --entry-text "*help*")

    if test "$MASK" = ""
    then
       exit
    fi


############################################
## Put a heading in the OUTFILE.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
DIRECTORIES for mask '$MASK'
under directory
$CURDIR
.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"


#######################################################################
## Use 'find' to do the search for DIRECTORIES,
## recursively under the current directory.
#######################################################################

  find  . -type d -name "$MASK" -print | sort -k1 >> "$OUTFILE"


###########################
## Add report 'TRAILER'.
###########################

# BASENAME=`basename $0`
HOST_ID="`hostname`"

echo "
.........................  END OF 'find' OUTPUT  ........................

     The output above is from script

$0

     which ran the 'find' and 'sort' commands on host  $HOST_ID .

.............................................................................

The actual command used was

  find  . -type d -name "$MASK" -print | sort -k1 

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> $OUTFILE


########################################################
## Show the list of directory-names that match the mask.
#######################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &

