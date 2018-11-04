#!/bin/bash

# for debugging:
# set -x

#encrypt_decrypt_to_e_d.sh
# Script by M B Stevens, Dec. 2011, Version 1.

# encrypts files and directories to your home folder "e"
# decrypts files and directories from your home folder "d"
# creates the directories if needed.
# Your encrypted and decrypted files will migrate to these two
#    directories so you will always know where these files are.

# QUICK INSTALL:
# This is a gnome-nautilus-unity specific script -- 
#   it's location is IMPORTANT:
# 1) Copy script to your home's "~/.gnome2/nemo-scripts" directory.
# 2) Make script executable there:
#       preferences/permission-tab/ check executable box
#       or, in a terminal, chmod +x SCRIPTNAME.

# HOW TO USE:  
# 1) Highlight files or directories you want to encrypt or decrypt.
# 2) Right click and choose "Scripts".
# 3) Chose this SCRIPTNAME from the drop-down list. 
#       (If this script is missing, you may have to display
#       the scripts directory in a nautilus window at least once first.)
# 4) Choose whether to encrypt or decrypt.

# REQUIREMENTS:
# The script assumes you have a normal Gnome Linux -- gpg, tar,
#   sed, zenity dialogs, and Bash 3.2 or later and a gnome or gnome
#   derived desktop.
# Gpg public keys are not used; encryption is simply symmetrical --
#   just a password is used.
#   Be sure to save or remember the password, because there
#   is _no_ other way back into your information.

# BAH -- HUMBUG!  
# Too many password prompts? 
# Gpg's use-agent is probably getting prompts that it doesn't need.
# Do this:
#    Open ~/.gnupg/gpg.conf in an editor;
#    Comment out the "use-agent" line (prefix it with "#");
#    Kill off the gpg-agent service ("sudo killall -9 gpg-agent").
#    Enjoy your more prompt-free environment.

# HISTORY:
# The script is based on my older U1_encrypt_decrypt script,
#   but is generalized so as no longer to assume you have the Unbuntu
#   cloud installed.  It is also massively cleaned up, and it should
#   be much easier to understand and modify.

#----------------------------------------------------

	
# GLOBAL VARS:

IFS=$'\t\n'
	# For filename spaces.  This is the
	# internal field separator, usually space-tab-newline;  ' \t\n'.
	# Dangerous: Assure nothing depends on normal separator.
usr="$(whoami)"
e_dir="/home/$usr/e" 
d_dir="/home/$usr/d"

# FUNCTIONS:

get_input_from_user()
{
	# User decides to encrypt or to decrypt.
	d_or_e=$( zenity --list --radiolist --title="Encrypt_or_Decrypt" \
					--column='----' --column='-----------------'  \
					'FALSE' 		"decrypt" \
					'FALSE' 		"encrypt" )
			#zenity --info --text="e_or_d var set to:  ${e_or_d}"
	
	# User gives password            
	pass=$(zenity --entry --hide-text \
			--text="Enter password" --title="Password:")            
			#zenity --info --text="password var set to:  ${pass}"
}

assure_folders_are_there()
{
	if [ ! -d $e_dir ]; then
	    mkdir $e_dir
	fi
	if [ ! -d $d_dir ]; then
	    mkdir  $d_dir
	fi
}

do_encryption()
{
	#zenity --info --text="in e"
	for this_path in $(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"); do
		input_file=$(basename "${this_path}")
		if [ -d "$this_path" ]; then  
		# directory
			output_path="${e_dir}/${input_file}.stgz"
			tar czf - ${input_file} |\
				gpg --passphrase ${pass}  -c -o ${output_path}
		else  
		# not directory
			output_path="${e_dir}/${input_file}.gpg"
			gpg --passphrase=${pass} -o ${output_path} -c ${input_file}
		fi
	done
}

do_decryption()
{
	#zenity --info --text="in d"
	for this_path in $(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"); do
		input_file=$(basename "${this_path}")
		if [[ $input_file =~ \.stgz ]]; then  
		# file, encrypted dir
			gpg --passphrase ${pass} --decrypt ${input_file} |\
				tar xzf -  --directory=${d_dir} 
		else  
		# file, encrypted file
			output_file=${input_file%%.gpg}
			output_path="${d_dir}/${output_file}"
			gpg --passphrase=${pass} -o ${output_path} ${input_file}
		fi
	done
}

base_function()
{
	get_input_from_user
	assure_folders_are_there
	if [ ${d_or_e} = 'encrypt' ]; then 
		do_encryption
	elif [ ${d_or_e} = 'decrypt' ]; then
		do_decryption
	else 
		echo "Direction not set correctly."
		exit 1
	fi
}
#------------ end functions

# GET IT DONE
base_function
zenity --info --text="done."
exit 0

#-----------------------------------------------------------------------
# END

