#!/bin/sh
##
## Nautilus
## SCRIPT: eval_cmds4term
##
## PURPOSE:  To pass multiple commands to 'xterm -hold -e' , 'xterm -e' and
##           'gnome-terminal -e'.  Examples below.
##
##           This script is intended to get around the limitation that 'xterm'
##           (and all other such term commands) allow only a single script/cmd
##           (and input parms) after the '-e'.
##
##           In particular, I wanted to be able to pause gnome-terminal so that
##           it did not close after a command completes --- so I can see (error)
##           messages to stdout and stderr, if any. No luck in 2010 Apr.
##
## HOW TO USE: In Nautilus, go to the directory in which you want to enter
##             a command(s). Right-click on any file in the directory and
##             choose to run the Nautilus script
##                       00_xTerminal_multiCmd_here.sh
##             which uses this script.
##
##  ****
##  NOTE: User may have to 'escape' some special characters, like *,
##        using a backslash, or whatever.
##  ****
##        See examples (what worked, what did not work) below.
############################################################################
## CALLED BY:  Nautilus script
##                      00_xTerminal_multiCmd_here.sh
##
############################################################################
## WHAT WORKED, WHAT DIDN'T:
##
## A few early test cases:
##
##  xterm -hold -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'pwd;pwd'
##  xterm -hold -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh "pwd;pwd"
##  xterm -hold -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'echo "Wait..." ; pwd'
##
## WORKED on Linux (Ubuntu).
## This was NOT the case on SGI IRIX. I needed to escape the semicolon. Example:
## 'pwd\;pwd' rather than 'pwd;pwd'.
##
## You can 'paste' the test commands at a command prompt in a terminal window,
## such as in a gnome-terminal.
##
##---------------------
## TESTS to use 'read' or 'sleep' to keep the terminal from closing:
##
## xterm -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'pwd;pwd;read INPUT'
## WORKED. This was NOT the case on SGI IRIX.
## And, as expected, hitting the Enter key caused the terminal to close.
##
## xterm -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'pwd;sleep 3'
## WORKED. Terminal closed after 3 seconds.
## AND
## xterm -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'ls -l $HOME/*.txt ; sleep 5'
## WORKED. Terminal closed after 5 seconds. Did not need to escape the '*'.
##
## xterm -hold -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh \
##         'ls -l $HOME/*.txt ; echo "*** Press Enter to continue." ; read INPUT'
## WORKED. NOTE: Did NOT have to escape the double-quotes nor the asterisk.
##
##-----------------------------
## gnome-terminal TESTS:
##
## HOWEVER
## gnome-terminal -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'pwd;pwd;read INPUT'
## DID NOT WORK, and not with double-quotes. And I do not know how to get it to
## stay open to see error messages. May have to look for a log file. Where?
## Couldn't find one in /var/log.
##
## gnome-terminal -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'pwd;sleep 3'
## DID NOT WORK, and not with double-quotes. Don't know why.
## 
## The 'gnome-terminal' man help says "GNOME  Terminal  emulates  the xterm program"
## BUT that certainly isn't the case here. There are lots of differences --- such as
## not even implementing the '-hold' option. GNOME Terminal is a FEATURE-POOR emulation.
## How is anyone expected to test a (non-trivial) command passed to gnome-terminal???
##
## NOTE:
## gnome-terminal -e 'sleep 3'
## and
## gnome-terminal -e "sleep 3"
## WORK. Not much consolation. No help. Nothing useful there.
##---------------------
## TESTS answering the 'read' prompt:
##
## xterm -hold -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh \
##               'pwd;pwd;read IN;echo "IN: $IN"'
## WORKS. The terminal is held open after the echo.
## As expected, without the '-hold', the terminal pauses at the 'read', but
## it closes as soon as the Enter key is pressed after any characters are entered. 
##
##--------------------
## Additional NOTE:
##  ~/.gnome2/nemo-scripts/.eval_cmds4term.sh  'pwd;pwd'
##  executes both of the pwd's, when there is no 'xterm -hold -e'.
## This was NOT the case on SGI IRIX.
############################################################################
##
## Created: 2010apr11 
## Changed: 2010 
##

## For testing:
# echo "INPUT: $*"

## eval "$*"   
## WORKS!!  See tests documented in comments above.


  eval "$*"
 
## TRIED eval '$*'
## SINGLE QUOTES DID NOT WORK WELL. 
## xterm -hold -e ~/.gnome2/nemo-scripts/.eval_cmds4term.sh 'pwd;sleep 3'
## GAVE THE ERROR MESSAGE
## eval: 1: pwd;sleep: not found

## ALSO WORKED --- on SGI-IRIX:
# for line in "$*"
# do
#    eval $line
# done
