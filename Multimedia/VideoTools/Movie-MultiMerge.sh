#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiMerge_movieFiles_mencoder.sh
##
## PURPOSE: Merges several movies (of the same type) into
##          ONE movie, of that same type. Uses 'mencoder'.
##
## Reference: Linux Format Magazine #130, Apr 2010. p.104, Answers section.
##            for a sample mencoder command (for combining '.avi' files).
##
## Created: 2010apr17
## Changed:

## FOR TESTING:
# set -v
# set -x

##
## Get the filenames of the selected files.
##

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##
## LOOP thru the selected files.
## 1) Save the file extension of the first file.
## 2) Make sure they all have a common extension (type).
##        (May have to check for certain types, like 'avi',
##         supported by 'mencoder'.)
## 3) Save the 'middle-name' of the first file.

FILEEXT1=""
FILENAMECROP1=""

for FILENAME in $FILENAMES
do

  ## Get the file extension of the file.
  ##  (Assumes one dot (.) in the filename, at the extension.)
     FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  ##
  ## If the file extension has not been set yet in var FILEEXT1
  ## (i.e. for the first file), put the file extension
  ## into var FILEEXT1.

  if test "$FILEEXT1" = ""
  then
     FILEEXT1="$FILEEXT"
  fi

  if test "$FILEEXT" != "$FILEEXT1"
  then 

    JUNK=`zenity -- question --title "Merge Movies: EXITING" \
          --text "\
The movies do not seem to be all of the same type ---
they do not have a common file extension:

$FILENAMES

EXITING ...."`

     exit
  fi

  ##
  ## If the file 'middle-name' has not been set yet in var
  ## FILENAMECROP1 (i.e. for the first file),
  ## put the 'middlename' into into var FILENAMECROP1.
  ##  (Assumes one dot (.) in the filename, at the extension.)

  if test "$FILENAMECROP1" = ""
  then

     FILENAMECROP1=`echo "$FILENAME" | cut -d\. -f1`

  fi

done
## END OF looping thru the selected files.


##
## Prepare the output movie filename.
##
   
FILEOUT="${FILENAMECROP1}_merged.$FILEEXT1"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##
## Use 'mencoder' to merge the movies into one movie,
## of the same type.
##    '-forceidx' is used to build the index for the
##                   combined movie files.
##
## Reference: Linux Format Magazine #130, Apr 2010. p.104, Answers section.
##            for a sample mencoder command (for combining '.avi' files).

## FOR TESTING:
# xterm -hold -e \

mencoder -forceidx -oac copy -ovc copy -o "$FILEOUT" \
         $FILENAMES

##
## Show the new (combined) movie file.
##

if test ! -f "$FILEOUT"
then
   exit
fi

# xterm -fg white -bg black -hold -e vlc      "$FILEOUT"
# xterm -fg white -bg black -hold -e mplayer  "$FILEOUT"
  xterm -fg white -bg black -hold -e /usr/bin/ffplay -stats "$FILEOUT"

