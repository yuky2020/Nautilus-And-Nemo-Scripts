#!/usr/bin/perl -W
#Title=open-terminal-here
#Title[fr]=ouvrir-un-terminal-ici

#==============================================================================
#                           open-terminal-here
#
#  author  : SLK
#  version : v2011062101
#  license : Distributed under the terms of GNU GPL version 2 or later
#
#==============================================================================
#
#  description :
#    nautilus-script : 
#    opens a terminal in the selected directory.
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

use strict ;

#==============================================================================
#                                                                     CONSTANTS

# 0 or 1, if 1 : doesn't open the terminal but displays a message
my $DRY_RUN = 0 ;

# choose (or add !) your language :
my $lang = 'en' ;
#my $lang = 'fr' ;

my %LOC = () ;

$LOC{'en'}{'title'} = 'open terminal here' ;
$LOC{'en'}{'error'} = 'can not open a terminal here !' ;
$LOC{'en'}{'chkgvfs'} = 'can not acces to object, check gvfs or uri !' ;

$LOC{'fr'}{'title'} = 'ouvrir un terminal ici' ;
$LOC{'fr'}{'error'} = 'impossible d\'ouvrir un terminal ici !' ;
$LOC{'fr'}{'chkgvfs'} = 'impossible d\'acceder a l\'objet, verifiez gvfs ou l\'uri !' ;

#==============================================================================
#                                                                INIT VARIABLES

my $NAUTILUS_SCRIPT_CURRENT_URI = $ENV{'NAUTILUS_SCRIPT_CURRENT_URI'} ;
my $NAUTILUS_SCRIPT_SELECTED_URIS = $ENV{'NAUTILUS_SCRIPT_SELECTED_URIS'} ;

# may depends of your system : (current settings for debian, ubuntu)
my $GVFSMOUNT = '/usr/bin/gvfs-mount' ;
my $ZENITY = '/usr/bin/zenity' ;

my $dirpath_here = '' ;
my $uri_first_object = '' ;
my $filepath_object = '' ;
my $working_directory = '' ;

#==============================================================================
#                                                                          MAIN


# retrieve first clicked object
if($NAUTILUS_SCRIPT_SELECTED_URIS eq "" )
{
  ($uri_first_object) = split("\n", $NAUTILUS_SCRIPT_CURRENT_URI) ;
}
else
{
  ($uri_first_object) = split("\n", $NAUTILUS_SCRIPT_SELECTED_URIS) ;
}

if($uri_first_object =~ m#^file://#)
{
    $filepath_object = $uri_first_object ;
    $filepath_object =~ s|^file://|| ;
    $filepath_object =~ s|%([0-9A-Fa-f]{2})|chr(hex($1))|eg ;
}
elsif(($uri_first_object =~ m#^(smb|sftp)://#) && (-x $GVFSMOUNT))
{
    # host and share mounted are matching a directory in ~/.gvfs/
    my $host_share_uri = '' ;
    $host_share_uri = $uri_first_object ;
    $host_share_uri =~ s|^(smb://.+?/.+?/).*$|$1| ;
    $host_share_uri =~ s|^(sftp://.+?/).*$|$1| ;
    $host_share_uri = quotemeta($host_share_uri) ;
    
    my $path_gvfs = '' ;
    open(my $fh_IN, ${GVFSMOUNT} .' -l |') || die ;
    while(<$fh_IN>)
    {
        $path_gvfs = $1 if(/^.+?:\s(.+?)\s-\>\s${host_share_uri}$/) ;
    }
    close $fh_IN ;
    
    # now let's determine the local path
    my $path_uri = '' ;
    $path_uri = $uri_first_object ;
    $path_uri =~ s|^smb://.+?/.+?/|| ;
    $path_uri =~ s|^sftp://.+?/|| ;
    $path_uri =~ s|%([0-9A-Fa-f]{2})|chr(hex($1))|eg ;
    $filepath_object = $ENV{'HOME'} .'/.gvfs/'. $path_gvfs .'/'. $path_uri ;
}
else
{
    system $ZENITY .' --error --title="'. $LOC{$lang}{'title'} .'" --text="'. $LOC{$lang}{'chkgvfs'} .'"' ;
    exit 1 ;
}

if(-d $filepath_object)
{
    # will open terminal in the selected object if a directory
    $working_directory = $filepath_object ;
}
elsif(-f $filepath_object)
{
    # will open terminal in the parent directory if a file
    $working_directory = $filepath_object ;
    $working_directory =~ s|[^/]+$|| ;
}
else
{
    system $ZENITY .' --error --title="'. $LOC{$lang}{'title'} .'" --text="'. $LOC{$lang}{'error'} .'"' ;
    exit ;
}

if($DRY_RUN)
{
    system $ZENITY .' --info --title="'. $LOC{$lang}{'title'} .'" --text="'. $working_directory .'"' ;
    exit ;
}

exec "gnome-terminal --working-directory='$working_directory'" ;

system $ZENITY .' --error --title="'. $LOC{$lang}{'title'} .'" --text="'. $LOC{$lang}{'error'} .'"' ;


### EOF
