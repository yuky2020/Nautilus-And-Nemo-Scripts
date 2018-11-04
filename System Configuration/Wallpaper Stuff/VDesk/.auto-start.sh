#!/bin/bash

##################################################
#             VDesk - Visual Desktop             #
#                                                #
# Title: VDesk - Visual Desktop                  #
# Version: 1.3                                   #
#                                                #
#                                                #
#                                                #
#            Authors and Contributors            #
#                                                #
# Lead Writer: ~ |Anthony|                       #
#     TechTweakerz@comcast.net                   #
#     http://www.craigslistdecoded.com           #
#                                                #
# Assistant Programmer: ~ Anthony Nordquist      #
#     salinelinux@gmail.com                      #
#     http://www.salineos.com                    #
#                                                #
#                                                #
#                                                #
#                 VDesk Licensing                #
#                                                #
# - DO NOT REMOVE ANY COMMENTS FROM VDESK        #
# - YOU ARE PROHIBITED FROM REDISTRIBUTING       #
#   VDESK - VISUAL DESKTOP                       #
# - YOU ARE PROHIBITED FROM MODIFYING VDESK -    #
#   VISUAL DESKTOP IN ANY WAY                    #
#                                                #
##################################################

VIDEO_DIR="$HOME/.gnome2/nemo-scripts/System Configuration/Wallpaper Stuff/VDesk"


type=$(grep -B 0  "auto_start_type=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
file=$(grep -B 0  "auto_start_file=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;

if [ "$type" = "Screen Saver" ] ; then
  sopac=$(grep -B 0  "ss_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  left=${sopac%??} right=${sopac:(-2)} opac=$left.$right ;
  exec xwinwrap -ni -argb -fs -s -o "$opac" -st -sp -nf -b -- "$file" -root -window-id WID ;
  exit ;
elif [ "$type" = "Video" ] ; then
  vopac=$(grep -B 0  "vid_opac=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  left=${vopac%??} right=${vopac:(-2)} opac=$left.$right ;
  vol=$(grep -B 0  "vol=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  mprofile_state=$(grep -B 0  "mprofile_state=" $VIDEO_DIR/.config | awk -F "=" '{print $2}') ;
  rm /tmp/mplayer-control ;
  mkfifo /tmp/mplayer-control ;
  if [ "$mprofile_state" = "FALSE" ] ; then
    xwinwrap -ni -o "$opac" -fs -s -st -sp -b -nf -- mplayer -volume $vol -slave -input file=/tmp/mplayer-control -wid WID -really-quiet "$dir/$file" -loop 0 & initiate
  elif [ "$mprofile_state" = "TRUE" ] ; then
    mprofile=$(grep -B 0  "mprofile=" $VIDEO_DIR/.config | awk -F "=" '{print $2}')
    xwinwrap -ni -o "$opac" -fs -s -st -sp -b -nf -- mplayer -profile "$mprofile" -volume $vol -slave -input file=/tmp/mplayer-control -wid WID -really-quiet "$dir/$file" -loop 0 & initiate
  else
    zenity --error --window-icon="/usr/share/pixmaps/vdesk.png" --title="VDesk - Visual Desktop" --text="Something went wrong with the\nAuto Start and VDesk will now\n close. Please reopen VDesk and use the\nReset to Defalts option in the\nConfiguration tab" ;
    exit ;
  fi
  exit ;
fi
exit

