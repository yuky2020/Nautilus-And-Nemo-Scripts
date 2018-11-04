#!/bin/bash

# ===================================================================================================================================================================== # 
# This script remove the SCM folders and his subfolders starting from the selected folder. The supported SCM are: CVS, Mercurial, Subversion, Git
#
# USAGE: select the root folder to disconnect from a supported SCM, right click on the chosen folder, chose this script from the available ones in Nautilus, then  # chose the versioning system. NOTE: the operation is irreversible !
# NOTE: When the operation is completed can be necessary execute a refresh of the folder if the scm folder is just displayed
#
# e-mail: fulvio999@gmail.com
#
# NOTE: this script is distrubuted without any WARRANTY!
# YOUR VOTE WOULD BE APPRECIATED. THANKS ===================================================================================================================================================================== #

# Check if the zenity package is installed
noZenityFound="Please, install the zenity package before run the script!"

which zenity
if [ ! $? = 0 ]; then
 echo "$noZenityFound" > /tmp/disconnectFromSCM-error
 xdg-open /tmp/disconnectFromSCM-error
 exit
fi


# The versioning system name chosen, is used to decide the folder name to remove
choise=$(zenity --list --title="Choose The Versioning System" --text="Select your Versioning System" --column "Supported Versioning System:" \ "cvs" \ "svn" \ "mercurial" \ "git");


# Check if the user has pressed undo button of the scm list
if [ $? = 1 ] ; 
then  
  exit 0
fi

# The full path of the selected folder (eg: /home/fulvio/myfolder) That path will be used as start folder for the find command
# Note: NAUTILUS_SCRIPT_SELECTED_FILE_PATHS is an input variable initialized by Nautilus
fullFolderPath=${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}


# The use of " is necesary to preserves whitespace in a single variable because a folder name can have white spaces
f=`echo "$fullFolderPath"`

# DEBUG: 
#zenity --info --text $f


# Check if the user has chosen a file with the right click: only folder are allowed
if [ -f "$1" ]; then
    zenity --error --text="<b>$1</b> is a File. This script doesn't work with files!"
    exit 0
fi

# Necessary for subversion, mercurial and git because they use hidden folders
prefix=.

# dirName is the folder name used by the versioning system to store his data

if [ $choise = svn ]; 
then
	dirName=${prefix}svn

elif [ $choise = cvs ]
then
       dirName=CVS

elif [ $choise = git ]
then
       dirName=${prefix}git

elif [ $choise = mercurial ]
then
       dirName=${prefix}hg
fi


# Check if the root folder name is equals at the scm folder name to be removed
if [[ $1 = "CVS" || $1 = ".svn" ]]; then
 	zenity --error --text="Root folder name can't be equals at folder name to be removed: rename it"
	exit 0
fi

if [[ $1 = ".hg" || $1 = ".git" ]]; then
 	zenity --error --text="Root folder name can't be equals at folder name to be removed: rename it"
	exit 0
fi


zenity --question --text "Note: The Operation is <b>irreversible</b> Continue? "


# true if the user has pressed undo button of the question dialog
if [ $? = 1 ] ; 
then  
  exit 0
fi


# DEBUG: zenity --info --text "scm folder name to remove: $dirName"

(
   find "$f" -name $dirName -print0 | xargs -0 rm -rf

)| zenity --progress \
          --title="Removing Files..." \
          --text="Please Wait..." \
          --percentage=0

        if [ "$?" = 1 ] ; then
                zenity --error \
                  --text="Update canceled."
        fi


zenity --info --text "Operation Completed ! \n (Can be necessary refresh the folder)"

