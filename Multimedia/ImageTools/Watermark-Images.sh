#!/bin/bash


IFS=$'\n'
for file in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
do
  xpath=${file%/*}
  xbase=${file##*/}
  xfext=${xbase##*.}
  xfext="${xfext//[[:space:]]/}"
  xpref=${xbase%.*}

  composite -gravity south -geometry +0+10 "$HOME/Pictures/stamp.png" "${xpath}/${xpref}.${xfext}" "${xpath}/${xpref}_stamped.${xfext}"
done
unset IFS


