#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiRename_anigifFiles_toXXXxYYY_ani.sh
##
## PURPOSE: Renames a set of animated '.gif' files to a suffix
##          of the form '_XXXxYYY_ani.gif'.
##             Uses the ImageMagick program 'identify' to get
##             the ACTUAL x-y pixel-size of the file.
##
## Created: feb2010
## Changed:

## FOR TESTING:
# set -v

##
## Get the filenames of the selected files.
##

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


##
## START THE LOOP on the filenames.
##

for FILENAME in "$FILENAMES"
do

  ##
  ## Get and check that file extension is 'gif'. 
  ##     Assumes one '.' in filename, at the extension.
  ##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "gif"
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

  FILEPREF=`echo "$FILENAME" | sed 's|\.gif$||'`


  ## Strip off suffix like _123...x123..._yadayada
  ##                    OR _XXXxYYY_yadayada
  ##                    OR _XXXx123..._yadayada

     FILEPREF=`echo "$FILEPREF" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*$||'`

  ## Rename

  mv "$FILENAME" "${FILEPREF}_${FILESIZE}_ani.gif"

done


