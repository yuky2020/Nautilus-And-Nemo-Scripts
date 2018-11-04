#!/bin/sh
##
## Nautilus
## SCRIPT: 00_lineLengths_1file_wc.sh
##                                 
## PURPOSE: Reads a file and shows the length of each line.
##
##          (Could include a prompt to ask for the maximum
##           number of lines to read --- for huge files.)
##
##          Uses 'wc'  and a while-read loop.
##          Less efficient than using awk, but the 'length' function 
##          of awk does not seem to count bytes in binary lines properly.
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor.
##
## HOW TO USE: In Nautilus, navigate to a (text) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010sep26
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

.................. START OF 'wc -c' OUTPUT ............................
" >  "$OUTFILE"


###############################################################
## Use a while-read loop to read the file and output the length
## of the lines (using 'wc -c'_ into the OUTFILE --- and print
## summary stats.
###############################################################

NUMLINS=0
TOTCHAR=0
MAXLEN=0
MINLEN=64000000
 
echo "Line#    Length" 
echo "-------- --------"

# cat "$1" |

while read LINE
do

    LINLEN=`echo "$LINE" | wc -c`
    LINLEN=`expr $LINLEN - 1`

    if test $LINLEN -lt $MINLEN
    then
	MINLEN=$LINLEN
    fi

    if test $LINLEN -gt $MAXLEN
    then
	MAXLEN=$LINLEN
    fi

    NUMLINS=`expr $NUMLINS + 1`
    TOTCHAR=`expr $TOTCHAR + $LINLEN`

    # echo "$NUMLINS    $LINLEN" >> "$OUTFILE"
    echo "$NUMLINS    $LINLEN" | awk '{printf ("%8d %8d \n", $1 , $2);}' >> "$OUTFILE"

    ## FOR TESTING:
    #   print $LINE

done < "$1"
## END OF LOOP

###############################
## Add a trailer to the listing.
###############################

# CHARPERREC=`expr $TOTCHAR / $NUMLINS`

CHARPERREC=`echo "scale = 4; $TOTCHAR / $NUMLINS" | bc -l`

echo "
.................. END OF 'wc -c' OUTPUT ............................

Max Record Length (bytes) = $MAXLEN 

Min Record Length (bytes) = $MINLEN

Number of Records Read    = $NUMLINS 

Ave. Chars per Recs Read  = $CHARPERREC

.....................................................................

The output above is from script

$0

This script uses a while-read loop that is slow compared to
using the 'awk' version of this script. Use the 'awk' version on
text files. On binary files, the 'awk' version gives improper
line lengths for lines containing non-ASCII binary data, if
LC_ALL=C is not used.

.................... `date '+%Y %b %d  %a  %T%p %Z'` ..........................
" >> "$OUTFILE"


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

