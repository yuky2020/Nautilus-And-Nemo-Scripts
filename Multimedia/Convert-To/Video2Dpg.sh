#!/bin/bash

#######################################
# videotodpg.sh                       #
# Convert video to dpg                #
# by Fraz (http://www.tutorial360.it) #
#######################################

# Program required:
# * mplayer
# * mencoder
# * mpeg_stat
# * dpgconv (python program)
# * python
# * zenity

# full path dpgconv file
path_dpgconv="$HOME/.gnome2/dpgconv/dpgconv-9.py"

# path dpgconv directory
path_dir_dpgconv=${path_dpgconv%/*}"/"

newextension=".dpg"

# Check if all required programs are found
for command in mplayer mencoder mpeg_stat python zenity
do
    if [ ! $(which $command) ]
    then
        zenity --error --text "Could not find \"$command\" application."
        exit 1
    fi
done

# Check if dpgconv program is found
if [ ! -f $path_dpgconv ] ; then
        zenity --error --text "Could not find dpgconv application."
        exit 1
fi

# Nautilus current directory
if [ "$1" = "" ];then
	wdir=${NAUTILUS_SCRIPT_CURRENT_URI#file://}
	wdir=${wdir//%20/ }
else
	filetype=$(file "$1")
	filetype=${filetype##*: }

	if [ "$filetype" = "directory" ];then
		wdir=${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS%%$1*}
		wdir=$wdir/$1
	else
		wdir=${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS%%$1*}
	fi
fi

# Prevent splitting of $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS on spaces by
# setthing Bash Internal Field Seperator to newline
IFS="
"

# Get file paths
FILES=($NAUTILUS_SCRIPT_SELECTED_FILE_PATHS)
FILES_COUNT=${#FILES[@]}

# Use plural/singular for progress message
if [ $FILES_COUNT -gt 1 ]
then
  file_string="files"
else
  file_string="file"
fi

# Initialise progress bar file counter
current_file=1

# Process files, if there are any
if [ $FILES_COUNT -gt 0 ]
then

    for movie_file in ${FILES[@]}
    do

	# convert video
	python $path_dpgconv $movie_file

	# Itentify extension files
        # extension=${movie_file:(-4)}
	extension=${nome_file/*./}

	# name new file
	newfile=${movie_file/$extension/$newextension}

	path_newfile=$path_dir_dpgconv$newfile

	# move newfile in nautilus directory
	if [ -f $path_newfile ] ; then
		mv $path_newfile $wdir
	fi

        # Send percentage to Zenity progress bar
        percentage=$(echo "$current_file * 100 / $FILES_COUNT" | bc)
        current_file=$((current_file + 1))
        echo $percentage

    # Pipe loop output to Zenity progress bar
    done | zenity --progress --title="Converting video" --text="Processing $FILES_COUNT "$file_string"..." --auto-close

else
    # this program cannot be executed on terminal
    echo "Please run this script via Nautilus (GNOME file manager)"
fi

exit 0

