#!/bin/sh
##
## Nautilus
## SCRIPT: 00_spac_subdirs_all_levs_sizesort_du.sh
##
## PURPOSE: This utility will show the space used by all subdirs
##          at all levels under the 'current' directory. Uses 'du'.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a
##             Nautilus directory list.
##             Under 'Scripts', choose this script to run (name above).
##
## Created: 2010apr07
## Changed: 

## FOR TESTING:
#  set -v
#  set -x

############################################################
## Prep a temporary filename, to hold the list of filenames.
##      If the user does not have write-permission to the
##      current directory, we put the list in /tmp.
############################################################

  OUTFILE="00_space_subdirs_all_levs_sizesort_temp.lis"
  DIRNAME="`pwd`"
  if test ! -w "$DIRNAME"
  then
     OUTFILE="/tmp/$OUTFILE"
  fi

####################################################################
## NOTE:
## We could simply put the report in the /tmp directory, rather than
## junking up the current directory with this report.
##
#  OUTFILE="/tmp/00_space_subdirs_all_levs_sizesort_temp.lis"
##
## BUT it might be handy to have the last listing to refer to, in
## the directory to which the listing applies.
####################################################################

  if test -f "$OUTFILE"
  then
     rm -f "$OUTFILE"
  fi

   HOST_ID="`hostname`"


  ############################################################
  ## IF THE DIRECTORY SPECIFIED IS '/' or '/usr' or '/home',
  ## POP A MSG AND EXIT.
  ############################################################

   if test \( "$DIRNAME" = "/"  -o  \
              "$DIRNAME" = "/usr"  -o  "$DIRNAME" = "/usr/" -o \
              "$DIRNAME" = "/home" -o  "$DIRNAME" = "/home/" \)
   then

    JUNK=`zenity -- question --title "SubdirSizes,ALL-Levels: EXITING" \
          --text "\
The directory specified was *** $DIRNAME ***
on host $HOST_ID

-- one of the 'REALLY BIG' directories:  '/' or '/usr' or '/home'.

There are MANY, MANY THOUSANDS of files in these dirs --- whose sizes would
have to be added up to answer your query.   EXITING ...

Please change your query to a more specific 'root' directory, like
  /bin  /boot  /cdrom  /dev   /etc      /lib  /media  /mnt
  /opt  /proc  /root   /sbin  /selinux  /srv  /sys    /tmp  /var
OR a specific '/usr' sub-directory, like
  /usr/bin    /usr/games    /usr/include   /usr/lib    /usr/lib32
  /usr/lib64  /usr/local    /usr/sbin      /usr/share  /usr/src
OR a specific user's home directory.
If the root directory allocation on the local machine is nearly full,
per 'df' command, the most likely 'culprits' are  '/var'  or  '/usr/local'."`

     exit

   fi


  ############################################################
  ## WARN THE USER ABOUT HUGE DIRECTORIES.  GIVE THEM A CANCEL
  ## A CANCEL OPTION.
  ############################################################
 
    zenity --question --title "SubdirSizes,ALL-Levels: BIG_DIRECTORY_warning" \
           --text "\
IF the directory specified on $HOST_ID, namely
   $DIRNAME
is a directory that contains MANY THOUSANDS of
sub-directories (and even more files), it could take a long time
to generate the SUB-DIRECTORY-SIZES (ALL-LEVELS) report.

If this query takes a long time, you can use a command like
        'ps -fu $USER'
on the host --  $HOST_ID -- to check that the query is running.

If you want to cancel the query, you could kill the running 'du' command.

Cancel or OK (Go)?"

## POSSIBLE TEXT TO ADD/SUBSTITUTE ABOVE.
# One option is to try a lower-level directory
# that is likely to have MANY HUNDREDS of
# sub-directories (or less), rather than MANY THOUSANDS.
# 
# Another (fast-response) option, if you want to set up a cron job
# generate a SUBDIRS SIZE REPORT Utility that is a weekly snapshot
# of the subdirectories under the root (/) directory or some other
# very large directory or directories.

  if test $? = 0
  then
     ANS="OK"
  else
     ANS="Cancel"
  fi

  if test "$ANS" = "Cancel"
  then
     exit
  fi



  #####################################################################
  ## DIRECTORY CHECKs.
  #####################################################################
  ## CHECK THAT THE DIRNAME IS ACCESSIBLE/EXISTS 
  ## -- on $HOST_ID.
  #####################################################################
  ## For a slightly different technique of handling 'stdout & stderr'
  ## (with 2>&1), see $FEDIR/scripts/find_big_or_old_files4dir_bygui
  #####################################################################

  ## FOR TESTING:
  #  set -x

  DIRCHECK=`ls -d $DIRNAME 2> /dev/null`


  if test "$DIRCHECK" = ""
  then

     zenity --question --title "Exiting." \
            --text "\
Specified Directory: $DIRNAME

Not found or does not exist, according to $HOST_ID.

Exiting.
"

     exit

  fi



  ##########################################################################
  ## SET REPORT HEADING on size of sub-directories.
  ##########################################################################

  echo "\
......................... `date '+%Y %b %d  %a  %T%p'` .......................

DISK USAGE (in Megabytes) IN *ALL* SUB-DIRECTORIES

OF DIRECTORY:   $DIRNAME    

ON HOST:        ${HOST_ID}

                             SORTED BY *SIZE* --- BIGGEST SUB-DIRECTORIES
                             AT THE TOP.

                             This report was generated by running the
                             'du' command on $HOST_ID .

                             Total usage is shown on the first line, for the
                             top-level directory.
SIZE-SORT
**************
Disk usage
(Megabytes)    Subdirectory name
-------------- ------------------------
TerGigMeg.Kil
  |  |  |   |" > "$OUTFILE"


  ##########################################################################
  ## GENERATE REPORT CONTENTS.  (from Local or Remote host)
  ##########################################################################

    ## FOR TESTING:
    #  set -x

    # du -k "$DIRNAME" | sort -k1nr | \

    du -k "$DIRNAME" | sort +0 -1nr | \
                    awk '{printf ("%13.3f  %s\n", $1/1000, $2 )}' >> "$OUTFILE"

     ##                          | fold -78 >> "$OUTFILE"

     ## FOR TESTING:
     #  set -


  ########################################################################
  ## Add TRAILER to report.
  ########################################################################

  echo "\
  |  |  |   |
TerGigMeg.Kil
-------------- ------------------------
(Megabytes)    Subdirectory name
Disk usage
**************
SIZE-SORT

......................... `date '+%Y %b %d  %a  %T%p'` .......................

     The output above was generated by the script

  $0

     which ran the 'du' command on host $HOST_ID .

-----------------
PROCESSING METHOD:

     The script runs a 'pipe' of several commands (du, sort, awk) like:

         du -k <dirname> | sort +0 -1nr | awk '{printf ( ... )}'

     on the specified host,  $HOST_ID .
     
------------
FEATURE NOTE:

     This utility provides size-sorting and columnar-formatting
     that is not available by using only the 'du' command.

......................... `date '+%Y %b %d  %a  %T%p'`........................
" >> "$OUTFILE"


#################################################
## Show the directories space-used info.
#################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &


