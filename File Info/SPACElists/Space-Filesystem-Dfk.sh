#!/bin/sh
##
## Nautilus
## SCRIPT: 00_spac_filsys_dfk.sh
##
## PURPOSE: This utility will look show the space allocated and used
##          in the several file systems on this machine.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a
##             Nautilus directory list.
##             Under 'Scripts', click on this script to run (name above).
##
## Created: 2010apr07
## Changed: 

## FOR TESTING:
#  set -v
#  set -x

#############################################################
## Prep a temporary filename, to hold the list of filenames.
## 
## We always put the report in the /tmp directory, rather than
## junking up the current directory with this report that
## applies to the entire filesystem. Also, the user might
## not have write-permission to the current directory.
#############################################################

  OUTFILE="/tmp/00_space_filsys_dfk_temp.lis"
 
  if test -f "$OUTFILE"
  then
     rm -f "$OUTFILE"
  fi

##########################################################################
## SET REPORT HEADING.
##########################################################################

HOST_ID="`hostname`"

echo "\
......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................

DISK USAGE (in Gigabytes) IN FILE SYSTEMS ON HOST *** $HOST_ID ***


           SORTED BY *PERCENT-USED* --- HIGHEST %-USED AT THE TOP
                      ************
" > "$OUTFILE"

DATAHEAD="\
                                                                    FileSystem
Directory                 ******  ALLOCATED  USED       AVAILABLE   Device-partition,
(Filesystem Mount Point)  % USED  Gigabytes  Gigabytes  Gigabytes   if any
------------------------- ------  ---------- ---------- ----------  -------------------------------------"

##########################################################################
## GENERATE REPORT CONTENTS.
##########################################################################
## Sample output of 'df -k' on Linux:
##
## Filesystem           1K-blocks      Used Available Use% Mounted on
## /dev/sda1             74594118   9818430  60985555  14% /
## /dev/sdb5             76902227   5531130  71371097   8% /home
## none                   1037884        40   1037844   1% /tmp
##########################################################################


   echo "
******************
LOCAL FILE-SYSTEMS:
******************
$DATAHEAD
" >>  "$OUTFILE"


   ## FOR TESTING:
   #  set -x

   df -kl | sed '1d;s/\%/ /g' | sort -n -r -k5 | awk \
      '{printf ("%-25s %6s %11.3f %10.3f %10.3f  %s \n\n", $6, $5, $2/1000000, $3/1000000, $4/1000000, $1)}' \
       >> "$OUTFILE"

   ## FOR TESTING:
   #  set -

##########################################################################
## ADD REPORT 'TRAILER'.
##########################################################################

BASENAME=`basename $0`

echo "
......................... `date '+%Y %b %d  %a  %T%p'` ........................

NOTE1: This file-systems report is SORTED by %-Used .... LARGEST %-Used FIRST.

       Hence the file-system on the first line may be the one of most
       immediate concern, if the %-Used is greater than 85%, say.

.............................................................................
     The output above is from script

         $0

     which ran the 'df' command on host  $HOST_ID .

     The script uses a 'pipe' of several commands (df, sed, sort, awk) like:

         df -kl | sed ... | sort -n -r -k5 |  awk '{printf ( ... ) }'

.............................................................................
NOTE2: The 'l' option of the 'df' command specifies that info is requested
       only for 'local' file systems.  This utility could be enhanced to
       also show 'df' data for 'nfs' mounted file systems.

NOTE3: This utility provides columnar formatting (in Gigabytes only) and sorting
       that is not available by use of the 'df' command by itself.
.............................................................................

......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


###################################################
## Show the file-system space info.
###################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
   
   
