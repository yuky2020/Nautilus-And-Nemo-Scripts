#!/bin/sh
##
## Nautilus
## SCRIPT: grep01_regexpMatchLines_grep1file.sh
##
## PURPOSE: Show the lines of a file matching a user-specified
##          string or regular expression, using 'grep' (not 'egrep').
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

  OUTFILE="00_temp_1file_matchLines.txt"
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
Enter a string or regular expression, with which to 'grep'-search file

     $FILENAME

Examples:
 '^From \- '       [finds 'From -' lines in a mail file, 'From' starting in col 1.]

 '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*'     [finds lines with IP address]

 '^$'              [finds empty lines in a file]

 '[\\\t ]*#'         [finds lines that start with zero or more spaces/tabs and '#'
                      --- shows essentially all the comment lines of a script]

 '^Received: from .*\(\['    [finds Received-from lines of a mail file with IPaddress.]

Do not use the single quotes at the start and end of the examples." \
           --entry-text "^$")

    if test "$STRING" = ""
    then
       exit
    fi

##########################################
## Generate the grep output, with heading.
##########################################

# HOST_ID="`hostname`"

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINES CONTAINING THE STRING OR REGULAR EXPRESSION
  '$STRING'
IN THE FILE
  $FILENAME

.................. START OF 'grep' OUTPUT ............................
" >  "$OUTFILE"

grep -n "$STRING" "$FILENAME"  >> $OUTFILE 2>&1

## An example of how to cut the filname from the front of output lines,
## if needed.
# FLEN=`echo "$FILENAME" | wc -c | cut -d' ' -f2`
# grep -n "$STRING" "$FILENAME" | cut -b$FLEN- >> $OUTFILE 2>&1


echo "\
.................. END OF 'grep' OUTPUT ............................

from script

$0
" >>  "$OUTFILE"

############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



