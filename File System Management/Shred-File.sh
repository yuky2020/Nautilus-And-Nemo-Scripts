#!/usr/bin/env bash
#------------------------------------------------------------------------------
#shred_file Version: 1 Copyright (©) 2011 Josh Barrick josh@barrick.co.cc
# Thanks to Warren Severin for complete re-write.
# http://gnome-look.org/usermanager/search.php?username=warsev
#
# If you'd like to take this over, get in touch.
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#***CAUTION***
#	Do NOT use on device files like /dev/hda.
#	If you need to shred these files, refer to the shred man pages.
#***CAUTION***
#	Use of this script on a file will make recovery impossible,
#	even with the more expensive file recovery solutions.
#
#This script will shred the input file, after confirmation.
#You will also be notified, when shredding is complete. (Should this be
#removed?)
#------------------------------------------------------------------------------

#!/usr/bin/env bash
nfiles="$#"
files=""
for file in "$@" ; do 
if [ ${#files} -gt 0 ] ; then files="$files\n"; fi
files=$files$(basename "$file")
done
zenity --question --title="shred these $nfiles files - REALLY??" --text="$files"
if [ "$?" = 1 ] ; then
exit $?
else
nfile=0
(for file in "$@" ; do
echo \# shredding $(basename "$file")...
shredout=$(shred -u -z -n 1 "$file" 2>&1)
rc=$?
if [ $rc -ne 0 ] ; then
echo "100"
zenity --error --title="No break for you today" --text="$shredout"
exit $rc
else
let nfile++
echo $((nfile * 100 / nfiles))
fi
done ) | zenity --progress --title="Wiping files..." --auto-close \
--percentage=0 --text="starting..." --no-cancel
fi
exit 0
