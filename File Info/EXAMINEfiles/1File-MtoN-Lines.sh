#!/bin/sh
##
## Nautilus
## SCRIPT: big01a_1file_MtoNlines.sh
##
## PURPOSE: Show the lines M to N of the user-selected file.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## NOTE: Uses 'zenity' to prompt for M and N.
##
## Created: 2010sep19
## Changed: 

## FOR TESTING:  (turn ON display of executed-statements)
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

########################################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
#######################################################

  OUTFILE="00_temp_MtoNlines.txt"
  if test ! -w "$CURDIR"
  then
     OUTFILE="/tmp/$OUTFILE"
  fi

  rm -f "$OUTFILE"


#################################
## Prompt for M and N.
#################################

CURDIRFOLD=`echo "$CURDIR" | fold -55`

MandN=""
MandN=$(zenity --entry \
           --title "Enter M-N." \
           --text "\
Enter M and N separated by a hyphen (i.e. minus sign).
Example: 170-355

Those lines of file

     $FILENAME

in directory

     $CURDIRFOLD

will be extracted into output file

     '$OUTFILE'." \
           --entry-text "200-500")

if test "$MandN" = ""
then
   exit
fi


## FOR TESTING:  (turn ON display of executed-statements)
# set -x

M=`echo "$MandN" | cut -d'-' -f1`
N=`echo "$MandN" | cut -d'-' -f2`

NM1=`expr 1 + $N - $M`

## FOR TESTING:  (turn OFF display of executed-statements)
# set -

#######################################
## Generate the head output.
#######################################

echo "\
Show lines $M through $N of file $FILENAME.
########################
" > "$OUTFILE"

head -$N "$FILENAME" | tail -$NM1 | nl -ba -v$M >> "$OUTFILE"


############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



