#!/bin/sh
##
## Nautilus
## SCRIPT: 00_lineLengths_1file_awk.sh
##                                 
## PURPOSE: Reads a file and shows the length of each line.
##
##          (Could include a prompt to ask for the maximum
##           number of lines to read --- for huge files.)
##
##          Uses 'awk'. Much more efficient than a while-read
##          loop in this script.
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor.
##
## HOW TO USE: In Nautilus, navigate to a (text) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010may27
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


#########################################################
## Initialize the output file.
##
## NOTE: If the files is in a directory for which the user
##       does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
## CHANGE: To avoid junking up curdir, we use /tmp.
#########################################################

OUTFILE="00_temp_lineLengths_1file.lis"

# if test ! -w "$CURDIR"
# then
  OUTFILE="/tmp/$OUTFILE"
# fi

if test -f  "$OUTFILE"
then
  rm -f "$OUTFILE"
fi

#######################################################
## Generate a header for the listing.
#######################################################

echo "\
.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................

LINE LENGTHS (and summary line length statistics)

for the file

  $FILENAME

in directory

  $CURDIR

.................. START OF 'awk' OUTPUT ............................
" >  "$OUTFILE"


#######################################################
## Use 'awk' to read the file and output the length
## of the lines into the OUTFILE --- and summary stats.
#######################################################

## Try to fix awk-'length' giving wrong results on binary 'lines'.
## Seems to work.
LC_ALL=C
export LC_ALL

awk 'BEGIN {
NUMLINS = 0;
TOTCHAR = 0;
MAXLEN = 0;
MINLEN = 64000000;
# printf ("\n"); 
printf ("Line#    Length\n"); 
printf ("-------- --------\n"); 
}
## END OF BEGIN
## START OF BODY
{
    LINLEN = length($0)

    if ( LINLEN < MINLEN ) {
	MINLEN = LINLEN
    };

    if ( LINLEN > MAXLEN ) {
	MAXLEN = LINLEN
    };

    NUMLINS += 1
    TOTCHAR += LINLEN

    printf ("%8d %8d \n", NR , LINLEN); 

    ## FOR TESTING:
    #   print $0

}
## END OF BODY
## START OF END
END {
 print ".....................................................................";
# print "\n";
# printf ("MAX/MIN line lengths OF THE RECORDS");
# print " ";
# printf ("in File: %s", FILENAME);
 print "";
 printf ("Max Record Length (bytes) = %s", MAXLEN); 
 print "\n";
 printf ("Min Record Length (bytes) = %s", MINLEN);
 print "\n";
 printf ("Number of Records Read    = %s", NUMLINS); 
 CHARPERREC = TOTCHAR / NUMLINS
 print "\n";
 printf ("Ave. Chars per Recs Read  = %s", CHARPERREC); 
 print "";
}' "$FILENAME" >> "$OUTFILE"


###############################
## Add a trailer to the listing.
###############################

echo "
.................. END OF 'awk' OUTPUT ............................

from script

$0
" >>  "$OUTFILE"

############################
## Show the list.
############################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &

exit
########################################################
## EXIT to avoid trying to execute the sample code below.
########################################################

######################################################
## The following code is an example in case we want to
## prompt for a start line and end line (using a
## GUI dialog prompt utility like 'zenity') so that we
## can simply give the counts for PART of a huge file.
#######################################################

nawk -v STARTLINE=$STARTLINE -v ENDLINE=$ENDLINE 'BEGIN {
NUMLINS = 0;
TOTCHAR = 0;
MAXLEN = 0;
MINLEN = 64000000;
printf ("\n\n"); 
printf ("Line#    Length\n"); 
printf ("-------- --------\n"); 
}

{
     if (NR < STARTLINE) continue; 
     if (NR > ENDLINE)   exit; 

    if ( length < MINLEN ) {
	MINLEN = length
    };

    if ( length > MAXLEN ) {
	MAXLEN = length
    };

    NUMLINS += 1
    TOTCHAR += length($0)

    LINLEN = length($0)
printf ("%8d %8d \n", NR , LINLEN); 

}

END {
 print ".....................................................................";
# print "\n";
# printf ("MAX/MIN line lengths OF THE RECORDS READ (#%d to #%d)", STARTLINE, ENDLINE);
# print " ";
# printf ("in File: %s", FILENAME);
 print "\n";
 printf ("Max Record Length (bytes) = %s", MAXLEN); 
 print "\n";
 printf ("Min Record Length (bytes) = %s", MINLEN);
 print "\n";
 printf ("Number of Records Read    = %s", NUMLINS); 
 CHARPERREC = TOTCHAR / NUMLINS
 print "\n";
 printf ("Ave. Num. of CharsPerRec  = %s", CHARPERREC); 
 print "\n";
}' $FILEIN

