#!/bin/bash
# By: Dart00
# Version: 1.5
PASSWORD=""
ENCRYPTIONTYPE=""
COMPRESSION=""
ARMOR=""
USESALT=""
EDITION=""
PASSWORDHASHED=""
EXT=""
ARMORTYPE=""

if [[ "$0" =~ "Turbo-Secure-Files" ]]; then
   PURPOSE="Files"
fi

if [[ "$0" =~ "Turbo-Secure-Text" ]]; then
   PURPOSE="Text"
fi

# Example File: Meow.abc.def.ghi.jkl.mno

FILE="${1##*/}"      # Meow.abc.def.ghi.jkl.mno
EXTENSION=${FILE#*.} # abc.def.ghi.jkl.mno
BASEFILE=${FILE%%.*} # Meow 
ORIGINALNAME="$1"    # /home/shane/Desktop/Meow.abc.def.ghi.jkl.mno

NONENCRYPTEDFILENAME=${FILE%.${EXT}}
HEIGHT="550"
WIDTH="775"

# =============================================================================================================
# Set Language:
case $LANG in
 * )
WORD1="Turbo-Secure-$PURPOSE:"
WORD2="Script Installation Canceled!"
WORD3="No File Selected!"
WORD4="You can not Encrypt/Decrypt Multiple Files at a time. Please place them all in a folder and Encrypt the entire folder."
WORD5="Decryption"
WORD6="Encryption"
WORD7="Decryption..."
WORD8="Encrypting..."
WORD9="Complete!"
WORD10="Failed!"
WORD11="Compressing Folder..."
WORD12="Decompressing Archive..."
WORD13=""
WORD14="Do you want to remove the Original Unencrypted Copy?"
WORD15="Thank you for downloading Turbo-Secure-$PURPOSE!"
WORD16="You are installing and using this software AS-IS without any warranty or guarantee!"
WORD17="How do you want your password to be stored?"
WORD18="Pick:"
WORD19="Option:"
WORD20="Recommendation:"
WORD21="I want to type it every time for security"
WORD22="Recommended for securing files on your computer."
WORD23="Stored on the Hard Drive for ease of use"
WORD24="Recommended for sending encrypted files over the Internet."
WORD25="Failed To Install!"
WORD26="Please Enter Password (Recommended length is 20 characters using letters and numbers):"
WORD27="Password can not be left blank! Script will now Abort!"
WORD28="Select Encryption Strength: (The stronger, the slower but not noticeable until encrypting 500MB+ files)"
WORD29="Encryption Algorithm:"
WORD30="Strength:"
WORD31="Supported:"
WORD32="Yes"
WORD33="No"
WORD34="Select Compression Level:"
WORD35="Compression Ratio:"
WORD36="Very High"
WORD37="High"
WORD38="Medium"
WORD39="Low"
WORD40="Speed:"
WORD41="Slower"
WORD42="Normal"
WORD43="Faster"
WORD44="Fastest"
WORD45="Standard"
WORD46="None"
WORD47="Select Encryption Armor Type:"
WORD48="Type:"
WORD49="Description:"
WORD50="Non-Armored"
WORD51="Encrypted File will be in .gpg Binary Format"
WORD52="Armored"
WORD53="Encrypted File will be in .asc ACSII Armored Format (Text)"
WORD54="Successfully Installed using"
WORD55="Grade Encryption!"
WORD56="Please Enter Password:"
WORD57="Password can not be left blank! Script will now Abort!"
WORD58="Wrong Password or Corrupted Data?"
WORD59="Error Decrypting!"
WORD60="Encrypted File will be in .enc Base64 Armored Format (Text)"
WORD61="Encrypted File will be in .enc Binary Format"
WORD63="It his HIGHLY recommended to make a backup of: \"~/.gnome2/nemo-scripts/Turbo-Secure-$PURPOSE (GPG/SSL Edition)\" which may contain your password if you opted to store it as well as your encryption/decryption settings in case of hard drive or data failure or other disasters so you don't get locked out of your files permanently.\n\nIf disaster happens, you can restore it manually back to the same location and continue using it." 
WORD64="Salt adds random data to your password to make it harder to guess. It is highly recommended! Do you want to use Salt in your password?"
WORD65="Select A File To Encrypt:"
WORD66="Select A Folder To Encrypt:"
WORD67="Select Encryption Object:"
WORD68="Object:"
WORD69="File"
WORD70="Folder"
WORD71="Select Encryption Standard:"
WORD72="Standard:"
WORD73="Description:"
WORD74="GNU Privacy Guard - Encryption designed for protecting personal data (Very effective on Text)."
WORD75="Secure Socket Layer - Used for Encrypting Communications but also works well on Personal Data."
WORD76="Your computer does not currently support that. Please install \"openssl\" for SSL support or \"gnupg\" for GPG support."
WORD77="Hashing your password can more then \"Centuple\" its strength (And help hide it). Downside is, data you encrypt will ONLY be compatible with Turbo-Secure Software.\n\nDo you want your Password to be Hashed?"
WORD78="Unable to Hash Password. Your system does not support Hashing Passwords so the password will not be hashed. Installation will continue."
WORD79="Supported:"
WORD80="Invalid File name. The File Name of the script has been modified and the script can not function. Please restore the original file name or re-download/re-install the script"
	     ;;
esac

# =============================================================================================================
# Declare Functions:

function CANCEL {
zenity --info --title="$WORD1" --text="$WORD2"
exit
                } 

function CHECKFORCANCEL {

if ! [ "$?" = "0" ]; then
   zenity --info --title="$WORD1" --text="$WORD2"
   exit
fi
                } 

function INPUTPASSWORD {

if [ "$PASSWORD" = "" ]; then
   PASSWORD=$(zenity --entry --hide-text --title="$WORD1" --text="$WORD56" )
   CHECKFORCANCEL
   if [ "$PASSWORD" = "" ]; then
      zenity --error --title="$WORD1" --text="$WORD57"
      exit
   fi
   if [ "$PASSWORDHASHED" = "YES" ]; then
      PASSWORD=`echo "$PASSWORD" | sha512sum | awk '{print $1}'`
   fi
fi
                } 

function INTERNETCHECK {

if ! [ "$WIPE_INSTALLED" = "YES" ]; then
   (
   echo "# Checking Internet Connectivity..."
   ping -W 3 -q -c 1 us.archive.ubuntu.com > "/dev/null" 2>&1
   if [ "$?" = "0" ]; then
      touch /tmp/Internet.tmp
   else
      ping -W 3 -q -c 1 us.archive.ubuntu.com > "/dev/null" 2>&1
      if [ "$?" = "0" ]; then
         touch /tmp/Internet.tmp
      fi
   fi
   sleep .25
   ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
   if [ -e /tmp/Internet.tmp ]; then
      INTERNET="YES"
      rm -f /tmp/Internet.tmp
   fi   
fi
                }

function CANCELBREAK {

if ! [ "$?" = "0" ]; then
   break
fi 
                }

function INPUTSUDOPASSWORD {

sudo -K
while true; do
   while [ -z "$PASS" ]; do 
      if ! PASS=$(zenity --entry --title="$WORD1" --hide-text --text="Enter sudo Password:" ) ; then 
         CANCEL
      fi
      done
   echo "$PASS" | sudo -S -p "" /bin/true 2> "/dev/null" 
   if [ "$?" = "1" ]; then 
      PASS=""
   else
      break
   fi
done

                }

# =============================================================================================================
# Check for Invalid File name:
if [ "$PURPOSE" = "" ]; then
   zenity --error --title="$WORD1" --text="$WORD80"
   exit
fi

# =============================================================================================================
# Get Status of Wipe:
WIPE_INSTALLED="NO"
wipe -v > "/dev/null" 2>&1
if [ "$?" = "0" ]; then
   WIPE_INSTALLED="YES"
fi

# =============================================================================================================
# Installer:
if [ "$ENCRYPTIONTYPE" = "" ] || [ "$EDITION" = "" ]; then

# =============================================================================================================
# intro:

   zenity --info --title="$WORD1" --text="$WORD15\n\n$WORD16"
   CHECKFORCANCEL

# =============================================================================================================
# Check for GPG and SSL support:

   GPGSUPPORT="$WORD33"
   SSLSUPPORT="$WORD33"

   GPGSUPPORT=`gpg --version`
   if [ "$?" = "0" ]; then
      GPGSUPPORT="$WORD32"
   fi

   SSLSUPPORT=`openssl list-cipher-commands`
   if [ "$?" = "0" ]; then
      SSLSUPPORT="$WORD32"
   fi

# =============================================================================================================
# Pick Standard:
   EDITION=$(zenity --list --title="$WORD1" --height="200" --width="$WIDTH" --text="$WORD71" --radiolist  --column="$WORD18" --column="$WORD72" --column="$WORD79" --column="$WORD73" TRUE "GPG" "$GPGSUPPORT" "$WORD74" FALSE "SSL" "$SSLSUPPORT" "$WORD75" )

   CHECKFORCANCEL
 
   if [ "$EDITION" = "GPG" ]; then
      EDITION="GPG"
      EXT="gpg"
      EDITIONNAME="Turbo-Secure-$PURPOSE ($EDITION Edition)"
   else
      EDITION="SSL"
      EXT="enc"
      EDITIONNAME="Turbo-Secure-$PURPOSE ($EDITION Edition)"
   fi


   if [ "$EDITION" = "GPG" ] && [ "$GPGSUPPORT" = "$WORD33" ]; then
      zenity --error --title="$WORD1" --text="$WORD76"
      exit
   fi

   if [ "$EDITION" = "SSL" ] && [ "$SSLSUPPORT" = "$WORD33" ]; then
      zenity --error --title="$WORD1" --text="$WORD76"
      exit
   fi

# =============================================================================================================
# Installing Recommended Packages:

   INTERNETCHECK

   if [ "$INTERNET" = "YES" ]; then

   if [ "$PURPOSE" = "Files" ] && [ "$WIPE_INSTALLED" = "NO" ]; then
      if `zenity --question --title="$WORD1" --text="After you encrypt data and delete the original encrypted data, there is a HIGH chance that the specialized Data-Recovery Software could recover the unencrypted files. \"Wipe\" is a program that deletes files multiple times over to make the unrecoverable. Do you want to download and install Wipe for secure file deletion?"` ; then
         INPUTSUDOPASSWORD
         (
         echo "# Downloading Wipe..."
         echo "$PASS" | sudo -S -p "" sudo apt-get install --download-only -y wipe
         echo "# Installing Wipe..."
         echo "$PASS" | sudo -S -p "" sudo apt-get install --no-download -y wipe
         ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
      fi
   fi

   fi

# =============================================================================================================
# Copy over Script:
   rm -f ~/.gnome2/nemo-scripts/"$EDITIONNAME"
   cp Turbo-Secure-$PURPOSE-Installer.sh ~/.gnome2/nemo-scripts/"$EDITIONNAME"
   if ! [ $? = "0" ]; then
      zenity --error --title="$WORD1" --text="$EDITIONNAME $WORD25"
      exit
   fi

   sed -i '9s/.*/EDITION=\"'$EDITION'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
   sed -i '11s/.*/EXT=\"'$EXT'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"

# =============================================================================================================
# Select Password Type:
   TYPE=$(zenity --list --title="$WORD1" --height="$HEIGHT" --width="$WIDTH" --text="$WORD17" --radiolist  --column="$WORD18" --column="$WORD19" --column="$WORD20" TRUE "$WORD21" "$WORD22" FALSE "$WORD23" "$WORD24" )

   CHECKFORCANCEL
	 
      case "$TYPE" in
         "$WORD23" )
	    PASSWORD=$(zenity --entry --hide-text --title="$WORD1" --text="$WORD26")
            if [ "$PASSWORD" = "" ]; then
               zenity --error --title="$WORD1" --text="$WORD27"
               exit
            fi

	           ;;
       esac

# =============================================================================================================
# Select Password Hash:

   if `zenity --question --title="$WORD1" --text="$WORD77"` ; then
      CHECKFORCANCEL
      PASSWORD=`echo "$PASSWORD" | sha512sum | awk '{print $1}'`
      if [ "$?" = "0" ]; then
         sed -i '10s/.*/PASSWORDHASHED=\"YES\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
      else
         sed -i '10s/.*/PASSWORDHASHED=\"\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
         zenity --warning --title="$WORD1" --text="$WORD78"
         CHECKFORCANCEL
      fi
   fi

# =============================================================================================================
# Write password to script:

   if [ "$TYPE" = "$WORD23" ]; then
      sed -i '4s/.*/PASSWORD=\"'$PASSWORD'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
   else
      sed -i '4s/.*/PASSWORD=\"\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
   fi

# =============================================================================================================
# Load Supported Encryption Algorithms:

   if [ "$EDITION" = "GPG" ]; then
      ESUPPORTED=`gpg --version`
   else
      ESUPPORTED=`openssl list-cipher-commands`
   fi
   EAES256="$WORD33"
   E3DES="$WORD33"
   ECAST5="$WORD33"
   EBLOWFISH="$WORD33"
   EAES="$WORD33"
   EAES192="$WORD33"
   ETWOFISH="$WORD33"
   ECAMELLIA128="$WORD33"
   ECAMELLIA192="$WORD33"
   ECAMELLIA256="$WORD33"

   if [ "$EDITION" = "GPG" ]; then

   if echo $ESUPPORTED | grep AES256 > "/dev/null" ; then
      EAES256="$WORD32"
   fi
   if echo $ESUPPORTED | grep 3DES > "/dev/null" ; then
      E3DES="$WORD32"
   fi
   if echo $ESUPPORTED | grep CAST5 > "/dev/null" ; then
      ECAST5="$WORD32"
   fi
   if echo $ESUPPORTED | grep BLOWFISH > "/dev/null" ; then
      EBLOWFISH="$WORD32"
   fi
   if echo $ESUPPORTED | grep AES192 > "/dev/null" ; then
      EAES192="$WORD32"
   fi
   if echo $ESUPPORTED | grep TWOFISH > "/dev/null" ; then
      ETWOFISH="$WORD32"
   fi
   if echo $ESUPPORTED | grep CAMELLIA128 > "/dev/null" ; then
      ECAMELLIA128="$WORD32"
   fi
   if echo $ESUPPORTED | grep CAMELLIA192 > "/dev/null" ; then
      ECAMELLIA192="$WORD32"
   fi
   if echo $ESUPPORTED | grep CAMELLIA256 > "/dev/null" ; then
      ECAMELLIA256="$WORD32"
   fi

   else
   
   if echo $ESUPPORTED | grep aes-128-cbc > "/dev/null" ; then
      EAES128="$WORD32"
   fi
   if echo $ESUPPORTED | grep aes-192-cbc > "/dev/null" ; then
      EAES192="$WORD32"
   fi
   if echo $ESUPPORTED | grep aes-256-cbc > "/dev/null" ; then
      EAES256="$WORD32"
   fi
   if echo $ESUPPORTED | grep bf-cbc > "/dev/null" ; then
      EBF="$WORD32"
   fi
   if echo $ESUPPORTED | grep cast-cbc > "/dev/null" ; then
      ECAST="$WORD32"
   fi
   if echo $ESUPPORTED | grep cast5-cbc > "/dev/null" ; then
      ECAST5="$WORD32"
   fi
   if echo $ESUPPORTED | grep des-cbc > "/dev/null" ; then
      EDES="$WORD32"
   fi
   if echo $ESUPPORTED | grep des3 > "/dev/null" ; then
      E3DES="$WORD32"
   fi
   if echo $ESUPPORTED | grep desx > "/dev/null" ; then
      EDESX="$WORD32"
   fi
   if echo $ESUPPORTED | grep rc2-40-cbc > "/dev/null" ; then
      ERC240="$WORD32"
   fi
   if echo $ESUPPORTED | grep rc2-64-cbc > "/dev/null" ; then
      ERC264="$WORD32"
   fi
   if echo $ESUPPORTED | grep rc4-40 > "/dev/null" ; then
      ERC440="$WORD32"
   fi

   fi

# =============================================================================================================
# Select Encryption Algorithm:
   if [ "$EDITION" = "GPG" ]; then
   ENCRYPTIONTYPE=$(zenity --list --title="$WORD1" --height="$HEIGHT" --width="$WIDTH" --text="$WORD28" --radiolist  --column="$WORD18" --column="$WORD29" --column="$WORD30" --column="$WORD31" TRUE "AES256" "$WORD36" "$EAES256" FALSE "CAMELLIA256" "$WORD36" "$ECAMELLIA256" FALSE "TWOFISH" "$WORD36" "$ETWOFISH" FALSE "3DES" "$WORD37" "$E3DES" FALSE "AES192" "$WORD37" "$EAES192" FALSE "CAMELLIA192" "$WORD37" "$ECAMELLIA192" FALSE "CAMELLIA128" "$WORD38" "$ECAMELLIA128" FALSE "BLOWFISH" "$WORD39" "$EBLOWFISH" FALSE "CAST5" "$WORD39" "$ECAST5" )

   CHECKFORCANCEL

   sed -i '5s/.*/ENCRYPTIONTYPE=\"'$ENCRYPTIONTYPE'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"

   else

   ENCRYPTIONTYPE=$(zenity --list --title="$WORD1" --height="$HEIGHT" --width="$WIDTH" --text="$WORD28" --radiolist  --column="$WORD18" --column="$WORD29" --column="$WORD30" --column="$WORD31" TRUE "AES 256-Bit" "Very High" "$EAES256" FALSE "AES 192-Bit" "High" "$EAES192" FALSE "3DES" "High" "$E3DES" FALSE "DESX" "High" "$EDESX" FALSE "AES 128-Bit" "Medium" "$EAES128" FALSE "DES" "Medium" "$EDES" FALSE "RC4 40-Bit" "Medium" "$ERC440" FALSE "BLOWFISH" "Low" "$EBF" FALSE "CAST" "Low" "$ECAST" FALSE "CAST5" "Low" "$ECAST5" FALSE "RC2 40-Bit" "Low" "$ERC240" FALSE "RC2 64-Bit" "Low" "$ERC264" )

   CHECKFORCANCEL

      case "$ENCRYPTIONTYPE" in
         "AES 128-Bit" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'aes-128-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "AES 192-Bit" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'aes-192-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "AES 256-Bit" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'aes-256-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "BLOWFISH" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'bf-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "CAST" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'cast-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "CAST5" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'cast-5-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "DES" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'des-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "DES3" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'des3'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "DESX" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'desx'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "RC2 40-Bit" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'rc2-40-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "RC2 64-Bit" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'rc2-64-cbc'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "RC4 40-Bit" )
            sed -i '5s/.*/ENCRYPTIONTYPE=\"'rc4-40'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
       esac

   fi

# =============================================================================================================
# Select Compression Level:
   if [ "$EDITION" = "GPG" ] && [ "$PURPOSE" = "Files" ]; then
   COMPRESSION=$(zenity --list --title="$WORD1" --height="$HEIGHT" --width="$WIDTH" --text="$WORD34" --radiolist  --column="$WORD18" --column="$WORD35" --column="$WORD40" FALSE "$WORD37" "$WORD41" TRUE "$WORD45" "$WORD42" FALSE "$WORD39" "$WORD43" FALSE "$WORD46" "$WORD44" )

   CHECKFORCANCEL

      case "$COMPRESSION" in
         "$WORD37" )
            sed -i '6s/.*/COMPRESSION=\"'9'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "$WORD45" )
            sed -i '6s/.*/COMPRESSION=\"'6'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "$WORD39" )
            sed -i '6s/.*/COMPRESSION=\"'3'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
         "$WORD46" )
            sed -i '6s/.*/COMPRESSION=\"'0'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
       esac
   fi

# =============================================================================================================
# Select Salt:

   if [ "$EDITION" = "SSL" ]; then
   if `zenity --question --title="$WORD1" --text="$WORD64"` ; then
      sed -i '8s/.*/USESALT=\"'-salt'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
   fi
   fi

# =============================================================================================================
# Select Armor Type:

   if [ "$PURPOSE" = "Files" ]; then
      if [ "$EDITION" = "GPG" ]; then
      ARMOR=$(zenity --list --title="$WORD1" --height="$HEIGHT" --width="$WIDTH" --text="$WORD47" --radiolist  --column="$WORD18" --column="$WORD48" --column="$WORD49" TRUE "$WORD50 " "$WORD51" FALSE "$WORD52 " "$WORD53" )

      CHECKFORCANCEL

      case "$ARMOR" in
         "$WORD52 " )
            sed -i '7s/.*/ARMOR=\"'--armor'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
            sed -i '12s/.*/ARMORTYPE=\"ACSII Armored \"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
       esac

      else

      ARMOR=$(zenity --list --title="$WORD1" --height="$HEIGHT" --width="$WIDTH" --text="$WORD47" --radiolist  --column="$WORD18" --column="$WORD48" --column="$WORD49" TRUE "$WORD50 " "$WORD61" FALSE "$WORD52 " "$WORD60" )

      CHECKFORCANCEL
 
      case "$ARMOR" in
         "$WORD52 " )
            sed -i '7s/.*/ARMOR=\"'-a'\"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
            sed -i '12s/.*/ARMORTYPE=\"Base64 Armored \"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
	           ;;
       esac

      fi
   else
      if [ "$EDITION" = "GPG" ]; then
         sed -i '12s/.*/ARMORTYPE=\"ACSII Armored \"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
      else
         sed -i '12s/.*/ARMORTYPE=\"Base64 Armored \"/' ~/.gnome2/nemo-scripts/"$EDITIONNAME"
      fi
   fi

   zenity --info --title="$WORD1" --text="$WORD63"
   zenity --info --title="$WORD1" --text="$EDITIONNAME $WORD54 $ARMOR$ENCRYPTIONTYPE $WORD55"
   exit
fi

# =============================================================================================================
# Check For Multi-Selection:
if [ "$PURPOSE" = "Files" ]; then
   if ! [ "$2" = "" ]; then
      zenity --error --title="$WORD1" --text="$WORD4"
      exit
   fi
fi

# =============================================================================================================
# Check For No Selection:
if [ "$FILE" = "" ] && [ "$PURPOSE" = "Files" ]; then
   zenity --error --title="$WORD1" --text="Currently the Feature to Browse for files to encrypt is broken. This will hopefully be fixed soon. Thankyou."
   exit
#   OBJECTTYPE=$(zenity --list --title="$WORD1" --text="$WORD67" --radiolist  --column="$WORD18" --column="$WORD68" TRUE "$WORD69" FALSE "$WORD70" )
#
#   CHECKFORCANCEL
#
#      case "$OBJECTTYPE" in
#         "$WORD69" )
#            FILE=`zenity --title="$WORD65" --file-selection`
#	           ;;
#         "$WORD70" )
#            FILE=`zenity --title="$WORD66" --file-selection --directory`
#	           ;;
#       esac
#
#   FILE="${FILE##*/}"
#   EXTENSION=${FILE#*.}
#   BASEFILE=${FILE%%.*}Turbo-Secure
#   ORIGINALNAME="$1"
fi

# =============================================================================================================
# If we are Encrypting/Decrypting Text:

if [ "$PURPOSE" = "Text" ]; then
   INPUTPASSWORD
   while true; do
   TEXT=`zenity --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption) (Encrypt/Decrypt Text)" --height="$HEIGHT" --width="$WIDTH" --text-info --editable`
   CANCELBREAK
   if [ "$EDITION" = "GPG" ]; then
      if [[ "$TEXT" =~ "BEGIN PGP MESSAGE" ]]; then
         DRIVE="Decrypt"
      else
         DRIVE="Encrypt"
      fi
   else
   DRIVE=$(zenity --list --width="400" --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption)" --text="What do you want to do?" --radiolist  --column="$WORD18" --column="Option:" TRUE "Encrypt" FALSE "Decrypt" )

   CANCELBREAK
 
   fi

   if [ "$EDITION" = "GPG" ]; then
      case "$DRIVE" in
         "Encrypt" )
            TEXT=`echo "$TEXT" | gpg --symmetric --force-mdc --armor --passphrase "$PASSWORD" --cipher-algo "$ENCRYPTIONTYPE" --no-use-agent`
            echo "$TEXT" | zenity --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption) (Results from Encryption)" --height="$HEIGHT" --width="$WIDTH" --text-info
            CANCELBREAK
	           ;;
         "Decrypt" )
            if [[ "$TEXT" =~ "-----BEGIN PGP MESSAGE-----" ]] && [[ "$TEXT" =~ "-----END PGP MESSAGE-----" ]]; then
               TEXT=`echo "$TEXT" | gpg --passphrase "$PASSWORD" --no-use-agent`
               echo "$TEXT" | zenity --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption) (Results from Decryption)" --height="$HEIGHT" --width="$WIDTH" --text-info --editable
               CANCELBREAK
            else
               zenity --error --title="$WORD1" --text="-----BEGIN PGP MESSAGE-----\n\n-----END PGP MESSAGE-----\n\nCan not decrypt text. PGP Banners are missing\! Message can not be decrypted without them\! Please try again with including them."
               CANCELBREAK
            fi
	           ;;

       esac
    else
      case "$DRIVE" in
         "Encrypt" )
            TEXT=`echo "$TEXT" | openssl "$ENCRYPTIONTYPE" -a $USESALT -pass pass:"$PASSWORD"`
            echo "$TEXT" | zenity --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption) (Results From Encryption)" --text-info --height="$HEIGHT" --width="$WIDTH"
            CANCELBREAK
	           ;;
         "Decrypt" )
            TEXT=`echo "$TEXT" | openssl "$ENCRYPTIONTYPE" -pass pass:"$PASSWORD" -a -d`
            echo "$TEXT" | zenity --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption) Results From Decryption)" --text-info --editable --height="$HEIGHT" --width="$WIDTH"
            CANCELBREAK
	           ;;
       esac
   fi
   done
   exit
fi

# =============================================================================================================
# Check if $PASSWORD is set:

INPUTPASSWORD

# =============================================================================================================
# If folder, compress:
if [ -d "$FILE" ] && [ "$PURPOSE" = "Files" ]; then
   FOLDER="YES"
   (
   echo "# $WORD11"
   tar czvf "$FILE.tar.gz" "$FILE"
   ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
   FILE="$FILE.tar.gz"
fi

# =============================================================================================================
# If we are Encrypting/Decrypting Files:

if [[ "$FILE" =~ ".gpg" ]] || [[ "$FILE" =~ ".asc" ]] || [[ "$FILE" =~ ".enc" ]]; then
   # Decrypt:
   TASK="$WORD5"
   (
   echo "# Decrypting.... ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption)"
   if [ "$EDITION" = "GPG" ]; then
      gpg --batch --passphrase "$PASSWORD" --no-use-agent "$FILE"
         if ! [ "$?" = "0" ] ; then
         echo "FAIL" >> /tmp/Turbo-Secure-$PURPOSE.tmp
      fi
   else
      openssl "$ENCRYPTIONTYPE" "$USESALT" "$ARMOR" -pass pass:"$PASSWORD" -d -in "$FILE" -out "$NONENCRYPTEDFILENAME"
      if ! [ "$?" = "0" ] ; then
         echo "FAIL" >> /tmp/Turbo-Secure-$PURPOSE.tmp
      fi
   fi
   ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
   if [ -e /tmp/Turbo-Secure-$PURPOSE.tmp ]; then
      zenity --error --title="$WORD1" --text="$TASK $WORD10 $WORD58"
      rm -f /tmp/Turbo-Secure-$PURPOSE.tmp
      exit
   fi
   if [ "$EXTENSION" = "tar.gz.gpg" ] || [ "$EXTENSION" = "tar.gz.asc" ] || [ "$EXTENSION" = "tar.gz.enc" ]; then
      (
      echo "# $WORD12"
      tar -zxvf "$BASEFILE.tar.gz"
      rm -f "$BASEFILE.tar.gz"
      ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
   fi
   rm -f "$FILE"
else
   # Encrypt:
   TASK="$WORD6"
   if [ "$EDITION" = "GPG" ]; then
      (
      echo "# $WORD8 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption)"
      gpg --batch --passphrase "$PASSWORD" -z $COMPRESSION $ARMOR --force-mdc --no-use-agent --cipher-algo "$ENCRYPTIONTYPE" --symmetric "$FILE"
      if ! [ "$?" = "0" ] ; then
         echo "FAIL" >> /tmp/Turbo-Secure-$PURPOSE.tmp
      fi
      ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
   else
      (
      echo "# $WORD8"
      openssl "$ENCRYPTIONTYPE" $USESALT $ARMOR -pass pass:"$PASSWORD" -in "$FILE" -out "$FILE".enc
      if ! [ "$?" = "0" ] ; then
         echo "FAIL" >> /tmp/Turbo-Secure-$PURPOSE.tmp
      fi
      ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
      if [ -e /tmp/Turbo-Secure-$PURPOSE.tmp ]; then
         zenity --error --title="$WORD1" --text="$TASK $WORD10"
         rm -f /tmp/Turbo-Secure-$PURPOSE.tmp
         exit
      fi
   fi
      if [ "$?" = "0" ] ; then
         if [ "$FOLDER" = "YES" ]; then
             if $WIPE_INSTALLED = "YES" ]; then
                (
                echo "# Securely Wiping Unencrypted Temporary Archive..."
                wipe -r -f -q -Q 3 "$FILE"
                ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
             else
                rm -f -r "$FILE"
             fi
         fi
         if `zenity --question --title="$WORD1 ($ARMORTYPE$EDITION $ENCRYPTIONTYPE Encryption)" --text="$TASK $WORD9 $WORD14"` ; then
             if [ "$WIPE_INSTALLED" = "YES" ]; then
                (
                echo "# Securely Wiping Un-Encrypted Copy. Please Wait..."
                wipe -r -f -q -Q 3 "$ORIGINALNAME"
                wait 10
                ) | zenity --width="400" --progress --percentage=0 --auto-close --auto-kill --pulsate
             else
                rm -f -r "$ORIGINALNAME"
             fi
         fi
      else
         zenity --error --title="$WORD1" --text="$TASK $WORD10"
      fi
fi

exit
