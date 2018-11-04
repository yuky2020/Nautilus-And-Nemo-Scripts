#!/bin/sh
##
## SCRIPT: 01c_multiRename_DSCF0toD.sh
##
## Created: 2010feb19
##

## FOR TESTING:
# set -v
# set -x

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"

##
## START THE LOOP on the filenames.
##

for FILENAME in $FILENAMES
do

##
## Get and check that file extension is 'jpg'. 
## Assumes one '.' in filename, at the extension.
##

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

#  if test "$FILEEXT" != "jpg" 
#  then 
#     continue
#     # exit
#  fi

##
## Make the new filename and rename.
##

  FILENAME2=`echo "$FILENAME" | sed 's|^DSCF0|D|'`

  mv "$FILENAME" "$FILENAME2"

done


