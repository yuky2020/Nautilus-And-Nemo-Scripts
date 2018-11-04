#!/bin/bash
#
# By http://www.frankrock.it
# frankrock74@gmail.com
#
#This script creates a folder with mp3, on which a file.m3u us just click to play all the songs in the MP3 folder contents ...
#
#FILE=`basename "*"`
touch ./playlist.m3u
for MUSIC in *.mp3 ; do
echo "#EXTM3U
#EXTINF:"$MUSIC"
"$MUSIC"
" >> ./playlist.m3u
done
#
#All packages and scripts contained therein are the property of FrankRock.it, invented and written by me.
#Freely usable and modifiable by distributing free
