#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiRename_anigifFiles_aMMMxNNNtoXXXxYYY_ani.sh
##
## PURPOSE: Renames a set of animated GIF files with the suffix
##          '_aMMMxNNN.gif' (my old ani-gif file naming convention)
##          to '_XXXxYYY_ani.gif'.
##                  Uses ImageMagick 'identify' to
##                  get the ACTUAL x-y pixel-size of the file.
##
## Created: 2010mar14
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
  ##    Assumes one '.' in filename, at the extension.
  ##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "gif" 
  then 
     continue
     # exit
  fi

  ##
  ## Get and apply the filesize (XXXxYYY).
  ##

  FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`

  # FILEPREF=`echo "$FILENAME" | sed 's|\.gif$||'`

  ## Strip off suffix like _aMMMxNNN_yadayada.gif
    FILEPREF=`echo "$FILENAME" | sed 's|_a[0-9X][0-9X]*x[0-9Y][0-9Y]*.*\.gif$||'`


  mv "$FILENAME" "${FILEPREF}_${FILESIZE}_ani.gif"

done


