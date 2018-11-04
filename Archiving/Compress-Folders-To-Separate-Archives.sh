#!/bin/bash

# compress each folder into separate 7z archives
# to use: just select from inside directory where the subfolders you want archived

for folder in */
do
  7z a -mx9 -mmt "/home/$USER/Temp/backups/${folder%/}.7z" "$folder"
done
