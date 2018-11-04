#!/bin/bash

# Ubuntu One Encryption for Files and Directories.
# Script by Michael B Stevens, Oct. 2011, Version 1.
# Replace named numbers with digits,stevensfourthousand AT earthlink.net
# Please send suggested improvements.
# Suggested SCRIPTNAME:  "U1_encrypt_decrypt_v1.sh" 
# Loosely based on a script by Adam Buchanan.
# 

# QUICK START:
# This is a gnome-nautilus-unity specific script -- 
#   it's location is important:
# 1) Copy script to your home's "~/.gnome2/nemo-scripts" directory.
# 2) Make script executable there:
#	    preferences/permission-tab/ check executable box
#       or, in a terminal, chmod +x SCRIPTNAME.

# HOW TO USE:  
# 1) Highlight files or directories you want to encrypt or decrypt.
# 2) Right click and choose "Scripts".
# 3) Chose this SCRIPTNAME from the drop-down list. 
#       (If this script is missing, you may have to display
#       the scripts directory in a nautilus window at least once first.)
# 4) Choose whether to encrypt or decrypt.

# BAH -- HUMBUG!  
# Too many password prompts? 
# Gpg's use-agent is probably getting prompts that it doesn't need.
# Do this:
#    Open ~/.gnupg/gpg.conf in an editor;
#    Comment out the "use-agent" line (prefix it with "#");
#    Kill off the gpg-agent service ("sudo killall -9 gpg-agent").
#    Enjoy your more prompt-free environment.


# WHAT HAPPENS when you run this script? 
# Encrypted stuff from anywhere on your computer
#   is copied into the Ubuntu one direcory.
# Decrypted files from anywhere on your computer
#   will be written into the ~/U1decrypt directory,
#   which is created if necessary.
#   The Ubuntu One directory will not be disturbed when you decrypt
#   files and directories from it.
#   All your local cloud info will migrate to these two directories,
#   and the cloud never sees your decrypted information.

# The program assumes you have normal Linux facilities -- gpg, tar,
#   sed, zenity dialogs, and Bash 3.2 or later and an Ubuntu One
#   cloud subscription.  
 
# Gpg public keys are not used; encryption is simply symmetrical --
#   just a password is used.
#   Be sure to save or remember the password, because there
#   is _no_ other way back into your information.
#-----------------------------------------------------------------------



# SCRIPT:
#-----------------------------------------------------------------------
IFS=$'\t\n'
# Internal field separator, usually space-tab-newline;  ' \t\n'.
# "Ubuntu One," has a space, for instance, that could cause problems.

# Find  current user and Ubuntu One directory.
this_user=$(whoami)
ubuntu1="/home/$this_user/Ubuntu One" 
U1decrypt="/home/$this_user/U1decrypt"

# Assure required folders are there.
if [ ! -d $ubuntu1 ]; then
    zenity --warning --text="Ubuntu One directory missing.\nExiting."
    exit 0	
fi
if [ ! -d $U1decrypt ]; then
    mkdir  $U1decrypt
fi

# Set direction:  To encrypt or to decrypt.
direction=$(zenity \
            --list \
            --radiolist \
            --title="Encrypt or Decrypt:" \
            --column " - "  \
            --column "direction" \
            'FALSE' "encrypt" \
            'FALSE' "decrypt")
            
pass=$(zenity --entry --hide-text \
    --text="Enter password" --title="Password:")            

# encrypt / decrypt
if [ $direction = "encrypt" ]; then
	for this_path in $(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"); do
        input_file=$(echo $this_path | sed 's/.*\///g')
		if [ -d "$this_path" ]; then  # path is directory
            output_path="${ubuntu1}/${input_file}.stgz"
            tar czf - ${input_file} |\
                gpg --passphrase ${pass}  -c -o ${output_path}
		else  # not directory
            output_path="${ubuntu1}/${input_file}.gpg"
            gpg --passphrase=${pass} -o ${output_path} -c ${input_file}
		fi
	done
else # decrypt
	for this_path in $(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"); do
        input_file=$(echo $this_path | sed 's/.*\///g')
		if [[ $input_file =~ \.stgz ]]; then  # encrypted dir
            gpg --passphrase ${pass} --decrypt ${input_file} |\
                tar xzf -  --directory=${U1decrypt} 
		else  # file
            output_file=${input_file%%.gpg}
            output_path="${U1decrypt}/${output_file}"
            gpg --passphrase=${pass} -o ${output_path} ${input_file}
		fi
	done
fi


zenity --info --text="done."
exit 0
#-----------------------------------------------------------------------
# END



#  NEED TO MODIFY SCRIPT?
#  I release this under Gnu Public License, so you may modify it
#  as needed.  The material below may help:


#  The magic terseness of pipes may not be for everyone.
#  Watch out for every character in the piped 
#  gpg/tar commands, they're touchy and are
#  tricky to get just right. You could instead go with
#  something like the following that uses a temporary file
#  if you intend to modify this script
#  for some other purpose:

# Alternate directory encrypt
            #tar czf "${input_file}.tar" $input_file
            #gpg  -c -o $output_path "${input_file}.tar"

# Alternate directory-tar-file decrypt
            #midf="${U1decrypt}/${input_file}.temp"
            #gpg -o ${midf} ${input_file} 
            #tar xzf  ${midf} -C ${U1decrypt}
            #rm $midf

 
# I like things quick and simple -- but
# some people prefer a password confirmation dialog.
# One could modify this script's password prompt
# with something like:
#
# Confirm entry and require confirmed password.
#	while [[ -z $match ]] 
#	do  # Loop for password.
#		pass=$(zenity --entry --hide-text \
#						--text="Enter password" --title="Password:")
#		pass_conf=$(zenity --entry --hide-text \
#						--text="Confirm password" --title="Confirm:")
#		if [[ -z $pass ]]  # No password.
#		then
#			zenity --warning \
#				--text="Sorry, password required.\n\nExiting."
#			exit 0
#		elif [[ "$pass" = "$pass_conf" ]]
#		then
#			match='true'
#			continue
#		else
#			zenity --warning \
#				--text="Passwords did not match.\nClick OK to retry."		
#		fi
#	done

