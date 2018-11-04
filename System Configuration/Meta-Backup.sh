#!/bin/bash
## Written by Arjan van Lent aka socialdefect ######
################ Licence GPL3 ######################
## check my blog @ http://socialdefect.nl ##########
####################################################
## thanx to Andrew (http://www.blogger.com/profile/13488704552047146331)
## for providing a better way to get the installed applications
## (http://www.webupd8.org/2010/03/2-ways-of-reinstalling-all-of-your.html)


## DIALOGS (formerly found in the 'lang-en text' file)
DIALOG1="Did you enable extra repositories or PPAs on this system?. If you have no idea what this is just enter no"
DIALOG2="Your backup has been created in $HOME"
DIALOG3="Something went wrong. Type bash -x meta-backup in a terminal to debug"

## creating build directories
mkdir -p ~/my-meta-backup/DEBIAN

## repository dialog
## question add repo's
zenity --question --text "$DIALOG1"
if [ $? = 0 ] ; then
  mkdir -p ~/my-repo-backup/etc/apt/sources.list.d
  mkdir ~/my-repo-backup/DEBIAN
  cp -R /etc/apt/sources.list.d/* ~/my-repo-backup/etc/apt/sources.list.d/
  cp -R /etc/apt/sources.list ~/my-repo-backup/etc/apt/

## create the control file for the repository backup
echo 'Section: misc
Priority: optional
Package: my-repo-backup
Version: 2.0
Maintainer: meta-backup
Depends:
Architecture: all
Description: Repository backup created by meta-backup
 Repository backup created by meta-backup. This package can be used to install all applications that are installed on the computer where the backup is made. Can be used on all systems using the same base system version as used on the backup machine.' >> ~/my-repo-backup/DEBIAN/control

## create the postinst file for the repository backup
echo '#!/bin/sh
set -e

##################################################
# Pubkeys (to generate this large key, which is  #
# all of them in one: sudo apt-key exportall >	 #
# /tmp/repokeys.key)				 #
##################################################

if [ -f /tmp/repokeys.key ];then
	rm /tmp/repokeys.key
fi
sudo cat > "/tmp/repokeys.key" <<"End-of-message"' >> ~/my-repo-backup/DEBIAN/postinst

## get the repository keys
apt-key exportall >> ~/my-repo-backup/DEBIAN/postinst

echo 'End-of-message
if which sudo apt-key >> /dev/null; then
	if sudo apt-key add "/tmp/repokeys.key"; then
		echo "OK - repokeys key was installed"
	else
		echo "ERROR: there was a problem installing the repokeys-key"
	fi
fi
sudo rm -fv "/tmp/repokeys.key"' >> ~/my-repo-backup/DEBIAN/postinst

chmod +x ~/my-repo-backup/DEBIAN/postinst

fi

## get the list of installed packages to fill the DEPS variable
  DEPS=`aptitude search -F %p ~i --disable-columns | sed 's/$/,/' | tr '\n\r' ' ' | sed 's/, $//'`

## create the control file
echo "Section: misc
Priority: optional
Package: my-meta-backup
Version: 2.0
Maintainer: meta-backup
Depends: $DEPS
Architecture: all
Description: Personal system backup created by meta-backup
 Personal system backup created by meta-backup. This package can be used to install all applications that are installed on the computer where the backup is made. Can be used on all systems using the same base system version as used on the backup machine." >> ~/my-meta-backup/DEBIAN/control

## build the package(s)
cd && dpkg --build my-meta-backup

if [ $? = 0 ] ; then
    cd && dpkg --build my-repo-backup
fi

## cleaning up
rm -rf ~/my-meta-backup
if [ $? = 0 ] ; then
    rm -rf ~/my-repo-backup
fi

## finish backup
ls ~/my-meta-backup.deb
  if [ $? = 0 ] ; then
    ERROR=no
    else ERROR=yes
  fi

ls ~/my-repo-backup.deb
  if [ $? = 0 ] ; then
    ERROR=no
  else ERROR=yes
  fi

  ## Display exit message
if [ $ERROR = no ] ; then
  zenity --info --text "$DIALOG2"
 else
  zenity --error --text "$DIALOG3"
fi

exit 0
