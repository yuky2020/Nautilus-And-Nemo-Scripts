#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anigifResize_XXXxYYYinput.sh
##
## PURPOSE: Resizes an animated '.gif' file.
##             Uses ImageMagick 'convert'.
##          Prompts the user for an inter-image delay time (in
##          hundredths of seconds) for the new animated '.gif' file.
##          Prompts the user for the x-y pixel size for the new file.
##             Shows the new animated '.gif' file in an image viewer.
##
## Reference: http://www.imagemagick.org/Usage/anim_basics/#coalesce
##
## Created: 2010apr01
## Changed: 

## FOR TESTING:
# set -v
# set -x

################################################
## Get the filename of the animated '.gif' file.
################################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#########################################################
## Check that the selected file is a 'gif' file.
## Assumes one dot (.) in the filename, at the extension.
#########################################################
  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "gif"
  then
     exit
  fi


##############################################################################
## Use 'convert +adjoin' (with '-coalesce') to extract the several 'gif' files.
## Reference: http://www.imagemagick.org/Usage/anim_basics/#coalesce
##############################################################################
   FILENAMECROP=`echo "$FILENAME" | sed 's|\.gif$||'`

   convert +adjoin -coalesce "$FILENAME" "${FILENAMECROP}%03d.gif"


###########################################################################
## Set the delay time between frames of the (reconstituted) animation ---
## in 100ths of a second. Example: 250 = 2.5 seconds.
###########################################################################
    DELAY100s="250"
    DELAY100s=$(zenity --entry --text "Enter delay-time in 100ths of seconds:
       Example: 250 gives 2.5 seconds" \
                --entry-text "250")


###############################################
## Set the new image size for the animated gif.
###############################################

    SIZEXY="320x240"
    SIZEXY=$(zenity --entry --text "Enter the X by Y size for the animation :
       Example: 320x240 for 320 pixels wide by 240 pixels high" \
                --entry-text "320x240")


###########################################################################
## Use 'convert' to make the animated gif file
## with the '-resize' parameter, to do the resizing.
## Reference: http://www.imagemagick.org/Usage/anim_mods/#resize_problems
##
## NOTE: It might be better to avoid the '-resize' parameter, per
##       the warnings in the documentation referenced. An alternative
##       is to resize the individual extracted gif files with 'convert -size'
##       then put them together with the command below, without the
##       '-resize' parameter.
##
##       With any method, if you resize to a LARGER size, the resulting
##       animation is probably going to be blurrier than the original
##       animation.
###########################################################################
   FILEOUT="${FILENAMECROP}_${SIZEXY}_ani.gif"
   convert -delay $DELAY100s -loop 0 -resize $SIZEXY \
           ${FILENAMECROP}*.gif "$FILEOUT"

############################################
## Show the new, resized animated gif file.
############################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$ANIGIFVIEWER "$FILEOUT" &
   
