#!/bin/sh
##
## Nautilus
## SCRIPT: grep02_regexpMatchLines_egrep1file.sh
##
## PURPOSE: Show the lines of a file matching a user-specified
##          string or regular expression, using 'egrep'.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## NOTE: Uses a 'zenity' prompt for the string or regular expression.
##
## Created: 2010may25
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
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


#######################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
#######################################

  OUTFILE="00_temp_1file_egrepMatches.txt"
  if test ! -w "$CURDIR"
  then
     OUTFILE="/tmp/$OUTFILE"
  fi

  rm -f "$OUTFILE"

######################################################
## Prompt for the search string or regular expression.
######################################################

    STRING=""
    STRING=$(zenity --entry \
           --title "Enter a string or regular expression." \
           --text "\
Enter a string or regular expression, with which to 'egrep'-search file

     $FILENAME

in case-sensitive mode.

Examples: 
  'error|Error|ERROR'    [finds lines containing at least one of the 3 forms]

  'warning|error|fail'   [finds lines containing at least one of the 3 words]

  'if|elif|else|fi'      [finds the lines in a script containing if,elif,else, or fi]

  'cut|tr|sed|awk|grep'  [finds the lines in a script containing cut,tr,sed,awk, or grep]

  '{|}'                  [finds the lines that contain left or right brace,
                               say in a Tcl-Tk script]

Do not use the single quotes at the start and end of the examples." \
           --entry-text "for|each|do|done")

    if test "$STRING" = ""
    then
       exit
    fi

##########################################
## Generate the grep output, with heading.
##########################################

HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINES CONTAINING THE STRING OR REGULAR EXPRESSION
  '$STRING'
IN THE FILE
  $FILENAME

.................. START OF 'egrep' OUTPUT ............................
" >  "$OUTFILE"

## Get the numChars in the string $BASENAME.
##
#BASENAME=`basename "$FILENAME"`
#FLEN=`echo "$BASENAME" | wc -c | cut -d' ' -f2`

## Find the matches to the reg-exp in $STRING, and
## remove the filename from the front of each egrep output line,
## leaving the linenumber and an image of the line.
##
# eval egrep -n '$STRING' \"$FILENAME\" | cut -c$FLEN- >> $OUTFILE 2>&1

## The stuff above might be needed if we try to egrep multiple files.


egrep -n "$STRING" "$FILENAME"  >> $OUTFILE 2>&1


##############
## ADD Trailer
##############

echo "\
.................. END OF 'egrep' OUTPUT ............................

from script

$0
" >>  "$OUTFILE"

############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



