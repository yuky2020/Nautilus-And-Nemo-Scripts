#!/bin/bash
#
#  Nautilus file encryption/decryption script v3.2 - Uses GnuPG
#  Written by Robert Pectol and improved by Renan Manola, http://rob.pectol.com/myscripts
#
######
#
#  Changelog:
#  December 15, 2005 - v2.0 features update
#  January 17, 2006 - v2.5 minor bugfixes and features update
#  September 30, 2007 - v2.6 compatibility updates for Feisty
#  January 11, 2008 - v2.7 compatibility updates for Gutsy
#  January 16, 2008 - v3.0 bugfix and features updates
#  May 29, 2009 - v3.2 compability updates for non-english
#			locales and some bugfixes.
#			By Renan Manola (rmanola@inf.ufes.br).
#
######
#
#	*NOTE* - This is alpha-grade software!!!  Although reasonable
#             measures have been taken to verify proper functionality
#	      of this script, there is NO guarantee that it doesn't
#	      contain any bugs!  Test it out first on a test file or
#	      directory to make sure it works the way you want it to!
#
######
#
#  This  encrypter/decrypter  script  must be  called from  Nautilus.
#  Place this script in your  nemo-scripts directory and make sure
#  it's executable  (chmod 775 this_script.sh)  and it will show up in
#  the,  "Scripts" menu when files are right-clicked  from within your
#  Nautilus file  manager.  Please report any bugs to rob@pectol.com.
#
#  This script requires GnuPG for the file encryption/decryption.  It
#  is usually installed by  default on most  distributions.  However,
#  you may need to generate a key pair for your user account.  This is
#  easily accomplished by opening a shell and typing the following at
#  the command prompt:  "gpg --gen-key"  (Do *NOT* use sudo for this)
#  Once you have generated your keypair, you can start encrypting and
#  decrypting files with your key, using this script!  It's important
#  to NOT forget your passphrase or your encrypted files will be that
#  way forever!!!  This script  also requires  the wipe  command line
#  utility to handle  secure file  deletion.  If you  don't have  the
#  wipe  utility, you  can easily install  it by opening a  shell and
#  typing,  "sudo apt-get install wipe"  at the  command  prompt.
#
#  This  program is free  software.  It  is distributed  in the hope
#  that it will be useful, but WITHOUT ANY WARRANTY; without even the
#  implied warranty of  MERCHANTABILITY or FITNESS  FOR A PARTICULAR
#  PURPOSE.  See the  GNU General Public  License for  more details.
#
######################################################################

##################
#  USER OPTIONS  #
##################

#  Secure File Deletion
#  This option allows you to have the script securely delete
#  the original file from the disk once it's been successfully
#  encrypted.  Selecting, "no" here will leave the un-encrypted
#  version in place and intact so BE WARNED!  This feature uses
#  the wipe command line utility to destroy the original file
#  once it's been successfully encrypted.  Once the original
#  file has been wiped, it is gone!  The only recovery possible,
#  for that file, is to decrypt it's encrypted version.  Don't
#  forget your GnuPG passphrase!!!  Set this option to, "yes"
#  to activate this feature.
rm_cleartext_file="yes"

#  Cypher-text File Deletion
#  This option allows you to have the script delete the
#  encrypted file once it's been successfully decrypted.
#  Set this option to, "yes" to activate this feature.
rm_cyphertext_file="yes"

#  Encrypting files to self.  This option allows you to encrypt
#  files to yourself as the anonymous or hidden recipient.  That
#  way you can encrypt files to someone else's public key, while
#  still allowing you the ability to decrypt them with your key.
#  Be careful as setting this to, "no" and enabling secure file
#  deletion will render your file inaccessible to you if you
#  choose to encrypt it with someone else's public key.  It's
#  probably a good idea to leave this set to, "yes" for most
#  instances.
encrypt_to_self="yes"

#  This option enables verbose feedback during script
#  execution.  With it disabled, only critical errors
#  and the final end results are displayed with minimal
#  verbosity.
verbose="yes"

#####################################################
#  YOU SHOULDN'T MODIFY ANYTHING BELOW THIS POINT!  #
#####################################################

# Set some script variables
the_file=$1
if [ "$NAUTILUS_SCRIPT_CURRENT_URI" == "x-nautilus-desktop:///" ]; then
	files_path=$HOME"/Desktop"
else
	files_path=`echo "$NAUTILUS_SCRIPT_CURRENT_URI" | sed -e 's/^file:\/\///; s/%20/\ /g'`
fi
gui=`which zenity`
enc_dec=`which gpg`
secure_delete=`which wipe`
tar=`which tar`
gzip=`which gzip`

# Secure file deletion disclaimer
agreed=`cat ~/.enc_dec_agreed` &> /dev/null
if [[ "$rm_cleartext_file" == "yes" && "$agreed" != "yes" ]]; then
	dialog_title="Disclaimer!"
	dialog_type="--question"
	ackn1="By activating the secure file deletion feature, you acknowledge"
	ackn2="that you understand the following:  Once the file is successfully"
	ackn3="encrypted to a new file, the original un-encrypted file will be"
	ackn4="securely deleted!  That is, it will be destroyed!  After that,"
	ackn5="the only hope of recovering the original file will be in the"
	ackn6="successful decryption of the encrypted one!  Don't forget your"
	ackn7="passphrase or your encrypted file(s) will be that way forever!"
	ackn8="Select, 'Ok' to acknowledge.  (NOTE: This notice will only be"
	ackn9="shown once unless you decline to acknowledge!)"
	feedback=`echo $ackn1 $ackn2 $ackn3 $ackn4 $ackn5 $ackn6 $ackn7 $ackn8 $ackn9`
	zenity --title "$dialog_title" "$dialog_type" --text "$feedback"
	if [ "$?" == "0" ]; then
		echo "yes" > ~/.enc_dec_agreed
		$gui --title "Enabled!" "--info" --text "Secure file deletion is now enabled!"
	else
		$gui --title "Disabled!" "--info" --text "Then you should disable secure file deletion before using this script!"
		exit 0
	fi
fi

# Decrypt function
decrypt()
{
	# Collect GnuPG passphrase
	getpasswd=`$gui  --title "GnuPG Decrypter" --entry --hide-text \
	--text="Please enter your GnuPG passphrase to decrypt $the_file:" \
	| sed 's/^[ \t]*//;s/[ \t]*$//'` &> /dev/null
	if [ "$getpasswd" == "" ]; then
		dialog_title="Operation Aborted!"
		dialog_type="--error"
		feedback="No passphrase submitted.  Operation cancelled!"
		feedback
		exit 0
	fi
	# Do the decrypting
	echo $getpasswd | $enc_dec -v --batch --passphrase-fd 0 --output /tmp/decrypted_output_file.dec \
	--decrypt "$files_path/$the_file" &> /tmp/encdecresult
	#result=`cat /tmp/encdecresult | egrep 'failed:' | head -n1`
	#if [ "$result" == "" ]; then
	gpg_out=$? #for allowing verification latter
	if [ $gpg_out -eq 0 ]; then # If the decription was sucessful
		orig_filename=`cat /tmp/encdecresult | grep "=" | cut -d '=' -f2 | sed 's/'\''//g'`
		if echo $orig_filename | egrep '\.dtgz$'; then
			unarchive="yes"
			orig_filename=`echo $orig_filename | sed 's/dtgz/tgz/'`
			the_dir=`echo $orig_filename | cut -d '.' -f1`
		else
			unarchive="no"
			the_dir="`date +%s`-null"
		fi
		#Here, the line below has always same result of: "cat /tmp/encdecresult"
		result=`cat /tmp/encdecresult | sed 's/<//g;s/>//g' | uniq`
		# Check for existence of decrypted file or directory with same name
		if [ -a "$files_path/$orig_filename" ]; then
			dialog_title="Confirm Replace!"
			dialog_type="--question"
			feedback="File, \"$orig_filename\" already exists!  Overwrite it?"
			feedback
			if [ "$yesorno" == "1" ]; then
				dialog_title="Operation Aborted!"
				dialog_type="--info"
				feedback="Cancelled at your request!"
				feedback
				$secure_delete -q -f /tmp/decrypted_output_file.dec
				exit 0
			else
				$secure_delete -q -f "$files_path/$orig_filename" > /dev/null 2>&1
				if [ -a "$files_path/$orig_filename" ]; then
					dialog_title="Operation Aborted!"
					dialog_type="--error"
					feedback="File could NOT be overwritten!"
					feedback
					exit 0
				fi
			fi
		elif [ -d "$files_path/$the_dir" ]; then
			dialog_title="Confirm Replace!"
			dialog_type="--question"
			feedback="Directory, \"$the_dir\" already exists!  Overwrite it?"
			feedback
			if [ "$yesorno" == "1" ]; then
				dialog_title="Operation Aborted!"
				dialog_type="--info"
				feedback="Cancelled at your request!"
				feedback
				$secure_delete -q -f /tmp/decrypted_output_file.dec
				exit 0
			else
				$secure_delete -q -r -f "$files_path/$the_dir" > /dev/null 2>&1
				if [ -d "$files_path/$the_dir" ]; then
					dialog_title="Operation Aborted!"
					dialog_type="--error"
					feedback="Directory could NOT be overwritten!"
					feedback
					exit 0
				fi
			fi
		fi
		cp /tmp/decrypted_output_file.dec "$files_path/$orig_filename"
		if [ "$unarchive" == "yes" ]; then
			tar -zxvf "$files_path/$orig_filename" -C "$files_path"
			orig_dir=`echo $orig_filename | cut -d '.' -f1`
			if [ -d "$files_path/$orig_dir" ]; then
				$secure_delete -q -f "$files_path/$orig_filename"
			fi
			orig_filename=$orig_dir
		fi
		# Remove encrypted file after decryption (if configured to do so)
		if [ "$rm_cyphertext_file" == "yes" ]; then
			# Check for existence of the newly decrypted file or directory before we remove the encrypted one
			if [ -a "$files_path/$orig_filename" ]; then
				rm -f "$files_path/$the_file"
				# make sure the encrypted file or directory was successfully removed
				if [ -a "$files_path/$the_file" ]; then
					result=`echo "$result - *NOTE* \"$the_file\", (the original file) could NOT be deleted!"`
				fi
			fi
		fi

		dialog_title="Decryption Results"
		dialog_type="--info"
		if [ "$verbose" == "yes" ]; then
			feedback="Success! - \"$the_file\" was decrypted to, \"$orig_filename\" - $result"
		else
			feedback="Success! - Success! - $result"
		fi
		feedback
	else
		dialog_title="Decryption Error!"
		dialog_type="--error"
		feedback="The error message was: \n"`cat /tmp/encdecresult`
		feedback
	fi
	rm -f /tmp/encdecresult
	$secure_delete -q -f /tmp/decrypted_output_file.dec
}

# Encrypt function
encrypt()
{
	# Present the available keys; get selected key
	keylist=`gpg --list-keys`
	key_names=`echo "$keylist" | egrep '^uid' | awk '{$1=$1;print}' | cut -d '(' -f1 | cut -d '<' -f1 \
	| sed -e 's/uid //g;s/^[ \t]*//;s/[ \t]*$//;s/ /_/g'`
	default_recipient=`echo "$key_names" | head -n 1 | sed -e 's/_/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
	keys=""
	for e in $key_names; do
		keys="${keys} NULL ${e}"
	done
	the_recipient=`zenity --title "Encryption Keys" --text "Select the key to be used for encryption." \
	--list --radiolist --column "" --column "Available keys on your keyring:" ${keys}`
	cancel_select=$?
	the_recipient=`echo "$the_recipient" | sed -e 's/_/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
	if [ "$the_recipient" == "" ]; then
		the_recipient=$default_recipient
	fi
	if [ "$cancel_select" == "1" ]; then
		dialog_title="Operation Aborted!"
		dialog_type="--info"
		feedback="Cancelled at your request!"
		feedback
		exit 0
	fi
        # Check for existence of encrypted file with same name
        if [[ -a "$files_path/${the_file}.gpg" || -a "$files_path/${the_file}.dtgz.gpg" ]]; then
                dialog_title="Confirm File Replace!"
                dialog_type="--question"
                feedback="\"$the_file\" already exists!  Overwrite it?"
                feedback
                if [ "$yesorno" == "1" ]; then
                        dialog_title="Operation Aborted!"
                        dialog_type="--info"
                        feedback="Cancelled at your request!"
                        feedback
                        exit 0
                else
                        rm -f "$files_path/${the_file}.gpg" > /dev/null 2>&1
                        rm -f "$files_path/${the_file}.dtgz.gpg" > /dev/null 2>&1
                        if [[ -a "$files_path/${the_file}.gpg" || -a "$files_path/${the_file}.dtgz.gpg" ]]; then
                                dialog_title="Operation Aborted!"
                                dialog_type="--error"
                                feedback="The encrypted file could NOT be overwritten!"
                                feedback
                                exit 0
                        fi
                fi
        fi
	# Archive and gzip if it's a whole directory
	if [ -d "$files_path/$the_file" ]; then
		file_is_dir="yes"
		the_dir=$the_file
		the_dir_cz=${the_file}.dtgz
		tar -zcvf "/tmp/$the_file.dtgz" "$the_dir"
	else
		file_is_dir="no"
	fi
	# Do the encrypting
	if [ "$encrypt_to_self" == "yes" ]; then
		if [ "$file_is_dir" == "yes" ]; then
			$enc_dec -v --batch --default-recipient "$the_recipient" --hidden-encrypt-to "$default_recipient" \
			-e "/tmp/$the_dir_cz" &> /tmp/encdecresult
			gpg_out=$? #for allowing verification latter
			mv -f "/tmp/$the_dir_cz.gpg" "$files_path/$the_dir_cz.gpg"
			rm -f /tmp/$the_dir_cz
		else
			$enc_dec -v --batch --default-recipient "$the_recipient" --hidden-encrypt-to "$default_recipient" \
			-e "$files_path/$the_file" &> /tmp/encdecresult
			gpg_out=$? #for allowing verification latter
		fi
	else
		if [ "$file_is_dir" == "yes" ]; then
			$enc_dec -v --batch --default-recipient "$the_recipient" -e "/tmp/$the_dir_cz" &> /tmp/encdecresult
			gpg_out=$? #for allowing verification latter
			mv -f /tmp/${the_dir_cz}.gpg ${files_path}/${the_dir_cz}.gpg
			rm -f /tmp/$the_dir_cz
		else
			$enc_dec -v --batch --default-recipient "$the_recipient" -e "$files_path/$the_file" &> /tmp/encdecresult
			gpg_out=$? #for allowing verification latter
		fi
	fi
	result=`cat /tmp/encdecresult`
	result=`echo $result | tail -n 1 | cut -d '"' -f2 | sed 's/<//g;s/>//g'`
	# Secure deletion of cleartext file (if configured to do so)
	if [ $gpg_out -eq 0 ]; then
	
		if [ "$rm_cleartext_file" == "yes" ]; then
			sec_file_del
		elif [ "$verbose" == "yes" ]; then
			warn1="*WARNING* Although $the_file was encrypted to $the_file.gpg,"
			warn2="the original file was NOT deleted.  It is still on your drive!"
			warn3="This may be a security issue!  Consider enabling secure file"
			warn4="deletion.  To stop seeing this warning, you can set the verbose"
			warn5="option to, 'no' near the top of the script."
			result=`echo "$result - $warn1 $warn2 $warn3 $warn4 $warn5"`
		fi

		dialog_title="Encryption Results"
		dialog_type="--info"
		if [ "$verbose" == "yes" ]; then
			if [ "$file_is_dir" == "yes" ]; then
				feedback="Success! - \"$the_file\", was encrypted to, \"${the_dir_cz}.gpg\" using key $result"
			else
				feedback="Success! - \"$the_file\", was encrypted to, \"$the_file.gpg\" using key $result"
			fi
		else
			if [ "$file_is_dir" == "yes" ]; then
				feedback="Success! - Encrypted to, \"${the_dir_cz}.gpg\"."
			else
				feedback="Success! - Encrypted to, \"$the_file.gpg\"."
			fi
		fi
		feedback
	else
		dialog_title="Encryption Error!"
		dialog_type="--error"
		feedback=$result
		feedback
	fi
}

# Secure file deletion function
sec_file_del()
{
	# Check for existence of the newly encrypted file before we remove the original
	if [[ -a "$files_path/${the_file}.gpg" || -a "$files_path/${the_dir_cz}.gpg" ]]; then
		# If file is a directory, remove the un-encrypted directory and it's contents
		if [ "$file_is_dir" == "yes" ]; then
			$secure_delete -q -r -f "$files_path/$the_dir"
		else
			$secure_delete -q -f "$files_path/$the_file"
		fi
		#  Check to make sure the original file or directory was securely deleted
		if [ "$file_is_dir" == "yes" ]; then
			if [ -d "$files_path/$the_dir" ]; then
				result=`echo "$result - *NOTE* \"$the_dir\", (the original directory) could NOT be securely deleted!"`
			else
				result=`echo "$result - *NOTE* \"$the_dir\", (the original directory) was securely deleted!"`
			fi
		else
			if [ -a "$files_path/$the_file" ]; then
				result=`echo "$result - *NOTE* \"$the_file\", (the original file) could NOT be securely deleted!"`
			else
				result=`echo "$result - *NOTE* \"$the_file\", (the original file) was securely deleted!"`
			fi
		fi
	else
		warn1="*WARNING* $the_file could NOT be encrypted!"
		warn2="Check the permissions on that file and try again."
		result=`echo "$result - $warn1 $warn2"`
	fi
}

# Feedback function
feedback()
{
	$gui  --title "$dialog_title" $dialog_type --text="$feedback"
	yesorno=$?
}

# Errors function
errors()
{
	if [ -x "$gui" ]; then
		result=""
	else
		result="Zenity NOT found.  This utility is required! "
	fi
	if [ -x "$enc_dec" ]; then
		result=`echo "$result"`
	else
		result=`echo "$result GnuPG NOT found.  This utility is required! "`
	fi
	if [ -x "$secure_delete" ]; then
		result=`echo "$result"`
	else
		result=`echo "$result 'wipe' command line utility NOT found.  This utility is required! "`
	fi
	if [ -x "$tar" ]; then
		result=`echo "$result"`
	else
		result=`echo "$result tar NOT found.  This utility is required! "`
	fi
	if [ -x "$gzip" ]; then
		result=`echo "$result"`
	else
		result=`echo "$result gzip NOT found.  This utility is required! "`
	fi
	echo $result
	dialog_title="Missing Required Tools!"
	dialog_type="--error"
	feedback=$result
	feedback
	exit 1
}

# Check for required tools and decide whether to encrypt or decrypt
if [[ -x "$gui" && -x "$enc_dec" && -x "$secure_delete" && -x "$tar" && -x "$gzip" ]]; then
	if echo $the_file | egrep '\.gpg$|\.pgp$'; then
		decrypt
	else
		encrypt
	fi
else
	errors
fi
exit 0


