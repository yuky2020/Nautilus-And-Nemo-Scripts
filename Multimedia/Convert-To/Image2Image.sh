#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiConvert_pngORgifFiles_TOjpg.sh
##
## PURPOSE: Converts a selected set of '.png' and/or '.gif' files
##          to '.jpg' files. Uses ImageMagick 'convert'.
##
## Created: 2010feb18
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
## START THE LOOP on the filenames.
##

for FILENAME in $FILENAMES
do

  ##
  ## Get and check that the file extension is 'png' or 'gif'.
  ## Assumes one dot (.) in the filename, at the extension.

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
  then
     continue 
     #  exit
  fi


  ##
  ## Use 'convert' to make the 'jpg' file --- high-quality (near lossless).
  ##

  FILENAMECROP=`echo "$FILENAME" | sed 's|\.png$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`
   
  convert "$FILENAME" -quality 100 "${FILENAMECROP}.jpg"

done




