#!/bin/sh
#Nautilus Script to convert selected PNG files to a multi-page PDF file
#V.1.0
#Requires "imagemagick" package which includes "convert"
#Please Note: This script assumes all the selected files have the same (case sensitive) png extension
#ToDo: Accept case insensitive extensions
#
#make tmp dir and file list
mkdir "$HOME/.local/share/nautilus/tmp"
echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" > "$HOME/.local/share/nautilus/tmp/SelectedFilesList.txt"
cat "$HOME/.local/share/nautilus/tmp/SelectedFilesList.txt" | \
sed -e 's/^/cp "/g' | \
sed -e 's/$/" "$HOME\/\.local\/share\/nautilus\/tmp\/"/g' | \
#remove empty lines and make tmp script file
sed -e 's/^cp "" "$HOME\/\.local\/share\/nautilus\/tmp\/"$//g' | \
sed -e 's/^" "$HOME\/\.local\/share\/nautilus\/tmp\/"$//g' | \
sed -e '/^\s*$/d' > "$HOME/.local/share/nautilus/tmp/SelectedFilesList.sh"
chmod 755 "$HOME/.local/share/nautilus/tmp/SelectedFilesList.sh"
"$HOME/.local/share/nautilus/tmp/SelectedFilesList.sh"
#process tmp files 
convert "$HOME/.local/share/nautilus/tmp/*.png" "$PWD/Merged.pdf"
#remove temp files
rm -Rf "$HOME/.local/share/nautilus/tmp"
#open final file
xdg-open "$PWD/Merged.pdf"