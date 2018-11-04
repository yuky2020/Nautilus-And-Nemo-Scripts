#!/bin/bash
#Title=hide-show-links
#Title[fr]=cache-montre-les-raccourcis

#==============================================================================
#                               hide-show-links
#
#  author  : SLK
#  version : v2012051401
#  license : Distributed under the terms of GNU GPL version 2 or later
#
#==============================================================================
#
#  description :
#    nautilus-script : hide (show) symlinks creating (deleting) a .hidden file.
#
#  informations :
#    - a script for use (only) with Nemo.
#    - to use, copy to your ${HOME}/.gnome2/nemo-scripts/ directory.
#
#  WARNINGS :
#    - this script must be executable.
#    - package "zenity" must be installed
#
#==============================================================================

#==============================================================================
#                                                                     CONSTANTS

# 0 or 1, if 1 : doesn't create the hidden file
DRY_RUN=0

#------>                                       some labels used for zenity [en]
z_title='hide show links'
z_error_message_cant_create_here='can not creat new dir in this directory !\nEXIT'
z_error_message='create failed !'
z_success_hide_message='links hidden, you can refresh nautilus'
z_success_show_message='links shown, you can refresh nautilus'
z_noop='.hidden file has not been created by this script, cannot remove it.\nEXIT'

#------>                                       some labels used for zenity [fr]
#z_title='cache montre les raccourcis'
#z_error_message_cant_create_here='impossible de creer un repertoire dans ce repertoire !\nEXIT'
#z_error_message='echec de creation !'
#z_success_hide_message='raccourcis caches, vous pouvez recharger nautilus'
#z_success_show_message='raccourcis montres, vous pouvez recharger nautilus'
#z_noop='le fichier .hidden n a pas ete cree par ce script, on ne peut pas le supprimer.\nEXIT'

#==============================================================================
#                                                                INIT VARIABLES

# may depends of your system
FIND='/usr/bin/find'
GREP='/bin/grep'
NOTIFY='/usr/bin/notify-send'
PERL='/usr/bin/perl'
RM='/bin/rm'
ZENITY='/usr/bin/zenity'

# icon for notification
FILEPATH_ICON_NOTIFY='/usr/share/icons/gnome/32x32/actions/system-run.png'

#==============================================================================
#                                                                     FUNCTIONS

function check_bin
{
    err=0
    for bin in $* ; do
        if [ ! -x "$bin" ] ; then
            $ZENITY --error --title "$z_title" \
              --text="$bin $z_err_bin_not_found"
            err=1
        fi
    done
    [ $err -eq 1 ] && exit 1
}

#==============================================================================
#                                                                          MAIN

# lets check for required binaries :
[ -x $ZENITY ] || {
    echo "[ERROR] $ZENITY not found : EXIT"
    exit 1
}
check_bin "$FIND" "$GREP" "$PERL"

# retrieve local current path :
dirpath_current=`echo "$NAUTILUS_SCRIPT_CURRENT_URI" \
  | $PERL -pe '
    s~^file://~~;
    s~%([0-9A-Fa-f]{2})~chr(hex($1))~eg'`

# lets check if current path is writable :
[ -w "$dirpath_current" ] || {
    $ZENITY --error --title "$z_title" \
      --text="$z_error_message_cant_create_here"
    exit 1
}

# lets check if .hidden file is present :
flag_hidden='# hide-show-links'
if [ `$GREP "^${flag_hidden}" -c "$dirpath_current/.hidden"` -ge 1 ] ; then
    # removing .hidden file
    text="$z_success_show_message"
    cmd="$RM -f '$dirpath_current/.hidden'"
elif [ ! -e "$dirpath_current/.hidden" ] ; then
    # creating .hidden file
    text="$z_success_hide_message"
    cmd="$FIND -type l | perl -pe 'BEGIN{print\"${flag_hidden}\n\"}s~^\./~~' > '$dirpath_current/.hidden'"
else
    text="$z_noop"
    cmd=''
fi


### DRY RUN : noop

[ $DRY_RUN -eq 1 ] && {
    $ZENITY --info --title "$z_title" \
      --text="DRY RUN
dirpath_current: $dirpath_current
cmd: $cmd
text: $text"

    exit 0
}


### GO : let's delete/create the .hidden file

if [ -n "$cmd" ] ; then
    eval $cmd
    if [ $? -eq 0 ] ; then
        # success : display message with notification or with zenity
        if [ -x $NOTIFY ] ; then
            $NOTIFY \
              --urgency="low" \
              --icon="$FILEPATH_ICON_NOTIFY" \
              "$z_title" \
              "$text"
        else
            $ZENITY --info --title "$z_title" \
              --text="$text"
        fi
    else
        # error
        $ZENITY --error --title "$z_title" \
          --text="ERROR
dirpath_current: $dirpath_current
cmd:$cmd
text: $text"
        exit 1
    fi
else
    # hidden file has not been created by this script
    $ZENITY --info --title "$z_title" \
      --text="$text"
    exit 1
fi

exit 0


### EOF
