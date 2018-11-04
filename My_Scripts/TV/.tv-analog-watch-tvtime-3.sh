    #!/bin/bash
    # add following line via visudo or put "snd_mixer_oss" in rc.conf MODULES array
    # %wheel ALL=(root) NOPASSWD: /sbin/modprobe snd_mixer_oss
    sudo modprobe snd_mixer_oss
    # modify string for your language regarding aplay -l
    SEARCHSTRING="Karte"

    CARDS="$(aplay -l | grep -i "$SEARCHSTRING" | cut -d \: -f1 | cut -d \  -f2 | sort -u)"
    LASTCARD=$(echo $CARDS | rev | cut -d " " -f1)
    TVCARD=$((LASTCARD+1))
    for i in $(seq 0 $LASTCARD) ; do
        aplay -l | grep "$SEARCHSTRING ${i}:" >/dev/null
        [ $? = 1 ] && TVCARD=$i
    done
    sox -t alsa hw:$TVCARD,0 -t alsa default --no-show-progress &
    /usr/bin/tvtime "$@"
    # close sox session
    kill %%﻿

