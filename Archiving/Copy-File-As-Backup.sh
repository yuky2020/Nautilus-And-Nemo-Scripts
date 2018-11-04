#!/bin/bash 
#Title=copy-file-as-backup
#Title[fr]=copie-de-sauvegarde

#==============================================================================
#                            copy-file-as-backup
#
#  author  : SLK
#  version : v2011042501
#  license : Distributed under the terms of GNU GPL version 2 or later
#
#==============================================================================
#
#  description :
#    nautilus-script : 
#    creates a backup copy in the same directory, uses date and increments 
#    number for the filename. keeps extension. keeps tar.gz. can use the mtime
#    of the file to backup.
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

# DRY_RUN : 0 or 1  - 1: doesn't copy/move but display a message - 0: copy/move
DRY_RUN=0

# DONT_COPY_BUT_MOVE : 0 or 1 - 1: move the file - 0: copy the file
DONT_COPY_BUT_MOVE=0

# USE_MODIFIED : 0 or 1
#   - 0 : backup filename use the current date
#   - 1 : backup filename use its modification's date. Please choose a FMTBKP 
#         with date AND time (timestamp or hour, min, sec)
USE_MODIFIED=0

# FORMAT OF THE FILE'S BACKUP has 2 parts FMTBKP and NB_DIGIT
#
# FMTBKP : cf. man date
#   - NB_DIGIT : number of digits (incremental if file already exists)
#
# you can choose one of theese following examples or add a newer :
#
#NB_DIGIT='2' ; FMTBKP="+~%Y%m%d-"                # it would copy /tmp/foo.pl to /tmp/foo~20010911-01.pl
#NB_DIGIT='3' ; FMTBKP="+.%Y-%m-%d-v"             # it would copy /tmp/foo.pl to /tmp/foo.2001-09-11-v001.pl
NB_DIGIT='1' ; FMTBKP="+~%Y-%m-%d_%H:%M:%S-copy" # it would copy /tmp/foo.pl to /tmp/foo_2001-09-11_10:30:55_copy1.pl
#NB_DIGIT='3' ; FMTBKP="+~rev"                    # it would copy /tmp/foo.pl to /tmp/foo~rev001.pl


#------>                                       some labels used for zenity [en]
z_title='backup copy'
z_no_object='no object selected\nEXIT'
z_err_gvfs="cannot acces to file - check gvfs\nEXIT"
z_err_unknown_uri="cannot acces to file - uri not known\nEXIT"
z_continue_not_a_file_nor_dir="is not a file nor a directory\nSKIPPING"
z_continue_bad_file_name="contains quote or double quote\nSKIPPING"

#------>                                       some labels used for zenity [fr]
#z_title='copie de sauvegarde'
#z_no_object='aucun objet selectionne\nEXIT'
#z_err_gvfs="impossible d'acceder au fichier - verifiez gvfs\nEXIT"
#z_err_unknown_uri="impossible d'acceder au fichier - uri inconnue\nEXIT"
#z_continue_not_a_file_nor_dir="n'est ni un fichier ni un repertoire\nSUITE"
#z_continue_bad_file_name="contient une quote ou double quote\nSUITE"

#==============================================================================
#                                                                INIT VARIABLES

# may depends of your system
BASENAME='/usr/bin/basename'
CP='/bin/cp'
DATE='/bin/date'
DIRNAME='/usr/bin/dirname'
GVFSMOUNT='/usr/bin/gvfs-mount'
GREP='/bin/grep'
LS='/bin/ls'
MV='/bin/mv'
PERL='/usr/bin/perl'
STAT='/usr/bin/stat --format=%Y'
ZENITY='/usr/bin/zenity'

#==============================================================================
#                                                                          MAIN

[ -x "$ZENITY" ] || {
    echo "[ERROR] $ZENITY not found : EXIT"
    exit 1
}

### CHECK : is object selected ?

[ "$NAUTILUS_SCRIPT_SELECTED_URIS" == "" ] && {
    $ZENITY --error --title "$z_title" \
      --text="ERROR $z_no_object"
    
    exit 1
}

# FOR EACH OBJECT SELECTED ...
for uri_current_object in `echo -e "$NAUTILUS_SCRIPT_SELECTED_URIS"` ; do
    
    # try to get the full path of the uri (local path or gvfs mount ?)
    
    type_uri=`echo "$uri_current_object" | $PERL -pe 's~^(.+?)://.+$~$1~'`
    if [ $type_uri == "file" ] ; then
        
        filepath_object=`echo "$uri_current_object" \
          | $PERL -pe '
            s~^file://~~;
            s~%([0-9A-Fa-f]{2})~chr(hex($1))~eg'`
        
    elif [ $type_uri == "smb" -o $type_uri == "sftp" ] ; then
        if [ -x $GVFSMOUNT ] ; then
            
            # host (and share for smb) are matching a directory in ~/.gvfs/
            
            host_share_uri=`echo "$uri_current_object" \
              | $PERL -pe '
                s~^(smb://.+?/.+?/).*$~$1~;
                s~^(sftp://.+?/).*$~$1~;
                '`
            
            path_gvfs=`${GVFSMOUNT} -l  \
              | $GREP "$host_share_uri" \
              | $PERL -ne 'print/^.+?:\s(.+?)\s->.+$/'`
            
            # now let's create the local path
            path_uri=`echo "$uri_current_object" \
              | $PERL -pe '
                s~^smb://.+?/.+?/~~;
                s~^sftp://.+?/~~;
                s~%([0-9A-Fa-f]{2})~chr(hex($1))~eg'`
            
            filepath_object="${HOME}/.gvfs/${path_gvfs}/${path_uri}"
            
        else
            $ZENITY --error --title "$z_title" \
              --text="ERROR $z_err_gvfs"
            exit 1
        fi
    else
        $ZENITY --error --title "$z_title" \
          --text="ERROR $z_err_unknown_uri"
        exit 1
    fi
    
    # SKIP if filename contains " or '
    is_object_name_ok=`echo "$uri_current_object" \
      | $PERL -ne '/\%(22|A0)/&&print"0"'`
    [ $is_object_name_ok -eq 0 ] && {
        $ZENITY --error --title "$z_title" \
          --text="WARNING $filepath_object $z_continue_bad_file_name"
        continue
    }
    
    
    ### CHECK : is file or dir ?
    
    [ -f "$filepath_object" -o -d "$filepath_object" ] || {
        $ZENITY --error --title "$z_title" \
          --text="WARNING $filepath_object $z_continue_not_a_file_nor_dir"
        continue
    }
    
    # retrieve date-time infos
    if [ $USE_MODIFIED -eq 1 ] ; then
        dh=`${DATE} ${FMTBKP} -d@$(${STAT} "${filepath_object}")`
    else
        dh=`${DATE} ${FMTBKP}`
    fi
    
    # retrieve file infos : name and extension - keep hidden files (dot
    # beginning) - keep tar.gz as a unique extension
    dirpath_object=`$DIRNAME "$filepath_object"`
    filename_object=`$BASENAME "$filepath_object" \
      | $PERL -pe 's/(.+?)\.(\w+|tar\.gz)$/$1/i'`
    extension_object=`$BASENAME "$filepath_object" \
      | $PERL -ne '/.+?(\.(\w+|tar\.gz))$/i&&print$1'`
    
    # increment last digits if new name exists
    filename_backup=`$LS -A "$dirpath_object" \
      | $PERL -lne '
        $[=1;
        /^'"$filename_object"''$dh'(\d+)'$extension_object'$/ && $s[($1+0)]++;
        END{
          for(@s){
            ($_&&++$i)||last
          }
          printf("'"$filename_object"''$dh'%0'$NB_DIGIT'd'$extension_object'",++$i)
        }'`
    
    if [ $type_uri == "file" ] ; then
        # local file system : keep permissions
        cmd="$CP -pr '$filepath_object' '$dirpath_object/$filename_backup'"
    else
        cmd="$CP -r '$filepath_object' '$dirpath_object/$filename_backup'"
    fi
    if [ $DONT_COPY_BUT_MOVE -eq 1 ] ; then
        cmd="$MV '$filepath_object' '$dirpath_object/$filename_backup'"
    fi
    
    
    ### DRY RUN : noop
    
    [ $DRY_RUN -eq 1 ] && {
        $ZENITY --info --title "$z_title" \
          --text="DRY RUN:
uri_current_object:$uri_current_object
filepath_object:$filepath_object
dirpath_object:$dirpath_object
filename_object:$filename_object
extension_object:$extension_object
filename_backup:$filename_backup
\nCOMMAND: $cmd"
        continue
    }
    
    
    ### GO : let's copy
    
    eval "$cmd"
    
    # first error exits
    [ $? -eq 0 ] || {
        $ZENITY --error --title "$z_title" \
        --text="ERROR\norig: \"$filepath_object\"\nnew: \"$dirpath_object/$filename_backup\"\nEXIT"
        
        exit 1
    }
    
done   # END FOR EACH OBJECT SELECTED.

exit 0


### EOF
