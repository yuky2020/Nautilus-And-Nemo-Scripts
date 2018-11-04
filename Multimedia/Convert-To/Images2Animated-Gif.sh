#!/bin/sh
##
## Nautilus
## SCRIPT: ani03_mkOneAniGif_FROMjpgORpngORgifFiles_inpDELAY.sh
##
## PURPOSE: Makes an animated '.gif' file from a selected set of
##          image files ('.jpg' or '.png' or '.gif'). Prompts the
##          user for an inter-image delay (in hundredths of seconds).
##               Uses the ImageMagick 'convert' program. 
##          Shows the animated '.gif' file in an image viewer.
##
## Created: 2010mar18
## Changed: 

## FOR TESTING:
# set -v
  set -x

############################################
## Get the filenames of the selected files.
############################################

   FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## START THE LOOP on the filenames --- to make IMAGE filenames list.
####################################################################

FILENAMES2=""

for FILENAME in $FILENAMES
do

  ####################################################################
  ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
  ## Assumes one period (.) in filename, at the extension.
  ####################################################################
  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" = "jpg" -o "$FILEEXT" = "png" -o "$FILEEXT" = "gif"
  then
     FILENAMES2="$FILENAMES2 $FILENAME"
  fi

done


#######################################################################
## Use the last FILENAME to get the 'stub' to use to name the gif file.
#######################################################################
  FILENAMECROP=`echo "$FILENAME" | sed 's|\.jpg$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.png$||'`
  FILENAMECROP=`echo "$FILENAMECROP" | sed 's|\.gif$||'`


##########################################################
## Set the delay time between frames of the animation ---
## in 100ths of a second. Example: 250 = 2.5 seconds.
##########################################################
    DELAY100s="250"
    DELAY100s=$(zenity --entry --title "Inter-image Delay Time" \
       --text "Enter delay-time in 100ths of seconds:
       Example: 250 gives 2.5 seconds" \
                --entry-text "250")


##################################################################
## Use 'convert' to make the animated gif file.
##    -delay 250 pauses 250 hundredths of a second (2.5 sec)
##                                     before showing next image
##    -loop 0 animates 'endlessly'
##################################################################
   
   FILEOUT="${FILENAMECROP}_ani.gif"
   convert -delay $DELAY100s -loop 0 $FILENAMES2 "$FILEOUT"


##################################
## Show the new animated gif file.
##################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$ANIGIFVIEWER "$FILEOUT" &



