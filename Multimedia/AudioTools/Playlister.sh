#!/bin/sh

##m3u-playlister v0.9
##script to create m3u-playlists for a given directory with mp3-files incl. subdirs
##it will delete any m3u playlist found and rename any mp3 file to 'mp3' with no capitals in the extension. the rest of the filename will stay untouched.
##attention: directories and filenames must not contain spaces. Substitute spaces to underscores first before you use this script
##usage is on your own risk
##it's freeware, distribute it and apply the gpl, cc or whichever license you like on it, but please leave my initials in it :)
##written by mb (Martin Baumann) in August 2009


#toplevel-directory
workdir=`pwd`
rootdir=`zenity --entry --title="Rootdir" --text="rootdir for your collection:" --entry-text="$workdir"`

#function for renaming malformed extensions
rename ()
{
 for x in `find $rootdir -name "*$1"`
  do name=`echo $x|sed "s/$1/mp3/g"`
   if [ $name ]
    then echo Renaming $x to $name
    mv $x $name
   fi
 done
 unset -v name
}

#function for deleting existing m3u-playlists
delm3u ()
{
 for x in `find $rootdir -name "*$1"`
  do rm $x
  done
}

#rename all songs to same extension (mp3)
echo "Adjusting all extensions to same format (mp3) ..."
rename MP3
rename Mp3
rename mP3
echo "done."
#| zenity --width=350 --title "extension check" --text "search and rename..." --progress --pulsate  --auto-close 

echo "Deleting existing m3u-playlists ..."
delm3u m3u
delm3u M3u
delm3u m3U
delm3u M3U
echo "done."

#create m3u playlists
echo "Creating new m3u-playlists ..."
for x in `find $rootdir -type d | sed {'s/^.\///g'}`
 do m3u=`echo $x | sed 's/^\/.*\///g'`
  cd $x
  ls *mp3 2>/dev/null > $x/$m3u.m3u
 done #| zenity --width=350 --title "playlist creation" --text "writing lists..." --progress --pulsate  --auto-close 
echo "done."

#delete empty playlists
echo "Deleting empty m3u-playlists ..."
find $rootdir -name '*m3u' -empty -exec rm {} \; # | zenity --width=350 --title "waste deletion" --text "deleting empty files... " --progress --pulsate  --auto-close 
echo "done."

