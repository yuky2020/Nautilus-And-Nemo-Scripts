#!/usr/bin/perl -w
#Title=where-is-this-icon
#Title[fr]=ou-est-cette-icone

#==============================================================================
#                            where-is-this-icon
#
#  author  : SLK
#  version : v2011042301
#  license : Distributed under the terms of GNU GPL version 2 or later
#
#==============================================================================
#
#  description :
#    nautilus-script : 
#    displays the full path of the icon choosen for a folder, a file or a
#    launcher (.desktop).
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

use utf8 ;
use strict ;

#==============================================================================
#                                                                     CONSTANTS

# choose (or add !) your language :
my $LANG = 'en' ;
#my $LANG = 'fr' ;

my %LOC = () ;

$LOC{'en'}{'title'} = 'where is this icon ?' ;
$LOC{'en'}{'default_icon'} = 'no specific icon found for this file' ;
$LOC{'en'}{'desktop_icon'} = 'full path of this icon (this file is a launcher):' ;
$LOC{'en'}{'path_icon'} = 'full path of this icon:' ;

$LOC{'fr'}{'title'} = 'ou est cette icone ?' ;
$LOC{'fr'}{'default_icon'} = 'aucune icone specifique trouvee pour ce fichier' ;
$LOC{'fr'}{'desktop_icon'} = 'chemin complet de cette icone (ce fichier est un lanceur):' ;
$LOC{'fr'}{'path_icon'} = 'chemin complet de cette icone :' ;


#==============================================================================
#                                                                INIT VARIABLES

my $HOME_PATH = $ENV{'HOME'} ;
my $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS = $ENV{'NAUTILUS_SCRIPT_SELECTED_FILE_PATHS'} ;

my $GVFS_INFO = '/usr/bin/gvfs-info' ;
my $ZENITY = '/usr/bin/zenity' ;

my $obj = '' ;
my $info = '' ;
my @encoded_tree = () ;
my $encoded_filename_obj = '' ;
my $encoded_dirpath_obj = '' ;
my $double_encoded_dirpath_obj = '' ;
my $filepath_xml =  '' ;
my $filepath_icon = 'NONE' ;
my $encoded_filepath_icon = 'NONE' ;
my $text = '' ;

#==============================================================================
#                                                                     FUNCTIONS

sub to_url
{
    my @out = @_ ;
    s/([^A-Za-z0-9._-])/sprintf("%%%02X", ord($1))/seg for(@out) ;
    return @out ;
}
sub from_url
{
    my @out = @_ ;
    s/\%([A-Fa-f0-9._-]{2})/pack('C', hex($1))/seg for(@out) ;
    return @out ;
}

#==============================================================================
#                                                                          MAIN

# retrieve first clicked object
($obj) = split("\n", $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS) ;

if((-f $obj) && ($obj =~ /\.desktop$/))
{
    # if file is a launcher (*.desktop)
    # retrieve in the file the value of the iconpath
    
    open(my $DESKTOP, '<', $obj) || die ;
    my @CONTENT = <$DESKTOP> ; close $DESKTOP ;
    ($filepath_icon) = grep(s/^Icon=(.+)$/$1/, @CONTENT) ;
    $text = $LOC{$LANG}{'desktop_icon'} ;
}
elsif(-x $GVFS_INFO)
{
    # more simply if we can obtain infos with gvfs-info
    
    $info = `$GVFS_INFO -a "metadata::custom-icon" "$obj"` ;
    $info =~ s/\n//mgs ;
    $info =~ s/.+file:\/\/(\S+)$/$1/mgs ;
    ($filepath_icon) = from_url($info) ;
}
else
{
    # we try to retrieve the metafile (if exist) which contains iconpath
    
    # extract files of the full path and encode to url
    @encoded_tree = to_url(split('/', $obj)) ;
    $encoded_filename_obj = pop(@encoded_tree) ;
    ($encoded_dirpath_obj) = join('/',@encoded_tree) ;
    
    ($double_encoded_dirpath_obj) = to_url($encoded_dirpath_obj) ;
    $filepath_xml = $HOME_PATH .'/.nautilus/metafiles/file:%2F%2F'. $double_encoded_dirpath_obj .'.xml' ;
    if(-f $filepath_xml)
    {
        # try to get the full path name of the icon
        open(my $XML, '<', $filepath_xml) || die ;
        while(<$XML>)
        {
            if(($encoded_filepath_icon) = (/file name="$encoded_filename_obj"[^>]+?custom_icon="(.+?)"/))
            {
                # from uri : get local path
                $encoded_filepath_icon =~ s|^file://|| ;
                
                # if relative path, let's create absolute path
                ($encoded_filepath_icon =~ m|^[^/]|) 
                  && ($encoded_filepath_icon = join('/',($encoded_dirpath_obj, $encoded_filename_obj, $encoded_filepath_icon))) ;
                
                ($filepath_icon) = from_url($encoded_filepath_icon) ;
                $text = $LOC{$LANG}{'path_icon'} ;
                last ;
            }
        }
        close $XML ;
    }
}

if($filepath_icon eq 'NONE')
{
    system $ZENITY .' --info --title="'. $LOC{$LANG}{'title'} .'" --text="'. $LOC{$LANG}{'default_icon'} .'"';
}
else
{
    system $ZENITY .' --entry --title="'. $LOC{$LANG}{'title'} .'" --text="'. $text .'" --entry-text="'. $filepath_icon .'" --width="400"' ;
}

exit 0 ;


### EOF
