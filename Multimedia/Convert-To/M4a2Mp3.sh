#!/bin/bash

find . | grep m4a$ | while read i
do
echo Converting $i into a temp wav file

faad -o /dev/shm/temp.wav "$i" &> /dev/null
faad -i "$i" 2> /dev/shm/temp.txt

title=`grep ^title: /dev/shm/temp.txt | sed s/^title: //`
album=`grep ^album: /dev/shm/temp.txt | sed s/^album: //`
mydate=`grep ^date: /dev/shm/temp.txt | sed s/^date: //`
track=`grep ^track: /dev/shm/temp.txt | sed s/^track: //`
album_artist=`grep ^album_artist: /dev/shm/temp.txt | sed s/^album_artist: //`

echo Converting temp.wav into ${i%.m4a}.mp3
lame -S /dev/shm/temp.wav "${i%.m4a}.mp3"

echo Setting id3 tag info. Artist: $album_artist Album: $album Title: $title Year: $mydate Track: $track
id3tag -2 --artist="$album_artist" --album="$album" --song="$title" --year="$mydate" --track="$track" "${i%.m4a}.mp3"
done
