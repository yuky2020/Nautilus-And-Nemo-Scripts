#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 00_findSTR_in_dirMASKFILS_recursive.sh
##                            
## PURPOSE: Finds all files, at all levels under the current directory,
##          for a given mask --- such as *.htm* or *.txt or *.sh ---
##          that contain a user-specified string. Uses the 'find' command and
##          a separate utility script that uses 'grep' and skips files that
##          are not text-type files, that is skipping binary files (executables,
##          image files, audio files, video files, etc.).
##               Ref: page 132 of QUE Unix Shell Commands Quick Reference.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list. Then choose this Nautilus script (name above).
##
## Created: 2010aug29 For Linux (Ubuntu). My mask-less script
##                    00_findstr_in_dirfils_recursive.sh
## Changed: 2010

## FOR TESTING:
#  set -v
#  set -x

######################################################################
## Prep a temporary filename, to hold the list of filenames.
## If the user does not have write-permission to the current directory,
## put the list in the /tmp directory.
############
##   CHANGED this. If the output file goes in the current directory,
##   the output file is found as one of the files containing the string.
##   So the output file is always put in the /tmp directory.
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
## Prompt for the file mask, using zenity.
##############################################

    MASK=""
    MASK=$(zenity --entry --title "MASK for the (text) filenames to search." \
           --text "\
Enter a MASK for the filenames to search.
Examples:  *.htm*  OR  *.txt  OR  *.sh  OR  *.tcl  OR   *.tk" \
           --entry-text "*.htm*")

    if test "$MASK" = ""
    then
       exit
    fi


##############################################
## Prompt for the search string, using zenity.
##############################################

    STRING=""
    STRING=$(zenity --entry --title "STRING to search for in the files." \
           --text "\
Enter a STRING for the (Case-INsensitive) search of the FILES
whose names match the mask '$MASK'.
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

FILES matching the filename MASK  $MASK
and containing the STRING '$STRING'
under directory
  $CURDIR


FORMAT of each line:

filename   : line# : line-image

.................... START OF 'find' OUTPUT ......................
" > "$OUTFILE"



#######################################################################
## Use 'find' to do the search for DIRECTORIES,
## recursively under the current directory.
#######################################################################

## FOR TESTING: (show cmds being executed, after var substitution)
#  set -x

## In the following 'find' command(s),
## '-follow' says to go to the link target, if the file is a link.

MASK="'${MASK}'"

## FOR TESTING:
# find . -follow -type f -print >> $OUTFILE

## FOR TESTING: (eval WORKS ; gets the filenames to print)
# eval  find . -follow -type f -name $MASK  -print >> $OUTFILE

## THE REAL DEAL: (after escaping the double-quotes and triple-escaping the semicolon!!!)
eval find . -follow -type f -name $MASK  \
            -exec grep -niH \"$STRING\" {} \\\; >> $OUTFILE


## FOR TESTING: (resets 'set -x', .i.e. no longer show cmds executed)
#  set -

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

The actual command used was something like

find . -follow -type f  -name $MASK \\
       -exec grep -niH \"$STRING\" {} ;

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


########################################################
## Show the list of directory-names that match the mask.
#######################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &






