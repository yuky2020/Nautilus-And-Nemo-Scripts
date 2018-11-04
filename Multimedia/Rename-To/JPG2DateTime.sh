#!/bin/sh
##
## Nautilus
## SCRIPT: 01a_multiRename_JPGfile_toDateTime.sh
##
## PURPOSE: Renames a set of selected '.JPG' files to contain
##          date-time --- in the form from the 'ls' command,
##          fields 6 and 7.
##
## Created: 2010feb22
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
     continue
     # exit
  fi

  ##
  ## Get and apply the file date and time.
  ##

  FILEDATE=`ls -l "$FILENAME" | awk '{print $6}'`
  FILETIME=`ls -l "$FILENAME" | awk '{print $7}'`

  FILEPREF=`echo "$FILENAME" | sed 's|\.JPG$||'`

  mv "$FILENAME" "${FILEPREF}_${FILEDATE}_${FILETIME}.JPG"

done


