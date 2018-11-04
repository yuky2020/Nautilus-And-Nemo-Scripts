#!/bin/sh
##
## Nautilus
## SCRIPT: 00_oneCropBottom_movieFile_ffmpeg.sh
##
## PURPOSE: Crop a user-specified number of pixels from the bottom of
##          a movie file (a 'flv' Flash movie file or 'wmv' or 'avi' or
##          'mov' movie file).
##          Uses 'ffmpeg'.
##          Shows the new, cropped '.mpg' in a movie player.
##
## NOTE: This script has not been tested on 'wmv', 'avi', or 'mov' files.
##       I may need to provide special ffmpeg parms for these file formats.
##
## Started: 2010mar08
## Changed:

## FOR TESTING:
# set -v

##
## Get the filename of the selected file.
##

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##
## Check that the selected file is a 'flv' or 'wmv' or 'avi' file
## --- or some other movie file, suffix to be added.
##  (Assumes just one dot [.] in the filename, at the extension.)

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
  then
     exit
  fi


##
## Prompt for the number of pixels to crop from the bottom of the movie file.
##
## Example: 18 for 18 pixels.
##

   YPIXELS="18"
   YPIXELS=$(zenity --entry \
           --title "Number of PIXELS to CROP from BOTTOM." \
           --text "Enter number of PIXELS to CROP from BOTTOM of movie file." \
           --entry-text "18")

  if test "$YPIXELS" = ""
  then
     exit
  fi


##
## Prepare the output filename.
##

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

   FILEOUT="${FILENAMECROP}_cropped.$FILEEXT"

   if test -f "$FILEOUT"
   then
      rm -f "$FILEOUT"
   fi

##
## Use 'ffmpeg' to make the cropped 'mpg' file --- high-quality,
## default parameters (same size, bit rates, etc. as input file).
##

## FOR TEST:
   set -x

 xterm -fg white -bg black -e \
       ffmpeg -i "$FILENAME" -cropbottom $YPIXELS "$FILEOUT"

## FOR TEST:
    set -


## Meaning of the 'popular' ffmpeg parms:
##
## -i  val = input filename
## Video:
## -r  val = frame rate in frames/sec
## -b  val = video bitrate in kbits/sec (default = 200 kbps)
## -s  val = frame size, wxh where w and h are pixels or abbrevs:
##          qqvga =  160x120
##           qvga =  320x240
##            vga =  640x480
##           svga =  800x600
##            xga = 1024x768
##           sxga = 1280x1024
##           uxga = 1600x1200
##   -vcodec codec - to force the video codec.
##                   Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
## Audio:
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
##   -ac channels - default = 1
##   -an - disable audio recording
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
##               
## Some other useful params:
## 
## Other Video [ for cropping, etc. ] :
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -vn - disable video recording         [for audio extract]
##   -t duration - format is hh:mm:ss[.xxx]
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
##   -target type - where type is vcd or svcd or dvd or ..., then
##                  bitrate, codecs, buffersizes are set automatically.
##   -pass n, where n is 1 or 2
##
## Other:
##   -y  = overwrite output file(s)
##   -fs file-size-limit
##   -debug
##   -threads count
##

##
## Show the (cropped) movie file.
##

   if test ! -f "$FILEOUT"
   then
      exit
   fi

# xterm -fg white -bg black -hold -e vlc     "$FILEOUT"
# xterm -fg white -bg black -hold -e mplayer "$FILEOUT"
  xterm -fg white -bg black -hold -e /usr/bin/ffplay -stats "$FILEOUT"

