#!/bin/bash 
#Title=share-http-here
#Title[fr]=partage-http-ici

#==============================================================================
#                                 share-http-here
#
#  author  : SLK
#  version : v2011010301
#  license : Distributed under the terms of GNU GPL version 2 or later
#
#==============================================================================
#
#  description :
#    nautilus-script : share the current (or selected) dir with http on
#    port 8000
#
#  informations :
#    - a script for use (only) with Nautilus. 
#    - to use, copy to your ${HOME}/.gnome2/nemo-scripts/ directory.
#
#  WARNINGS :
#    - this script must be executable.
#    - package "zenity" must be installed
#
#  THANKS :
#    http://blog.rom1v.com/2009/12/creer-un-serveur-http-en-10-secondes/
#
#==============================================================================

#==============================================================================
#                                                                     CONSTANTS

# 0 or 1  - 1: doesn't share but displays a message
DRY_RUN=0

ETH='eth0'

#------>                                       some labels used for zenity [en]
z_title='share this folder with http on :8000'
z_no_ip="ip not found for interface ${ETH}\nEXIT"
z_port_used="port 8000 already used\nEXIT"
z_confirm_share="do you want to share the folder"
z_from="it will be accessible from a browser at:"
z_sharing="sharing"
z_err_gvfs="cannot acces to directory - check gvfs\nEXIT"
z_err_uri="cannot acces to directory - uri not known\nEXIT"

#------>                                       some labels used for zenity [fr]
#z_title='partager ce repertoire en http sur :8000'
#z_no_ip="ip non trouvee pour l'interface ${ETH}\nEXIT"
#z_port_used="le port :8000 est deja utilise\nEXIT"
#z_confirm_share="partager le repertoire"
#z_from="il sera accessible depuis un navigateur a :"
#z_sharing="partage"
#z_err_gvfs="impossible d'acceder au repertoire - verifiez gvfs\nEXIT"
#z_err_uri="impossible d'acceder au repertoire - uri inconnue\nEXIT"

#==============================================================================
#                                                                INIT VARIABLES

# may depends of your system : (current settings for debian, ubuntu)

GVFSMOUNT='/usr/bin/gvfs-mount'
GREP='/bin/grep'
IFCONFIG='/sbin/ifconfig'
KILL='/bin/kill'
LSOF='/usr/bin/lsof'
PERL='/usr/bin/perl'
PYTHON='/usr/bin/python2.5'
SLEEP='/bin/sleep'
ZENITY='/usr/bin/zenity'

#==============================================================================
#                                                                          MAIN

export LANG=C

# retrieve the first object selected or the current uri
if [ "$NAUTILUS_SCRIPT_SELECTED_URIS" == "" ] ; then
    uri_first_object=`echo -e "$NAUTILUS_SCRIPT_CURRENT_URI" \
      | $PERL -ne 'print;exit'`
else
    uri_first_object=`echo -e "$NAUTILUS_SCRIPT_SELECTED_URIS" \
      | $PERL -ne 'print;exit'`
fi

type_uri=`echo "$uri_first_object" \
  | $PERL -pe 's~^(.+?)://.+$~$1~'`

# try to get the full path of the uri (local path or gvfs mount ?)
if [ $type_uri == "file" ] ; then
    
    filepath_object=`echo "$uri_first_object" \
      | $PERL -pe '
        s~^file://~~;
        s~%([0-9A-Fa-f]{2})~chr(hex($1))~eg'`
    
elif [ $type_uri == "smb" -o $type_uri == "sftp" ] ; then
    if [ -x $GVFSMOUNT ] ; then
        
        # host (and share for smb) are matching a directory in ~/.gvfs/
        
        host_share_uri=`echo "$uri_first_object" \
          | $PERL -pe '
            s~^(smb://.+?/.+?/).*$~$1~;
            s~^(sftp://.+?/).*$~$1~;
            '`
        
        path_gvfs=`${GVFSMOUNT} -l  \
          | $GREP "$host_share_uri" \
          | $PERL -ne 'print/^.+?:\s(.+?)\s->.+$/'`
        
        # now let's create the local path
        path_uri=`echo "$uri_first_object" \
          | $PERL -pe '
            s~^smb://.+?/.+?/~~;
            s~^sftp://.+?/~~;
            s~%([0-9A-Fa-f]{2})~chr(hex($1))~eg'`
        
        filepath_object="${HOME}/.gvfs/${path_gvfs}/${path_uri}"
        
    else
        $ZENITY --error --title "$z_title" --width "320" \
          --text="$z_err_gvfs"
        
        exit 1
    fi
else
    $ZENITY --error --title "$z_title" --width "320" \
      --text="$z_err_uri"
    
    exit 1
fi


# try to retrieve ip address
ip=`$IFCONFIG $ETH 2>/dev/null \
  | $PERL -ne 'print /addr:(\S+)/'`
[ "$ip" == "" ] && { 
    $ZENITY --error --title "$z_title" --width "320" \
      --text="$z_no_ip"
    
    exit 1
}

### CHECK : is port 8000 free ?

$LSOF -i :8000 >/dev/null 2>&1
[ "$?" == "0" ] && { 
    $ZENITY --error --title "$z_title" --width "320" \
      --text="$z_port_used"
    
    exit 1
}


# if object is file : share his directory
if [ -d "$filepath_object" ] ; then
    dirpath_share="$filepath_object"
else
    dirpath_share=`echo "$filepath_object" \
      | $PERL -pe 's|[^/]+$||'`
fi


$ZENITY --question --title "$z_title" --width "320" \
  --text="$z_confirm_share 
\"$dirpath_share\"
$z_from 
\"http://$ip:8000\"" \
  || exit 0


### DRY RUN : noop

[ $DRY_RUN -eq 1 ] && {
    $ZENITY --info --title "$z_title" --width "320" \
      --text="DRY RUN
cmd: $PYTHON -m SimpleHTTPServer
sharing $dirpath_share"
    exit 0
}


### GO : let's share

cd $dirpath_share
$PYTHON -m SimpleHTTPServer 1>/dev/null 2>&1 &
pid=$!

while : ; do $SLEEP 2 ; echo "#$z_sharing \"$dirpath_share\" - \"http://$ip:8000\"" ; done | $ZENITY --progress --title "$z_title" --width "320" \
  --text "$z_sharing" --pulsate --auto-close

$KILL $pid


exit 0


### EOF
