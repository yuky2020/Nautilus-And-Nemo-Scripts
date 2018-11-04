#!/bin/sh
##
## Nautilus
## SCRIPT: 01b_multiRename_JPG2jpg.sh
##
## PURPOSE: Renames a set of selected '.JPG' files to change
##          the '.JPG' suffix to '.jpg'.
##
## Created: 2010feb19
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
## Get and check that file extension is 'JPG'. 
## Assumes one '.' in filename, at the extension.
##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "JPG" 
  then 
     exit
  fi

  ##
  ## Make the new .jpg filename and rename.
  ##

  FILENAME2=`echo "$FILENAME" | sed 's|\.JPG$|\.jpg|'`

  mv "$FILENAME" "$FILENAME2"

done


