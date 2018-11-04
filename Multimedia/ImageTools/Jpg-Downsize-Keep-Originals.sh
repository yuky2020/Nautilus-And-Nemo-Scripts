#!/bin/sh
##
## SCRIPT: 04_multiDownsize_4jpgFiles_YPIXhigh_INPLACE_orig2biggerDIR.sh
##
## NOTE: You could up-size files with this script, but that
##       usually results in loss of quality.
##
##       This script is oriented toward taking a batch of 'oversized'
##       '.jpg' files, like files from a digital camera, in a directory
##       where you want the DOWNSIZED files, and making a common,
##       smaller Y-size file from the original in this directory --- while
##       moving the originals to a 'biggerThanYPIXELSy' subdirectory.
##
##
## Created: 2010mar21
## Changed: Added zenity prompt for Y-height.

## FOR TESTING:
# set -v
# set -x

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"

##
## Get the Y-height for the new sized image files. 
##

    YSIZE="600"
    YSIZE=$(zenity --entry --text "Enter the Y-pixel-size for the output image(s) :
        Typically about 450 to 650 pixels to fit in a browser/reader window." \
        --entry-text "600")

##
## Make the 'biggerfiles' directory, if needed, in curdir.
## Move the dir later, if needed.
##

DIR4bigIMGS="biggerThan${YSIZE}y"

if test ! -d "$DIR4bigIMGS"
then
     mkdir "$DIR4bigIMGS"
fi

##
## START THE LOOP on the filenames.
##

for FILENAME in $FILENAMES
do

  ##
  ## Check that the file is a 'jpg' file.
  ##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "jpg" 
  then 
     continue
     # exit
  fi


##
## Use 'convert' to make the resized jpg file.
##

   mv "$FILENAME" ./$DIR4bigIMGS/${FILENAME}
   
   convert "./$DIR4bigIMGS/${FILENAME}" -resize x$YSIZE -quality 100 "$FILENAME"


##
## Rename the resized jpg file to have the new size in the filename
## --- in the form MMMxNNN.
##

   FILESIZE=`identify "$FILENAME" | awk '{print $3}'`

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
   
   ## Strip off suffix of the form '_MMM...xNNN..._yadayada.jpg'
   FILENAMECROP=`echo "$FILENAME" | sed 's|_[0-9][0-9]*x[0-9][0-9]*.*\.jpg$||'`

   mv "$FILENAME" "${FILENAMECROP}_${FILESIZE}.jpg"

done




