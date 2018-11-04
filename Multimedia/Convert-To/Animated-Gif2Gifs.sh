#!/bin/sh
##
## Nautilus
## SCRIPT: 01_one_anigifSplit.sh
##
## PURPOSE: Splits an animated '.gif' file into a sequence of
##          '.gif' files. Uses ImageMagick 'convert'.
##          Shows the resulting image files in an image viewer.
##
## Reference: http://www.imagemagick.org/Usage/anim_basics/#adjoin
##
## Created: 2010mar08
## Changed: 

## FOR TESTING:
# set -v
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Check that the selected file is a 'gif' file.
## (Assumes one dot in filename, at the extension.)
##          (Assumes no spaces in filename.)
#####################################################
  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "gif"
  then
     exit
  fi


##################################################################
## Use 'convert' to make the several 'gif' files.
## Reference: http://www.imagemagick.org/Usage/anim_basics/#adjoin
##################################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.gif$||'`

   convert +adjoin -coalesce "$FILENAME" "${FILENAMECROP}%03d.gif"

#################################################################
## After editing or whatever, you can rejoin the files with
##   convert ${FILENAMECROP}???.gif  ${FILENAMECROP}_rebuilt.gif
#################################################################


####################################################
## Show the gif files split from the animated gif.
####################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$IMGEDITOR  ${FILENAMECROP}*.gif &



