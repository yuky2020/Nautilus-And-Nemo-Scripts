#!/bin/bash

# Display-Offed.sh
# turns off screen and it will stay off until this script is closed/finished
# works well attached to a hardware button shortcut


# Created by: totti
# Original Name: switchMonitor

LF=/tmp/screen-lock;
if [ -f $LF ]; then
    /bin/rm $LF;
else
    touch $LF;
    sleep .5;
    while [ -f $LF ]; do
        xset dpms force off;
        sleep 2;
    done;
fi

