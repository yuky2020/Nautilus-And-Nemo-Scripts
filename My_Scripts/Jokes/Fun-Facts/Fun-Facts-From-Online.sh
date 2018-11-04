#!/bin/bash

wget http://www.randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read TRIVIA; do notify-send -t $((6000+300*`echo -n $TRIVIA | wc -w`)) -i /usr/share/icons/gnome/32x32/status/info.png "          TRIVIA" "$TRIVIA"; done
