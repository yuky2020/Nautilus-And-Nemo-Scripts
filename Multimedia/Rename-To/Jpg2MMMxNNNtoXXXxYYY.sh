#!/bin/sh
##
## Nautilus
## SCRIPT: 05_multiRename_jpgFiles_MMMxNNNtoXXXxYYY.sh
##
## PURPOSE: Renames a set of selected '.jpg' files. Looks for
##          a string of the form MMMxNNN in the filename to change it
##          to the ACTUAL XXXxYYY pixel-size of the file.
##             Example: joe_1024x768_EDITme.jpg  to  joe_997x723.jpg
##          Uses ImageMagick 'identify' and 'convert'.
##
## Created: 2010feb17
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
  ## Get and check that file extension is 'jpg'. 
  ## Assumes one '.' in filename, at the extension.
  ##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "jpg" 
  then 
     continue
     # exit
  fi

  ##
  ## Get and apply the filesize (XXXxYYY).
  ##

  FILESIZE=`identify "$FILENAME" | awk '{print $3}'`

  # FILEPREF=`echo "$FILENAME" | sed 's|\.jpg$||'`

  ## Strip off suffix like _123...x123..._yadayada.jpg
  ##                    OR _XXXxYYY_yadayada.jpg
  ##                    OR _XXXx123..._yadayada.jpg
    FILEPREF=`echo "$FILENAME" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*\.jpg$||'`


  mv "$FILENAME" "${FILEPREF}_${FILESIZE}.jpg"

done


