#!/bin/sh
##
## Nautilus
## SCRIPT: 06_multiThumbsJpg_4jpgORpngORgifFiles_YPIXhigh.sh
##
## PURPOSE: Makes 'thumbnail' files for a set of selected image files
##          ('.jpg' or '.png' or '.gif'). Prompts the user for a Y-height
##          in pixels, and makes all the thumbnails that height.
##          Uses ImageMagick 'convert'.
##          Puts '_thumb' in the filename to get the thumbnail filename.
##          Example: joe_640x423.jpg        yields thumbnail file
##                   joe_640x423_thumb.jpg
##          Puts the thumbnails into a (new) 'thumbs' subdirectory of the
##          current directory.
##
## Created: 2010feb17
## Changed: 2010mar30 To allow for creating jpg-thumbs from png and gif files,
##                    as well as from jpg files.
## Changed: 2010apr01 Added zenity prompt for Y-size.
## Changed: 2010apr06 Added exit if Y-size is null, as on zenity Cancel.

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
## Make the 'thumbs' directory, if needed, in curdir
##

if test ! -d thumbs
then
     mkdir thumbs
fi


##
## Get the Y-height for the thumbs. 
##

    YSIZE="60"
    YSIZE=$(zenity --entry --title "Enter Y-size." \
            --text "Enter the Y-pixel-size for the thumbs :
        Typically 60 or 90 pixels for small thumbs." \
        --entry-text "60")

    if test "$YSIZE" = ""
    then
       exit
    fi


##
## START THE LOOP on the filenames.
##

for FILENAME in $FILENAMES
do

  ##
  ## Check that the file is a 'jpg' or 'png' or 'gif' file.
  ##

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
  then
     continue
     # exit
  fi


  ##
  ## Use 'convert' with '-resize' to make the thumb.
  ##

  FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||' |  sed 's|\.png$||' | sed 's|\.gif$||'`
   
  convert "$FILENAME" -resize x$YSIZE -quality 100 \
          "./thumbs/${FILENAMECROP}_thumb.jpg"

done





