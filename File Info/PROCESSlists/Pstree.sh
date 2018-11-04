#!/bin/sh
##
## (Nautilus)
## SCRIPT: 01_pstree.sh
##
## PURPOSE: Runs the 'pstree' command putting the output in a text file.
##          Shows the text file in a text file browsing utility or
##          a text editor.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a
##             Nautilus directory list.
##             Under 'Scripts', click on this script to run (name above).
##
## Created: 2010apr21
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

  OUTFILE="/tmp/01_pstree.lis"
 
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

PROCESS TREE ON HOST *** $HOST_ID ***

        PROCESSES WITH THE SAME ANCESTOR
        ARE SORTED BY  PROCESS ID
                       **********
" > "$OUTFILE"


##########################################################################
## Run 'pstree' to GENERATE REPORT CONTENTS.
##########################################################################

   ## FOR TESTING:
   #  set -x

   pstree -punaAl >> "$OUTFILE"

   ## FOR TESTING:
   #  set -

##########################################################################
## ADD REPORT 'TRAILER'.
##########################################################################

# BASENAME=`basename $0`

echo "
......................... `date '+%Y %b %d  %a  %T%p'` ........................

   The output above is from script

$0

   which ran the 'pstree -punaAl' command on host  $HOST_ID .

.............................................................................

NOTE1: 
       pstree visually merges identical branches by  putting  them  in	square
       brackets and prefixing them with the repetition count, e.g.

	   init-+-gettyps
		|-getty
		|-getty
		|-getty

       becomes

	   init---4*[getty]


       Child  threads  of a process are found under the parent process and are
       shown with the process name in curly braces, e.g.

	   icecast2---13*[{icecast2}]


NOTE2: Here is a description of the '-punaAl' options:

       -p     Show  PIDs.  PIDs  are  shown  as decimal numbers in parentheses
	      after each process name. -p implicitly disables compaction.

       -u     Show uid transitions. Whenever the uid of a process differs from
	      the uid of its parent, the new uid is shown in parentheses after
	      the process name.

       -n     Sort processes with the same ancestor by PID instead of by name.
	      (Numeric sort.)

       -a     Show command line arguments. If the command line of a process is
	      swapped out, that process is shown in parentheses. -a implicitly
	      disables compaction.

       -A     Use ASCII characters to draw the tree.

       -l     Display long lines. By default, lines are truncated to the  dis-
	      play  width or 132 if output is sent to a non-tty or if the dis-
	      play width is unknown.


......................... `date '+%Y %b %d  %a  %T%p %Z'` ........................
" >> "$OUTFILE"


##################################################
## Show the list of filenames that match the mask.
##################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
   
