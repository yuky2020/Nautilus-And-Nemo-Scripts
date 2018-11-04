#!/bin/sh
##
## Nautilus
## SCRIPT: 00_captureXwin_toVideo_mpg_ffmpeg.sh
##
## PURPOSE: Capture Xwindow activity to an '.mpg' movie file.
##          Uses 'ffmpeg'.
##          Shows the '.mpg' in a movie player.
##
## Started: 2010mar08
## Changed:

## FOR TESTING:
# set -v
# set -x

##
## Set the capture time (in secs) for the video capture.
## 

    CAPTURESECS="10"
    CAPTURESECS=$(zenity --entry \
       --title "CAPTURE Time (secs) for the X11 video capture." \
       --text "Enter capture-time in seconds:
 This is the amount of time that ffmpeg will capture the X11 screen activity." \
       --entry-text "10")

if test "$CAPTURESECS" = ""
then
   exit
fi

RATE=25
VFRAMES=`expr $CAPTURESECS \* $RATE`

##
## Set the delay time (in secs) before video capture starts.
## 

#     DELAYSECS="10"
#     DELAYSECS=$(zenity --entry \
#        --title "Delay Time (secs) before capture starts." \
#        --text "Enter delay-time in seconds:
#  This allows some setup time before ffmpeg starts capturing the X11 screen." \
#        --entry-text "10")

# if test "$DELAYSECS" = ""
# then
#    exit
# fi

# sleep $DELAYSECS


####################################################
## A zenity OK/Cancel prompt for 'Start recording?'.
####################################################

  zenity  --question \
          --title "Start recording?" \
          --text  "\
Start recording the screen for $CAPTURESECS seconds?
      (after a delay of 3 seconds, to get setup)
Cancel = Exit.

You will know when the recording has stopped --- 
a movie viewer will start showing your movie."

  if test $? != 0
  then
     exit
  fi

  sleep 3


##
## Prepare the output filename.
##

FILEOUT="/tmp/out_x11.mpg"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##
## Capture the X11 screen activities with 'ffmpeg'.
##

## This example from 'man ffmpeg' does not seem to work.
# ffmpeg -f x11grab -s cif -i :0.0 "$FILEOUT"
## NOR
# ffmpeg -f x11grab -s cif -i ":0.0" /tmp/movie2.mpg
## It gives error msgs:
##  AVParameters don't have video size and/or rate. Use -s and -r.
##  :0.0: I/O error occurred

## Thanks to
## http://mail-index.netbsd.org/pkgsrc-users/2009/12/06/msg011281.html
## for the following example that works on Ubuntu Karmic.
##
## ffmpeg -an -f x11grab -r 25 -s 1024x768 -i ":0.0" -vcodec mpeg4 -sameq /tmp/test.mp4
##
## A little experimenting indicates that the '-r' is the critical parm.
## It may be that '-sameq' does not have any effect. And '-an' may not be needed.

## FOR TESTING: (use 'q' in the xterm to quit recording)
# xterm -hold -geometry 24x18+1000+750 -e \
#  ffmpeg -f x11grab -r 25 -s 1024x768 -i ":0.0" -an -vcodec mpeg1video \
#         -sameq "$FILEOUT"

## For non-interactive termination of the movie, TRY:
  ffmpeg -f x11grab -r $RATE -s 1024x768 -an -i ":0.0" -an -vcodec mpeg1video \
         -sameq -vframes $VFRAMES "$FILEOUT"

#         -sameq -t $CAPTURESECS "$FILEOUT"

#        -sameq -vframes $VFRAMES "$FILEOUT"

## Meaning of the 'popular' ffmpeg parms:
##
## -i  val = input filename
## -ab val = audio bitrate in bits/sec (default = 64k)
## -ar val = audio sampling frequency in Hz (default = 44100 Hz)
## -r  val = frame rate in frames/sec
## -b  val = video bitrate in kbits/sec (default = 200 kbps)
## -s  val = frame size, wxh where w and h are pixels or abbrevs:
##          qqvga =  160x120
##           qvga =  320x240
##            cif =  352x288
##            vga =  640x480
##           svga =  800x600
##            xga = 1024x768
##           sxga = 1280x1024
##           uxga = 1600x1200
##               
## Some other useful params:
## 
## Video:
##   -aspect (4:3, 16:9 or 1.3333, 1.7777)
##   -croptop pixels
##   -cropbottom pixels
##   -cropleft pixels
##   -cropright pixels
##   -padtop (bottom, left, right)
##   -padcolor <6 digit hex number>
##   -vn - disable video recording
##   -y  = overwrite output file(s)
##   -t duration - format is hh:mm:ss[.xxx]
##   -fs file-size-limit
##   -ss position - seek to given position, in secs or hh:mm:ss[.xxx]
##   -target type - where type is vcd or svcd or dvd or ..., then
##    bitrate, codecs, buffersizes are set automatically.
##   -vcodec codec - to force the video codec.
##                   Example: -vcodec mpeg4 
##                   Try  "ffmpeg -formats"
##   -pass n, where n is 1 or 2
##
## Audio:
##   -ac channels - default = 1
##   -an - disable audio recording
##   -acode codec - to force the audio codec. Example:
##                                      -acodec libmp3lame
## Other:
##   -debug
##   -threads count
##
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
# xterm -fg white -bg black -hold -e gmplayer -vo xv "$FILEOUT"
  xterm -fg white -bg black -hold -e /usr/bin/ffplay -stats "$FILEOUT"

## NOTE: 'totem' (based on gstreamer) tends to play only a second or so of
##       an mpeg1video. But 'ffplay' does a good job. 'mplayer' does OK.
#  totem "$FILEOUT"


