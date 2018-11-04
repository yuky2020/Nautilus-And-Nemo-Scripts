#!/bin/sh
# Download from youtube mp4 end mp3
# need:
#   - youtube-dl
#   - ffmpeg

# Check if youtube-dl commands are found
for command in youtube-dl
do
    if [ ! $(which $command) ]
    then
        zenity --error --text "Could not find \"$command\" application.\n
Make sure youtube-dl is installed and \"$command\" is executable."
        exit 1
    fi
done

# Check if ffmpeg commands are found
for command in ffmpeg
do
    if [ ! $(which $command) ]
    then
        zenity --error --text "Could not find \"$command\" application.\n
Make sure ffmpeg is installed and \"$command\" is executable."
        exit 1
    fi
done

var=`zenity --entry --title="Download From Youtube" --text="Enter address youtube video:                              "`

if [ $? = 0 ] ; then
  
    filetype=`zenity  --list  --text "mp3 or mp4" --radiolist  --column "select" --column "type" TRUE "mp3" FALSE "mp4"`

    if [ $? = 0 ] ; then
    
        if [ $filetype = "mp3" ]; then 
            youtube-dl "$var" --extract-audio --audio-format=mp3 | zenity --progress --pulsate --auto-close --auto-kill --title="Download From Youtube" --text="downloading..."
        else
            youtube-dl "$var" | zenity --progress --pulsate --auto-close --auto-kill --title="Download From Youtube" --text="downloading..."         
        fi
    
    fi

fi

zenity --info --text="Please visit http://www.tutorial360.it"

exit 0
