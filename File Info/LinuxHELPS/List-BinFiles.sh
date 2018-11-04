#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_list_binFiles.sh
##
## PURPOSE: List the files currently in the main system
##          'bin' directories --- /bin, /sbin, /usr/bin, etc.
##          This list is shown in an editor, or in whatever
##          GUI display utility is put below.
##
## HOW TO USE: Click on the name of any file (or directory) in a Nautilus
##             directory list.
##             Then right-click and choose this script to run (name above).
##
## Created: 2010apr04
## Changed:

## FOR TESTING:
#  set -v
#  set -x

###############################################################
## Prep a temporary filename, to hold the list of filenames.
##      We put the output file in /tmp, in case the user
##      does not have write-permission in the current directory.
###############################################################

# OUTFILE="00_list_binFiles.lis"
  OUTFILE="/tmp/00_list_binFiles.lis"
 
  if test -f "$OUTFILE"
  then
     rm -f "$OUTFILE"
  fi

######################
## Prepare the list.
######################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

List of Files (mostly executables) in main 'bin' directories
--- on host:  $THISHOST


Some more information is at the bottom of this list.

------------------------------------------------------------------------------
" > "$OUTFILE"


    echo "
####
/bin:
####
" >> "$OUTFILE"
    ls /bin >> "$OUTFILE"

    echo "
#####
/sbin:
#####
" >> "$OUTFILE"
    ls /sbin >> "$OUTFILE"

    echo "
########
/usr/bin:
########
" >> "$OUTFILE"
    ls /usr/bin >> "$OUTFILE"

    echo "
#########
/usr/sbin:
#########
" >> "$OUTFILE"
    ls /usr/sbin >> "$OUTFILE"

    echo "
##############
/usr/local/bin:
##############
" >> "$OUTFILE"
    ls /usr/local/bin >> "$OUTFILE"

echo "
------------------------------------------------------------------------------

The list above was generated by the script

  $0

The list was created with the 'ls' command applied to directories

     /bin /sbin /usr/bin /usr/sbin /usr/local/bin

If you want to change or add some directories,
you can simply edit the script.

------------------------------------------------------------------------------
FOR MORE INFO ON THESE EXECUTABLES:

For some of these executables,
you can type 'man <exe-name>' to see details on how the program
can be used.  ('man' stands for Manual.  It gives you the user
manual for the command/utility.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.

---

Some executables --- like firefox (web browser) and thunderbird
(email reader) and ooffice (word processing, spreadsheet, presentation
editor) --- have their own help built into them.

---

For even more wide-ranging lists of executables on this machine,
go to the 'FINDtools' group of Nautilus scripts, and use the script
'findfils4type_underThisDir' --- and specify type 'executable'.

That list can take more time to generate because it may search through
many more directories and files on the machine. Best not to use it
at a high-level directory like '/' or at a directory under which you
know there are tens of thousands of files.

******* END OF LIST of most of the 'bin' files on host $THISHOST *******
" >> "$OUTFILE"


#######################################
## Show the list of 'bin' filenames.
#######################################

. $HOME/.gnome2/nemo-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &

   
