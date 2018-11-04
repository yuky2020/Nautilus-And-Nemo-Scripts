#!/bin/sh
##
## Nautilus
## SCRIPT: 00_findSTR_in_dirTEXTFILS_recursive.sh
##
## PURPOSE: Finds all files, at all levels under the current directory,
##          that contain a user-specified string. Uses the 'find' command and
##          a separate utility script that uses 'grep' and skips files that
##          are not text-type files, that is skipping binary files (executables,
##          image files, audio files, video files, etc.).
##               Ref: page 132 of QUE Unix Shell Commands Quick Reference.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus
##             directory list. Then choose this Nautilus script (name above).
##
## Created: 2010apr12 For Linux (Ubuntu). Based on a 1993 script for IBM AIX
##                    which was updated in 1995,1997,1999 for SGI IRIX.
## Changed: 2010aug29 Touched up zenity heading and text. Added TXTVIEWER var.

## $1 should be 'quiet' or 'noquiet'.
QUIET="$1"

## FOR TESTING:  (turn ON display of executed-statements)
#  set -x

######################################################################
## Prep a temporary filename, to hold the list of filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
##   Changed this. If the output file goes in the current directory,
##   the output file is found as one of the files containing the string.
##   So this always put the output file in the /tmp directory.
######################################################################

CURDIR="`pwd`"

## OUTFILE="00_filesCONTAININGstring_temp.lis"
## if test ! -w "$CURDIR"
## then
##  OUTFILE="/tmp/$OUTFILE"
## fi

OUTFILE="/tmp/00_filesCONTAININGstring_temp.lis"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


######################################################################
## Exit if the current directory is the root (/) or /usr directory.
######################################################################

if test \( "$CURDIR" = "/" -o "$CURDIR" = "/usr" \)
then
    zenity --question --title "Exiting!" \
           --text "\
Very many directory levels under $CURDIR.
This search Search could take many minutes.
Cancel or OK (Go)?"

  if test $? = 0
  then
     ANS="Yes"
  else
     ANS="No"
  fi

  if test "$ANS"= "No"
  then
     exit
  fi

fi

##############################################
## Prompt for the search string, using zenity.
##############################################

    STRING=""
    STRING=$(zenity --entry --title "STRING for search of the text files." \
           --text "\
Enter a STRING for the (Case-INsensitive) search of TEXT-FILES.
Examples:
      awk  OR  sed  OR  sort  OR  break  OR  sugar  OR  <body  OR  zenity" \
           --entry-text "awk")

    if test "$STRING" = ""
    then
       exit
    fi


############################################
## Put a heading in the OUTFILE.
############################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

Text FILES containing the STRING '$STRING'
under directory
  $CURDIR


OUTPUT FORMAT:

filename   :
line# : line-image
(one or more line# lines)

filename   :
line# : line-image
(one or more line# lines)

etc. etc.

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"


#######################################################################
## Use 'find' to do the search for DIRECTORIES,
## recursively under the current directory.
#######################################################################

find . -follow -type f \
  -exec ~/.gnome2/nemo-scripts/"File Info"/FINDlists/.chk4textfile.sh $QUIET "$STRING" {} \; >> $OUTFILE

# find . -follow -type f \
#      -exec grep -ni "$STRING" {} \; >> $OUTFILE


###########################
## Add report 'TRAILER'.
###########################

# BASENAME=`basename $0`
HOST_ID="`hostname`"

echo "
.........................  END OF 'find' OUTPUT  ........................

     The output above is from script

$0

     which ran the 'find' and 'grep' commands on host  $HOST_ID .

.............................................................................

The actual command used was

find . -follow -type f  \\
     -exec ~/.gnome2/nemo-scripts/"File Info"/FINDlists/.chk4textfile.sh "$STRING" {} \;

where the '.chk4textfile.sh' script checks that the file is a text-type file,
before using grep to find the lines in the file that contain the string.

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> $OUTFILE


########################################################
## Show the list of directory-names that match the mask.
#######################################################

## FOR TESTING:  (turn ON display of executed-statements)
#   set -x

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

VIEWERBASE=`basename "$TXTVIEWER"`
if test "$VIEWERBASE" = "xpg"
then
   $TXTVIEWER -f "$OUTFILE"
else
   $TXTVIEWER "$OUTFILE"
fi
