#!/bin/sh
##
## Nautilus
## SCRIPT: 00_findfils4type_recursive.sh
##
## PURPOSE: Finds ALL the files (non-directory) whose file-type matches
##          a user-specified mask --- ALL files under the current Nautilus
##          working directory, multiple levels, if any.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list. Then choose this Nautilus script (name above).
##
##        This utility will look for all files matching a user-specified
##        'type' --- searching recursively under the 'current' directory,
##         that is, the directory in which the selected file lies.
##
##        The valid 'types' are strings that are returned when the 'file'
##        command is applied to a file. Example: 'ASCII HTML document text'
##        In this case, the user might simply specify 'HTML' or 'text' or
##        'ASCII' for the mask, depending on what he/she is looking for.
##
## Created: 2010apr03
## Changed: 2010apr12 Touched up the comment statements. Changed
##                    the output file to go into the current working
##                    directory if the user has write-permission.
## Changed: 2010aug29 Added TXTVIEWER var.

## FOR TESTING:
#  set -v
#  set -x


####################################################################
## Prep a temporary filename, to hold the list of regular-filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
####################################################################

CURDIR="`pwd`"
OUTFILE="00_files4type_temp.lis"
if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/00_files4type_temp.lis"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


###############################################
## Prompt for the file-type string, using zenity.
###############################################

    FILETYPE="text"
    FILETYPE=$(zenity --entry --title "Enter a fileTYPE string to find such FILES." \
           --text "\
Enter a TYPE (sub)string for the regular-file search.
Examples:

  for TEXT files:     'text'  OR  'ascii text'  OR  'c program text'  OR  'English text'
                  OR  'commands text'           OR  'c program text with garbage'
  for EXECUTABLES:    'executable'  OR  'ELF 32-bit LSB executable'
                  OR  'POSIX shell script text executable'
  for binary DATA:    'data'  OR  'image'  OR   'GIF'  OR  'JPEG'
                  OR  'compressed'  OR  'compressed data'  OR  'tar'" \
          --entry-text "text")

    if test "$FILETYPE" = ""
    then
       exit
    fi


############################################
## Put a heading in the OUTFILE.
############################################

  echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
regular-FILES of type '$FILETYPE'
under directory
`pwd`
.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"


########################################################################
## Use 'find' to do the search, recursively under the current directory.
########################################################################

find . -type f -exec file {} \; | grep ":.*$FILETYPE" | sort -k1 >> "$OUTFILE"


###########################
## Add report 'TRAILER'.
###########################

# BASENAME=`basename $0`
HOST_ID="`hostname`"

echo "
.........................  END OF 'find' OUTPUT  ........................

     The output above is from script

$0

     which ran the 'find', 'file', 'grep', and 'sort' commands on host  $HOST_ID .

.............................................................................

The actual command used was

    find . -type f -exec file {} \; | grep ":.*$FILETYPE" | sort -k1

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> $OUTFILE


##########################################################
## Show the list of regular-filenames that match the mask.
##########################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &

   
