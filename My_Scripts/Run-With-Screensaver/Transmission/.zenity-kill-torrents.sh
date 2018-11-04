#!/bin/bash

#Creator:	dark-triad
#Called through screensaver script, asks whether or not to kill torrent client (transmission)
#This does not close transmission gracefully or softly, it kills transmission, transmission
#will not update or send your tacker info before it shutsdown but will update them when
#transmission is restarted next time

zenity --question --text="Do you want to close your torrents?" --title="DOWNLOADS"
if [[ $? == 0 ]] ; then
kill -9 "$(pgrep -f transmission)"

echo "Torrents are now closed"

else

echo "Torrents are staying active"

fi
