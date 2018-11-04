#!/bin/bash

wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read INSULT; do notify-send -t $((3000+300*`echo -n $INSULT | wc -w`)) -i /usr/share/icons/gnome/32x32/status/info.png "          INSULT" "$INSULT"; echo $INSULT | espeak; done
