#!/bin/sh
##
## Nautilus
## SCRIPT: 00_oneConvertMovie_3gpTOmpg_ffmpeg.sh
##
## PURPOSE: Convert a '.3gp' movie file to an '.mpg' movie file.
##          Uses 'ffmpeg'.
##          Shows the '.mpg' in a movie player.
##
## NOTE:The ffmpeg parms for 3gp files were based on a forum response at
##       http://www.sprintusers.com/forum/archive/index.php/t-102919.html
##
## Started: 2010aug06
## Changed:

## FOR TESTING:
#  set -v
  set -x

##
## Get the filename of the selected file.
##

# FILENAME="$@"
  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##
## Check that the selected file is a '3gp' or '3g2' file
## --- or some other such movie file [suffix to be added here].
##     (Assumes just one dot [.] in the filename, at the extension.)

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
  if test "$FILEEXT" != "3gp" -a "$FILEEXT" != "3g2" 
  then
     exit
  fi


##
## Prepare the output '.mpg' filename.
##    (Assumes just one dot [.] in the filename, at the extension.)

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

   FILEOUT="${FILENAMECROP}.mpg"

   if test -f "$FILEOUT"
   then
      rm -f "$FILEOUT"
   fi

##
## Use 'ffmpeg' to make the 'mpg' file --- high-quality,
## by taking defaults (same size, same bit rates, etc.).
##

#   ffmpeg -i "$FILENAME" -ab 128k -ar 44100 -b 200k -r 24 \
#          -s 640x480 "$FILEOUT"
#
#   ffmpeg -i "$FILENAME" "$FILEOUT"

## FROM: http://www.sprintusers.com/forum/archive/index.php/t-102919.html
##
## ffmpeg -y -i "<%InputFile%>" -timestamp "<%TimeStamp%>" -bitexact \
##        -vcodec mpeg4 -fixaspect -s 176x144 -r 25 -b 400 -acodec \
##        aac -ac 1 -ar 22050 -ab 64 -f 3gp -muxvb 64 -muxab 32 "<%TemporaryFile%>.3gp"
##
## Some of these parms (like -fixaspect) or their values were not accepted by my ffmpeg
## on Linux (Ubuntu 9.10), so I backed off and started adding parameters as needed,
## such as '-vcodec', '-r', '-s', and 'acodec'. I found that these worked for the
## test '.3gp' file.

 ## FOR TEST:
    set -x

 xterm -fg white -bg black -e \
 ffmpeg -i "$FILENAME" \
        -vcodec mpeg1video  -r 30 -s 640x480 -acodec libmp3lame "$FILEOUT"

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
## -vcodec codec - to force the video codec.
##                 Example: -vcodec mpeg4 
##                 Try  "ffmpeg -formats"
## Audio:
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
## -ac channels - default = 1
## -an - disable audio recording
##               
## Some other useful params:
## 
## Other Video [for cropping, etc.] :
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -vn - disable video recording          [for audio extract]
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
## Show the movie file.
##

   if test ! -f "$FILEOUT"
   then
      exit
   fi

# xterm -fg white -bg black -hold -e vlc     "$FILEOUT"
# xterm -fg white -bg black -hold -e mplayer "$FILEOUT"
  xterm -fg white -bg black -hold -e /usr/bin/ffplay -stats "$FILEOUT"

