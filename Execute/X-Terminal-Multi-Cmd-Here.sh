#!/bin/sh
##
## Nautilus
## SCRIPT: 00_xTerminal_multiCmd_here.sh
##
## PURPOSE: This script opens an xterm with the command prompt 'positioned'
##          in the directory you select ---
##          and executes a user-specified 'string' of commands.
##          A zenity prompt asks for the command(s), with examples shown.
##
##          xterm is run with the '-hold' parameter, to see error messages
##          if the command fails with a syntax error or whatever.
##
##          Since the '-e' option of xterm accepts only one command (with
##          optional parameters), this script uses a separate, hidden (Nautilus)
##          script, '.eval-cmds4term.sh', to pass the command string to xterm
##          for execution.
##
## HOW TO USE: Right-click on any file (or directory) in a Nautilus
##             directory list.
##             Under 'Scripts', choose this script to run (name above).
##
## Created: 2010apr11
## Changed: 2010

cd "$NAUTILUS_SCRIPT_CURRENT_URI"

#############################
## Prompt for the command(s).
############################

    CMDS="ifconfig"
    CMDS=$(zenity --entry --title "Execute command(s) in an xterm." \
           --text "Enter a string of commands.  Examples:
  1)  grep awk *.sh  --- to find scripts, in this directory, using awk
  2)  grep -i onmouseover *.htm* --- to find HTML, in this dir, using onmouseover
  3)  strings ls --- to see the strings in the 'ls' executable, if I am in its dir, /bin
  4)  uname -a;ifconfig --- to see uname and ifconfig output
  5)  top --- to monitor running processes" \
                --entry-text "ifconfig")

    if test "$CMDS" = ""
    then
       exit
    fi

xterm -fg white -bg black -hold \
      -e ~/.gnome2/nemo-scripts/Execute/.eval-cmds4term.sh "$CMDS"

## Use 'exec'?
# exec xterm -fg white -bg black -hold \
#            -e ~/.gnome2/nemo-scripts/Execute/.eval-cmds4term.sh "$CMDS"
