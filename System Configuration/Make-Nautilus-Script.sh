#!/bin/sh
# make_nautilus_script: copies the selected file(s) to ~/Nautilus/scripts
# and makes it executable.  It will overwrite without warning.
for arg 
do

 cp "$arg" ~/.gnome/nemo-scripts/
 chmod u+x ~/.gnome/nemo-scripts/"$arg"
 
done