#!/bin/bash

# Hide-Unhide-In-Nautilus-On-Startup.sh
# Creator: Inameiname
# Date: 21 June 2011
# Version: 1.0
#
#
# This is a simple nautilus script to automatically add file(s)/folder(s)
# to a ".hidden" file from a single preset ".hidden" file so Nautilus will hide them, just like ".*" files
# Instructions:
# - Put this in whatever folder you wish
# - Set it to run at startup by going to Main Menu -> System -> Preferences -> Startup Applications
# - Add a new startup program, like this: Name: Hide-Stuff-In-Nautilus; Command: /path/to/file/Hide-Unhide-In-Nautilus-On-Startup.sh
# - Input whatever user you want who can use this script
# - Input whatever file(s)/folder(s) you want below, between the parentheses
#
#
# This only works if you input the proper filenames and foldernames into this beforehand
# Once done, and linked as a startup program, it will run at startup, first deleting the older
# ".hidden" files on your system, and making ".hidden" files as per requsted on this script



# Add the correct user you want who can use this script
    USER_TO_HIDE_FILES=""

# Add the file(s)/folder(s) you want to hide here
    # ARCHIVE_FULLPATH1=""
    # ARCHIVE_FULLPATH2=""
    # ARCHIVE_FULLPATH3=""
    # ARCHIVE_FULLPATH4=""
    # ARCHIVE_FULLPATH5=""
    # ARCHIVE_FULLPATH6=""
    # ARCHIVE_FULLPATH7=""
    # ARCHIVE_FULLPATH8=""
    # ARCHIVE_FULLPATH9=""
    # ARCHIVE_FULLPATH10=""
    # ARCHIVE_FULLPATH11=""
    # ARCHIVE_FULLPATH12=""
    # ARCHIVE_FULLPATH13=""
    # ARCHIVE_FULLPATH14=""
    # ARCHIVE_FULLPATH15=""
    # ARCHIVE_FULLPATH16=""
    # ARCHIVE_FULLPATH17=""
    # ARCHIVE_FULLPATH18=""
    # ARCHIVE_FULLPATH19=""
    # ARCHIVE_FULLPATH20=""
    # ARCHIVE_FULLPATH21=""
    # ARCHIVE_FULLPATH22=""
    # ARCHIVE_FULLPATH23=""
    # ARCHIVE_FULLPATH24=""
    # ARCHIVE_FULLPATH25=""

# Various substitutions that are based on what is put above
# Unless you are hiding more than 25 files/folders, leave this section alone (other than uncommenting # of lines required)
    # DIRNAME1=`dirname "$ARCHIVE_FULLPATH1"`
    # DIRNAME2=`dirname "$ARCHIVE_FULLPATH2"`
    # DIRNAME3=`dirname "$ARCHIVE_FULLPATH3"`
    # DIRNAME4=`dirname "$ARCHIVE_FULLPATH4"`
    # DIRNAME5=`dirname "$ARCHIVE_FULLPATH5"`
    # DIRNAME6=`dirname "$ARCHIVE_FULLPATH6"`
    # DIRNAME7=`dirname "$ARCHIVE_FULLPATH7"`
    # DIRNAME8=`dirname "$ARCHIVE_FULLPATH8"`
    # DIRNAME9=`dirname "$ARCHIVE_FULLPATH9"`
    # DIRNAME10=`dirname "$ARCHIVE_FULLPATH10"`
    # DIRNAME11=`dirname "$ARCHIVE_FULLPATH11"`
    # DIRNAME12=`dirname "$ARCHIVE_FULLPATH12"`
    # DIRNAME13=`dirname "$ARCHIVE_FULLPATH13"`
    # DIRNAME14=`dirname "$ARCHIVE_FULLPATH14"`
    # DIRNAME15=`dirname "$ARCHIVE_FULLPATH15"`
    # DIRNAME16=`dirname "$ARCHIVE_FULLPATH16"`
    # DIRNAME17=`dirname "$ARCHIVE_FULLPATH17"`
    # DIRNAME18=`dirname "$ARCHIVE_FULLPATH18"`
    # DIRNAME19=`dirname "$ARCHIVE_FULLPATH19"`
    # DIRNAME20=`dirname "$ARCHIVE_FULLPATH20"`
    # DIRNAME21=`dirname "$ARCHIVE_FULLPATH21"`
    # DIRNAME22=`dirname "$ARCHIVE_FULLPATH22"`
    # DIRNAME23=`dirname "$ARCHIVE_FULLPATH23"`
    # DIRNAME24=`dirname "$ARCHIVE_FULLPATH24"`
    # DIRNAME25=`dirname "$ARCHIVE_FULLPATH25"`

    # FILENAME1=${ARCHIVE_FULLPATH1##*/}
    # FILENAME2=${ARCHIVE_FULLPATH2##*/}
    # FILENAME3=${ARCHIVE_FULLPATH3##*/}
    # FILENAME4=${ARCHIVE_FULLPATH4##*/}
    # FILENAME5=${ARCHIVE_FULLPATH5##*/}
    # FILENAME6=${ARCHIVE_FULLPATH6##*/}
    # FILENAME7=${ARCHIVE_FULLPATH7##*/}
    # FILENAME8=${ARCHIVE_FULLPATH8##*/}
    # FILENAME9=${ARCHIVE_FULLPATH9##*/}
    # FILENAME10=${ARCHIVE_FULLPATH10##*/}
    # FILENAME11=${ARCHIVE_FULLPATH11##*/}
    # FILENAME12=${ARCHIVE_FULLPATH12##*/}
    # FILENAME13=${ARCHIVE_FULLPATH13##*/}
    # FILENAME14=${ARCHIVE_FULLPATH14##*/}
    # FILENAME15=${ARCHIVE_FULLPATH15##*/}
    # FILENAME16=${ARCHIVE_FULLPATH16##*/}
    # FILENAME17=${ARCHIVE_FULLPATH17##*/}
    # FILENAME18=${ARCHIVE_FULLPATH18##*/}
    # FILENAME19=${ARCHIVE_FULLPATH19##*/}
    # FILENAME20=${ARCHIVE_FULLPATH20##*/}
    # FILENAME21=${ARCHIVE_FULLPATH21##*/}
    # FILENAME22=${ARCHIVE_FULLPATH22##*/}
    # FILENAME23=${ARCHIVE_FULLPATH23##*/}
    # FILENAME24=${ARCHIVE_FULLPATH24##*/}
    # FILENAME25=${ARCHIVE_FULLPATH25##*/}

# Upon startup, remove all ".hidden" files (that way you can start fresh after each restart, in case you've changed things on this script)
    cd $HOME
    find . -type f -name ".hidden" -exec rm -f {} \;

# Determine the correct user that has to be logged in for this script to run and hide files
if [ $USER = $USER_TO_HIDE_FILES ] ; then
    # Hide/Unhide file(s)/folder(s) using ".hidden" file within the current folder
    # Copies all selected files/folders filenames to ".hidden"
    # Unless you are hiding more than 25 files/folders,
    # leave this section alone (other than uncommenting lines)
      # echo $FILENAME1 >> "$DIRNAME1/.hidden"
      # echo $FILENAME2 >> "$DIRNAME2/.hidden"
      # echo $FILENAME3 >> "$DIRNAME3/.hidden"
      # echo $FILENAME4 >> "$DIRNAME4/.hidden"
      # echo $FILENAME5 >> "$DIRNAME5/.hidden"
      # echo $FILENAME6 >> "$DIRNAME6/.hidden"
      # echo $FILENAME7 >> "$DIRNAME7/.hidden"
      # echo $FILENAME8 >> "$DIRNAME8/.hidden"
      # echo $FILENAME9 >> "$DIRNAME9/.hidden"
      # echo $FILENAME10 >> "$DIRNAME10/.hidden"
      # echo $FILENAME11 >> "$DIRNAME11/.hidden"
      # echo $FILENAME12 >> "$DIRNAME12/.hidden"
      # echo $FILENAME13 >> "$DIRNAME13/.hidden"
      # echo $FILENAME14 >> "$DIRNAME14/.hidden"
      # echo $FILENAME15 >> "$DIRNAME15/.hidden"
      # echo $FILENAME16 >> "$DIRNAME16/.hidden"
      # echo $FILENAME17 >> "$DIRNAME17/.hidden"
      # echo $FILENAME18 >> "$DIRNAME18/.hidden"
      # echo $FILENAME19 >> "$DIRNAME19/.hidden"
      # echo $FILENAME20 >> "$DIRNAME20/.hidden"
      # echo $FILENAME21 >> "$DIRNAME21/.hidden"
      # echo $FILENAME22 >> "$DIRNAME22/.hidden"
      # echo $FILENAME23 >> "$DIRNAME23/.hidden"
      # echo $FILENAME24 >> "$DIRNAME24/.hidden"
      # echo $FILENAME25 >> "$DIRNAME25/.hidden"
fi
