#!/bin/bash

# This Script using the soxi command (available with the SOX tool) show the metadata associated with the selected Audio file.
# NOTE: this script work only with Audio files supported by sox/soxi


# Error messages to show if Zenity or soxi commands are not available
noZenityFound="Please, install the zenity package before run the script !"
noSoxiCommandFound="Please, install sox and soxi utility before run the script !"


# Check if the zenity package is installed
which zenity
if [ ! $? = 0 ]; then
   echo "$noZenityFound" > /tmp/Audio-Info-error
   xdg-open /tmp/Audio-Info-error
   exit
fi

# Check if the soxi command is available
which soxi
if [ ! $? = 0 ]; then
   echo "$noSoxiCommandFound" > /tmp/Audio-Info-error
   xdg-open /tmp/Audio-Info-error
   exit
fi

# The full path of the selected file (eg: /home/fulvio/afile.mp3) That path will be used as input for the soxi command
# Note: NAUTILUS_SCRIPT_SELECTED_FILE_PATHS is an input variable initialized by Nautilus
fullFolderPath=${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}

# The use of " is necesary to preserves whitespace in a single variable because a folder name can have white spaces
f=`echo "$fullFolderPath"`

# DEBUG: 
#zenity --info --text "$f"


# Check if the user has chosen a file with the right click (eg folder are not allowed)
if [ -f "$f" ]; then
	
        # create a temporary file in the /tmp folder where store the output of the soxi command
	LOGFILE=`mktemp -t audio-info.XXXXXX`
	
	soxi "$f" 2>&1 > $LOGFILE 

	# Check if the temp file is empty: if true the input file is not a supported file format
	if [ ! -s "$LOGFILE" ]; then
   	    zenity --error --text="File format not supported ! \n See: http://sox.sourceforge.net/Docs/Features \n for supported format"
	else
	    zenity --text-info --title="Audio File Metadata (Read Only)" --filename=$LOGFILE --width=550 --height=450	

	    # remove the temp file when the user close the zenity window
	    rm -f $LOGFILE
        fi
else
    zenity --error --text="Input file must be an Audio file supported ! \n See: http://sox.sourceforge.net/Docs/Features \n for supported format"
    exit 0
fi

 
 
