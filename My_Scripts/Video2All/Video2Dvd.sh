##########
#!/bin/bash
#
# video2dvd - Make a DVD ISO from a video file
#           Burn ISO after script runs
#
# Author  - Inameiname
#
# Version:	1.0
#
# Usage   - video2dvd $1
#           Run this script either from the terminal or by right clicking the video file and selecting the script
# Ensure 'export VIDEO_FORMAT=NTSC' is in '~/.bashrc' or '~/.bash.profile' OR that its below
##########



# See if the Nautilus environment variable is empty
if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
    # If it's blank, set it equal to $1
    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$1
fi

# Loop through the list (from either Nautilus or the command line)
for ARCHIVE_FULLPATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
    FILENAME=${ARCHIVE_FULLPATH##*/}
    NAME=${ARCHIVE_FULLPATH##*/.*}

    ###### open and run all of the following in a terminal window
    tty -s; if [ $? -ne 0 ]; then gnome-terminal -e "$0"; exit; fi

    ###### be sure there is a "VIDEO_FORMAT=" specified
    export VIDEO_FORMAT=NTSC

    ###### cd to the video file's folder
    mkdir "$NEWDIRNAME"
    cd "$NEWDIRNAME"
    cd ..
    rmdir "$NEWDIRNAME"

    ###### check to see if the file is an mpg/vob file; if not, convert it and rename the mpeg file to "dvd_movie.mpg"
    echo 'Is this video file not already a DVD-compliant MPEG file (MPEG/mpeg/MPG/mpg/VOB/vob), 1 for true 0 for false? '
    read MEDIA_TYPE
    if [ "$MEDIA_TYPE" -eq 1 ] ; then
        ###### convert the video file to '.mpg'
        ffmpeg -i "$ARCHIVE_FULLPATH" -target ntsc-dvd -acodec mp2 -ab 224 -sameq "$NEWDIRNAME".mpg
        notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Conversion to an MPEG File Finished"
        ###### rename the '.mpg' file to "dvd_movie.mpg"
        mv -fv "$NEWDIRNAME".mpg "dvd_movie.mpg"
    else
        ###### rename the mpg/mpeg/vob file to "dvd_movie.mpg"
        mv -fv "$ARCHIVE_FULLPATH" "dvd_movie.mpg"
    fi

    ###### create a "dvdauthor.xml" file - (save in the same directory as movie file)
    cat > "dvdauthor.xml" <<"End-of-message"
    <dvdauthor dest="DVD">
      <vmgm />
       <titleset>
         <titles>
           <pgc>
             <vob file="dvd_movie.mpg" chapters="0,05:00,10:00,15:00,20:00,25:00,30:00,35:00,40:00,45:00,50:00,55:00,1:00:00,1:05:00,1:10:00,1:15:00,1:20:00,1:25:00,1:30:00,1:35:00,1:40:00,1:45:00,1:50:00,1:55:00,2:00:00,2:05:00,2:10:00,2:15:00,2:20:00,2:25:00,2:30:00,2:35:00,2:40:00,2:45:00,2:50:00,2:55:00,3:00:00,3:05:00,3:10:00,3:15:00,3:20:00,3:25:00,3:30:00,3:35:00,3:40:00,3:45:00,3:50:00,3:55:00,4:00:00,4:05:00,4:10:00,4:15:00,4:20:00,4:25:00,4:30:00,4:35:00,4:40:00,4:45:00,4:50:00,4:55:00,5:00:00,5:05:00,5:10:00,5:15:00,5:20:00,5:25:00,5:30:00,5:35:00,5:40:00,5:45:00,5:50:00,5:55:00,6:00:00"/>
           </pgc>
          </titles>
       </titleset>
     </dvdauthor>
End-of-message

    ###### the actual mpg/mpeg/vob conversion to dvd-compliant folders
    dvdauthor -x dvdauthor.xml

    ###### rename the mpg/mpeg/vob file from "dvd_movie.mpg" back to the original
    if [ "$MEDIA_TYPE" -eq 1 ] ; then
        ###### rename the '.mpg' file to "dvd_movie.mpg"
        mv -fv "dvd_movie.mpg" "$NEWDIRNAME".mpg
    else
        ###### rename the mpg/mpeg/vob file to "dvd_movie.mpg"
        mv -fv "dvd_movie.mpg" "$ARCHIVE_FULLPATH"
    fi

    ###### rename the 'DVD' file to same name as the original
    mv -fv "DVD" "$NEWDIRNAME"

    ###### remove the "dvdauthor.xml" file created and used from this script
    rm -fv -R dvdauthor.xml

    ###### convert the dvd-compliant folders to an ISO
    echo 'Would you like to create an ISO from the DVD-complaint folders now, 1 for true 0 for false? '
    read boole
    if [ $boole -eq 1 ]; then
        cd "$NEWDIRNAME"
        mkisofs -v -dvd-video -o "$NEWDIRNAME.iso" .
        cd ..
        notify-send -t 2000 -i /usr/share/icons/gnome/32x32/status/info.png "ISO created"
    else
        notify-send -t 2000 -i /usr/share/icons/gnome/32x32/status/info.png "no ISO created"
    fi

    ###### option to burn the ISO
    echo 'Would you like to burn this disc now, 1 for true 0 for false? '
    read boole1
    if [ $boole1 -eq 1 ]; then
        # to get desired device
        df -h -x tmpfs -x usbfs
        echo -n "Please enter the appropriate DVD drive:

        (1) /dev/dvd
        (2) /dev/sr0
        (3) /dev/sr1
        (4) /dev/sr2
        (5) custom

        Press 'Enter' for default (default is '1')...

        "
        read DEVICE_NUMBER
        # extra blank space
        echo "
        "
        # default
        if [[ -z $DEVICE_NUMBER ]] ; then
        # If no device passed, default to /dev/dvd
            DEVICE=/dev/dvd
        fi
        # preset
        if [[ $DEVICE_NUMBER = 1 ]] ; then
            DEVICE=/dev/dvd
        fi
        if [[ $DEVICE_NUMBER = 2 ]] ; then
            DEVICE=/dev/sr0
        fi
        if [[ $DEVICE_NUMBER = 3 ]] ; then
            DEVICE=/dev/sr1
        fi
        if [[ $DEVICE_NUMBER = 4 ]] ; then
            DEVICE=/dev/sr2
        fi
        # custom
        if [[ $DEVICE_NUMBER = 5 ]] ; then
            echo -n "Please enter the appropriate DVD drive:  "
            echo -n "...like this: '/dev/dvd'..."
            read CUSTOM_DEVICE
            DEVICE=$CUSTOM_DEVICE
        fi
        growisofs -dvd-compat -speed=1 -Z "$DEVICE"="$NEWDIRNAME"
        notify-send -t 2000 -i /usr/share/icons/gnome/32x32/status/info.png "DVD burned"
    else
        notify-send -t 2000 -i /usr/share/icons/gnome/32x32/status/info.png "no DVD burned"
    fi

    ###### notify-send notification showing when the job has finished
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "All Conversions Finished"

done
