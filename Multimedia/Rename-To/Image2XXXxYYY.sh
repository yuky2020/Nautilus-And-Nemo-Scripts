#!/bin/sh
##
## Nautilus
## SCRIPT: 03_multiRename_jpgORpngORgifFiles_toXXXxYYY.sh
##
## PURPOSE: Renames a set of selected image files ('.jpg' or '.png' or
##          '.gif') to contain the x-y pixel-size of the file. 
##          Example: joe.jpg  to  joe_640x480.jpg
##
## Created: feb2010
## Changed:

## FOR TESTING:
#  set -v
#  set -x

##
## Get the filenames of the selected files.
##

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##
## START THE LOOP on the filenames.
##

for FILENAME in $FILENAMES
do

  ##
  ## Get and check that file extension is 'jpg' or 'png' or 'gif'. 
  ##     Assumes one '.' in filename, at the extension.
  ##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
  then 
     continue
     # exit
  fi

  ##
  ## Get filesize (XXXxYYY).
  ##

  FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`

  ##
  ## Get file prefix (strip extension).
  ##

  if test "$FILEEXT" = "jpg"
  then
    FILEPREF=`echo "$FILENAME" | sed 's|\.jpg$||'`
  fi

  if test "$FILEEXT" = "png"
  then
    FILEPREF=`echo "$FILENAME" | sed 's|\.png$||'`
  fi

  if test "$FILEEXT" = "gif"
  then
    FILEPREF=`echo "$FILENAME" | sed 's|\.gif$||'`
  fi

  ## Strip off suffix like _123...x123..._yadayada
  ##                    OR _XXXxYYY_yadayada
  ##                    OR _XXXx123..._yadayada

  FILEPREF=`echo "$FILEPREF" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*$||'`

  ## Rename

  mv "$FILENAME" "${FILEPREF}_${FILESIZE}.$FILEEXT"

done


