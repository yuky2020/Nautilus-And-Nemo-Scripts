#!/bin/bash
#Title=open-the-link-target-in-nautilus
#Title[fr]=ouvrir-le-repertoire-cible-dans-nautilus

#==============================================================================
#                     open-the-link-target-in-nautilus
#
#  author  : SLK
#  version : v2011051501
#  license : Distributed under the terms of GNU GPL version 2 or later
#
#==============================================================================
#
#  description :
#    nautilus-script : 
#    opens the target of a symbolic link of the selected object; if 
#    the target of the symbolic link is a file, opens the parent folder
#
#  informations :
#    - a script for use (only) with Nautilus. 
#    - to use, copy to your ${HOME}/.gnome2/nemo-scripts/ directory.
#
#  WARNINGS :
#    - this script must be executable.
#    - package "zenity" must be installed
#
#==============================================================================

#==============================================================================
#                                                                     CONSTANTS

# 0 or 1  - 1: doesn't open but displays a message
DRY_RUN=0

#------>                                       some labels used for zenity [en]
z_title='open the link target in nautilus'
z_err_bin_not_found='not found\nEXIT'
z_no_object='no object selected\nEXIT'
z_info_target='path of the target'
z_choice_open_nautilus='open target in nautilus'
z_choice_open_file='open file with default application'
z_choice_display_filepath='open a messagebox to copy filepath'

#------>                                       some labels used for zenity [fr]
#z_title='ouvrir le repertoire cible dans nautilus'
#z_err_bin_not_found='introuvable\nEXIT'
#z_no_object='aucun objet selectionne\nEXIT'
#z_info_target='chemin de la cible'
#z_choice_open_nautilus='ouvrir la cible dans nautilus'
#z_choice_open_file='ouvrir le fichier avec le programme par defaut'
#z_choice_display_filepath='ouvrir une boite de dialogue affichant le chemin du fichier'


#==============================================================================
#                                                                INIT VARIABLES

# may depends of your system
DIRNAME='/usr/bin/dirname'
GREP='/bin/grep'
NAUTILUS='/usr/bin/nautilus'
PERL='/usr/bin/perl'
READLINK='/bin/readlink'
XDG_OPEN='/usr/bin/xdg-open'
ZENITY='/usr/bin/zenity'

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
[ -x "$ZENITY" ] || {
    echo "[ERROR] $ZENITY not found : EXIT"
    exit 1
}
check_bin "$DIRNAME" "$GREP" "$NAUTILUS" "$PERL" "$READLINK"

# lets check if object is selected :
[ "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" == "" ] && {
    $ZENITY --error --title "$z_title" \
      --text="$z_no_object"
    exit 1
}

# retrieve the first object selected :
first_object=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" \
  | $PERL -ne 'print;exit'`

# lets check if local path :
[ `echo "$first_object" | $GREP -c "^/"` -eq 0 ] && {
    $ZENITY --error --title "$z_title" \
    --text="[ERROR] $first_object has not a valid path\nEXIT"
    exit 1
}


# retrieve the target path :
if [ -L "$first_object" ] ; then
    # symbolic link
    target=`$READLINK -f "$first_object"`
else
    # not a symbolic link :
    target="$first_object"
fi

if [ -d "$target" ] ; then
    # target is a directory
    target_to_open_in_nautilus="$target"
    
else
    # target is a file, let's take the parent directory
    target_to_open_in_nautilus=`$DIRNAME "$target"`

fi


### DRY RUN : noop

[ $DRY_RUN -eq 1 ] && {
    $ZENITY --info --title "$z_title" \
      --text="<b>DRY RUN</b>
first_object: $first_object
target: $target
target_to_open_in_nautilus: $target_to_open_in_nautilus"
    exit 0
}


### GO : let's open

choice=`$ZENITY --list --title="$z_title" --width="500" --height="200" \
  --text="<b>$z_info_target</b>\n$target" \
  --radiolist --column "" --column "action" \
  TRUE "$z_choice_open_nautilus" \
  FALSE "$z_choice_open_file" \
  FALSE "$z_choice_display_filepath"`

case $choice in
    "$z_choice_open_nautilus")
        $NAUTILUS --no-desktop "$target_to_open_in_nautilus"
    ;;
    "$z_choice_open_file")
        $XDG_OPEN "$target"
    ;;
    "$z_choice_display_filepath")
        $ZENITY --entry --title="$z_title" --width="500" \
          --text="$z_info_target" \
          --entry-text="$target" &
    ;;
    *)
        exit 1
    ;;
esac


exit 0


### EOF
