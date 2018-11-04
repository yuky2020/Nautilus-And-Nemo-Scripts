#!/bin/bash

# Set IFS so that it won't consider spaces as entry separators.  Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

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

    mkdir "$NEWDIRNAME"
    cp -fv -R "$ARCHIVE_FULLPATH" "$NEWDIRNAME"
    cd "$NEWDIRNAME"
    ar vx "$FILENAME"
    rm -fv -R "$FILENAME"
    for FILE in *.tar.gz; do tar xvpf $FILE; done
    for FILE in *.tar.lzma; do tar xvpf $FILE; done
    for FILE in *.tar.xz; do tar xvpf $FILE; done
    rm -fv -R "control.tar.gz"
    rm -fv -R "data.tar.gz"
    rm -fv -R "data.tar.lzma"
    rm -fv -R "data.tar.xz"
    rm -fv -R "debian-binary"

    mkdir "DEBIAN"

    mv -fv "changelog" "DEBIAN"
    mv -fv "config" "DEBIAN"
    mv -fv "conffiles" "DEBIAN"
    mv -fv "control" "DEBIAN"
    mv -fv "copyright" "DEBIAN"
    mv -fv "postinst" "DEBIAN"
    mv -fv "preinst" "DEBIAN"
    mv -fv "prerm" "DEBIAN"
    mv -fv "postrm" "DEBIAN"
    mv -fv "rules" "DEBIAN"
    mv -fv "shlibs" "DEBIAN"
    mv -fv "symbols" "DEBIAN"
    mv -fv "templates" "DEBIAN"
    mv -fv "triggers" "DEBIAN"
    mv -fv ".svn" "DEBIAN"

    rm -fv -R "md5sums"
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/info.png "Job Finished"
done
