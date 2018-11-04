#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 00_findstr_in_dirfils_1lev_mask.sh
##                            
## PURPOSE: Finds all files, under the current directory, whose filenames
##          satisfy a user-specified mask and that contain a user-specified
##          string. Uses the 'grep' command on the filtered files.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list. Then choose this Nautilus script (name above).
##
## Created: 2010may17
## Changed: 2010

## FOR TESTING:
#  set -v
#  set -x

######################################################################
## Prep a temporary filename, to hold the list of filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
##   Changed this. If the output file goes in the current directory,
##   the output file is found as one of the files containing the string.
##   So this always puts the output file in the /tmp directory.
######################################################################

CURDIR="`pwd`"

## OUTFILE="00_filesCONTAININGstring_temp.lis"
## if test ! -w "$CURDIR"
## then
##   OUTFILE="/tmp/$OUTFILE"
## fi

OUTFILE="/tmp/00_filesCONTAININGstring_temp.lis"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


######################################################################
## Enter a mask for the (text) files to be searched.
## Examples: *.sh *.html *.htm* *.txt
######################################################################

    MASK=""
    MASK=$(zenity --entry \
           --title "Enter a MASK to choose the TEXT files." \
           --text "\
Enter a MASK to determine the FILES search. Examples:
    *.sh  OR  *.html  OR  *.htm*  OR  *.txt  OR  *" \
           --entry-text "*")

    if test "$MASK" = ""
    then
       exit
    fi



##############################################
## Prompt for the search string, using zenity.
##############################################

    STRING=""
    STRING=$(zenity --entry \
           --title "Enter the STRING to search for." \
           --text "\
Enter a STRING for the (Case-INsensitive) FILES search. Examples:
 awk  OR  grep  OR  sed  OR  sort  OR  zenity  OR  <body  OR  <a  OR  sugar" \
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

FILES  matching MASK: $MASK

and containing the STRING: $STRING

under directory
  $CURDIR
(one level only)


FORMAT of the OUTPUT LINES:

filename : line# : line-image


.................... START OF 'grep' OUTPUT ......................
" > "$OUTFILE"



#######################################################################
## Use 'grep' to do the search on files matching the MASK,
## in the current directory.
##
## NOTE: We could add a zenity prompt to ask whether to
##       make the search case-sensitive or not.
#######################################################################

# grep -i "$STRING" $MASK >> $OUTFILE

## Tried this xterm, but it did not work. Need to check this out, later.
#  xterm -fg white -bg black -hold -e \

  grep -ni "$STRING" $MASK  >> $OUTFILE


###########################
## Add report 'TRAILER'.
###########################

SCRIPTDIRNAME=`dirname $0`
SCRIPTBASENAME=`basename $0`

HOST_ID="`hostname`"

echo "
.........................  END OF 'grep' OUTPUT  ........................

     The output above is from script

$SCRIPTBASENAME

     in directory

$SCRIPTDIRNAME

     which ran the 'grep' command on host  $HOST_ID .

.............................................................................

The actual command used was

grep -ni \"$STRING\" $MASK

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> $OUTFILE


########################################################
## Show the list of directory-names that match the mask.
#######################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &





