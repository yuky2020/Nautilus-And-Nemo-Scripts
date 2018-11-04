!#/bin/bash

# SIVIA81 :
# GPL :
# Two identical one script is installed in ~ / .gnome2/nemo-scripts and the second can be launched from anywhere only have the # file path. Requirement :
# libav-tools ffmpeg lame ffmpeg2theora w32codecs libdvdcss2 ubuntu-restricted-extras :
# Tested avi, flv, mkv, mp4 , 3gp :

extract=$@
comands=`ffmpeg -i "$@" -acodec libmp3lame -ab 128k "$extract".mp3` | (zenity --progress --pulsate --auto-close --title="convert" --text="$@")
