#!/bin/sh
##     
## (Nautilus)                       
## SCRIPT: 02_ps_cumcpu_sort.sh
##
## PURPOSE:
##     Lists ALL the processes on 'this' host, highlighting the 'top' processes
##     in terms of the 'ps -e' TIME column (cumulative CPU time), by sorting
##     those processes to the top of the list.
##
##     Uses the 'ps -eo...' command.  
##
## This utility is especially helpful to check for processes on the host
## that may be putting a heavy load on the host (or heavy load on the network)
## --- perhaps unnecessarily and perhaps for DAYS, SLOWING DOWN OTHER JOBS ---
## especially if the host is a server running resource-intensive jobs for days.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a
##             Nautilus directory list.
##             Under 'Scripts', click on this script to run (name above).
##
##
## Created: 2010apr21
## Changed:
############################################################################

## FOR TESTING:
#  set -v
#  set -x

####################################################################
## Prep a temporary filename, to hold the list of filenames.
## 
## We always put the report in the /tmp directory, rather than
## junking up the current directory with this report, which applies to
## processes rather than to the filesystem. Also, the user might
## not have write-permission to the current directory.
####################################################################

  OUTFILE="/tmp/00_ps_cumcpu_sort.lis"
 
  if test -f "$OUTFILE"
  then
     rm -f "$OUTFILE"
  fi



##########################################################################
## SET REPORT HEADING.
##########################################################################

HOST_ID="`hostname`"

echo "\
..................... `date '+%Y %b %d  %a  %T%p'` .......................

ALL PROCESSES ON HOST: $HOST_ID

SORTED BY **Accumulated-CPU-TIME**, since their respective start times,
then by PPID, then by PID.

    The meanings of column headings are given at the bottom of this report.

SORT-FLD
********
hh:mm:ss
CUM. CPU                      hh:mm:ss    hh:mm:ss            (KB)   (KB)" > "$OUTFILE"


##########################################################################
## GENERATE REPORT CONTENTS using a 'ps' command.
##########################################################################

PS_CMD="ps -eo time,uname,pid,ppid,start,etime,%cpu,%mem,rss,vsz,state,sgi_p,tty,args --sort=-time,ppid,pid"

$PS_CMD >> "$OUTFILE"


##########################################################################
## ADD REPORT 'TRAILER'.
##########################################################################

# BASENAME=`basename $0`

echo "
..................... `date '+%Y %b %d  %a  %T%p'` .......................

     The output above is from script

$0

     which was run from host $HOST_ID .

     Command used: 
 
$PS_CMD

............................................................................

Column heading meanings --- of some columns in this formatted listing:

     TIME      cumulative CPU time, "[dd-]hh:mm:ss" format.

     USER      effective user name.

     PID       process ID number of the process.

     PPID      parent process ID.

     STIME     time the command started. If the process was started less
               than 24 hours ago, the output format is "HH:MM:SS", else
               it is "  mmm dd" (where mmm is a three-letter month name).

     ELAPSED   elapsed time since the process was started, in the
               form [[dd-]hh:]mm:ss.

     %CPU      cpu utilization of the process in "##.#" format.
               Currently, it is the CPU time used divided by the time the
               process has been running (cputime/realtime ratio),
               expressed as a percentage. It will not add up to 100%
               unless you are lucky.

     %MEM      ratio of the process's resident set size  to the physical
               memory on the machine, expressed as a percentage.

     RSS       resident set size, the non-swapped physical memory that a
               task has used (in kiloBytes).

     VSZ       virtual memory size of the process in KiB (1024-byte units).

     P	       processor that the process is currently executing on.
               Displays "*" if the process is not currently running or
               runnable. For a 2 processor machine, P will be 0 or 1.

     S	       minimal state display (one character).
                 D    Uninterruptible sleep (usually IO)
                 R    Running or runnable (on run queue)
                 S    Interruptible sleep (waiting for an event to complete)
                 T    Stopped, either by a job control signal or because it is being
	              traced.
                 W    paging (not valid since the 2.6.xx kernel)
                 X    dead (should never be seen)
                 Z    Defunct ("zombie") process, terminated but not reaped by its
	              parent.

     TTY       controlling tty (terminal) for the process. (A question
               mark is printed when there is no controlling terminal.)

     CMD       command with all its arguments as a string. Modifications
               to the arguments may be shown. The output in this column
               may contain spaces. A process marked <defunct> is partly
               dead, waiting to be fully destroyed by its parent.
               Sometimes the process args will be unavailable; when this
               happens, ps will instead print the executable name in
               brackets.

.......................... `date '+%Y %b %d  %a  %T%p %Z'` .................
" >> "$OUTFILE"


##########################################################################
## SHOW REPORT.
##########################################################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &


