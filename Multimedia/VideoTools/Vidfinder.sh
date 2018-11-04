#!/bin/bash

FLASHVID=`lsof -X | grep "plugin-co.*deleted" | head -n1`
DIRECTORY=`echo -n $FLASHVID | awk '{ print $2 }'`
FD=`echo -n $FLASHVID | awk '{ print $4 }'`
RESULT="The video is at /proc/"$DIRECTORY"/fd/"${FD%?}

if [ "$FLASHVID" == "" ]; then
	RESULT="No running instance of Flash was found."
fi

notify-send "$RESULT" || zenity --info --text="$RESULT"


