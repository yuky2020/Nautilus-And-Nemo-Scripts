#!/bin/bash
set -e

#multicd.sh 6.2
#Copyright (c) 2010 libertyernie
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

#MCDDIR: directory where plugins.md5 and plugins folder are expected to be.
MCDDIR=$(pwd)
#WORK: the directory that the eventual CD/DVD contents will be stored temporarily.
export WORK=$(pwd)/multicd-working
#MNT: the directory inside which new folders will be made to mount the ISO images.
mkdir -p /tmp/multicd-$USER
export MNT=/tmp/multicd-$USER
#TAGS: used to store small text files (temporary)
export TAGS=$MNT/tags


if echo $* | grep -q "\bcleanlinks\b";then
	ls -la |grep ^l |awk '{ print $8,$10 }'|while read i;do
		if echo $i|awk '{print $2}'|grep -qv "/";then
			rm -v $(echo $i|awk '{print $1}')
		fi
	done
	rm -fv *.defaultname 2> /dev/null
	rm -fv *.version 2> /dev/null
	exit 0
fi

if !(uname|grep -q Linux);then
	echo "Only Linux kernels are supported at the moment (due to heavy use of \"-o loop\")."
fi
if [ $(whoami) != "root" ];then
	echo "This script must be run as root, so it can mount ISO images on the filesystem during the building process."
	exit 1
fi

if [ -d $TAGS ];then rm -r $TAGS;fi
mkdir -p $TAGS
mkdir $TAGS/puppies
mkdir $TAGS/redhats
chmod -R 777 $TAGS

if ( echo $* | grep -q "\bmd5\b" ) || ( echo $* | grep -q "\bc\b" );then
	MD5=true
else
	MD5=false
fi
if echo $* | grep -q "\bm\b";then
	MEMTEST=false
else
	MEMTEST=true
fi
if echo $* | grep -q "\bv\b";then
	export VERBOSE=true
else
	export VERBOSE=false
fi
if echo $* | grep -q "\bi\b";then
	INTERACTIVE=true
else
	INTERACTIVE=false
fi
if ( echo $* | grep -q "\bw\b" ) || ( echo $* | grep -q "\bwait\b" );then
	WAIT=true
else
	WAIT=false
fi

#START PREPARE#
#!/bin/sh
mcdmount () {
	# $MNT is defined in multicd.sh and is normally in /tmp
	# $1 is the argument passed to mcdmount - used for both ISO name and mount folder name
	if [ ! -d $MNT/$1 ];then
		mkdir $MNT/$1
	fi
	if grep -q $MNT/$1 /etc/mtab ; then
		umount $MNT/$1
	fi
	mount -o loop $1.iso $MNT/$1/
}
umcdmount () {
	umount $MNT/$1;rmdir $MNT/$1
}

isoaliases () {
true > $TAGS/linklist
#START LINKS#
	echo "archiso-live-*.iso archiso-live.iso" >> $TAGS/linklist
	echo "avg_*.iso avg.iso" >> $TAGS/linklist
	#Note the 5 - only Lenny picked up >> $TAGS/linklist
	echo "debian-5*.iso debian-install.iso" >> $TAGS/linklist
	echo "Fedora-*-i386-netinst.iso fedora-boot.iso" >> $TAGS/linklist
	echo "Fedora-*-x86_64-netinst.iso fedora-boot64.iso" >> $TAGS/linklist
	echo "gparted-live-*.iso gparted.iso" >> $TAGS/linklist
	echo "KNOPPIX_V*.iso knoppix.iso" >> $TAGS/linklist
	echo "linuxmint-gnome*.iso linuxmint.iso" >> $TAGS/linklist
	echo "linuxmint-kde*.iso linuxmint.iso" >> $TAGS/linklist
	echo "linuxmint-xfce*.iso linuxmint.iso" >> $TAGS/linklist
	echo "linuxmint-lxde*.iso linuxmint.iso" >> $TAGS/linklist
	echo "linuxmint-fluxbox*.iso linuxmint.iso" >> $TAGS/linklist
	echo "linuxmint-debian-*.iso mintdebian.iso" >> $TAGS/linklist
	echo "NetbootCD-*.iso netbootcd.iso" >> $TAGS/linklist
	echo "openSUSE-*-GNOME-LiveCD-i686.iso opensuse-gnome.iso" >> $TAGS/linklist
	echo "openSUSE-*-NET-i586.iso opensuse-net.iso" >> $TAGS/linklist
	echo "openSUSE-*-NET-x86_64.iso opensuse-net64.iso" >> $TAGS/linklist
	echo "pclinuxos-*.iso pclos.iso" >> $TAGS/linklist
	echo "lupu-*.iso puppy.iso" >> $TAGS/linklist
	echo "slax-*.iso slax.iso" >> $TAGS/linklist
	echo "systemrescuecd-x86-*.iso sysrcd.iso" >> $TAGS/linklist
	echo "tinycore-current.iso tinycore.iso" >> $TAGS/linklist
	echo "tinycore_*.iso tinycore.iso" >> $TAGS/linklist
	echo "trinity-rescue-kit.*.iso trk.iso" >> $TAGS/linklist
	echo "ubuntu-*-desktop-i386.iso i386.ubuntu.iso Ubuntu_(32-bit)" >> $TAGS/linklist
	echo "ubuntu-*-desktop-amd64.iso amd64.ubuntu.iso Ubuntu_(64-bit)" >> $TAGS/linklist
	echo "kubuntu-*-desktop-i386.iso i386.k.ubuntu.iso Kubuntu_(32-bit)" >> $TAGS/linklist
	echo "kubuntu-*-desktop-amd64.iso amd64.k.ubuntu.iso Kubuntu_(64-bit)" >> $TAGS/linklist
	echo "xubuntu-*-desktop-i386.iso i386.x.ubuntu.iso Xubuntu_(32-bit)" >> $TAGS/linklist
	echo "xubuntu-*-desktop-amd64.iso amd64.x.ubuntu.iso Xubuntu_(64-bit)" >> $TAGS/linklist
	echo "edubuntu-*-dvd-i386.iso i386.x.ubuntu.iso Edubuntu_(32-bit)" >> $TAGS/linklist
	echo "edubuntu-*-dvd-amd64.iso amd64.x.ubuntu.iso Edubuntu_(64-bit)" >> $TAGS/linklist
#END LINKS#
cat $TAGS/linklist|while read i;do
	IM1=$(echo $i|awk '{print $1}')
	IM2=$(echo $i|awk '{print $2}')
	if (echo $i|awk '{print $3}'|grep -q '\.iso') || [ -n "$(echo $i|awk '{print $4}')" ];then
		echo "More than one matching ISO: $IM1, $IM2 (did not make link)"
	elif [ -e $IM1 ] && [ ! -e $IM2 ];then
		if ln -s $IM1 $IM2;then
			ISOBASENAME=$(echo $IM2|sed -e 's/\.iso//g')
			touch $TAGS/madelinks #This is to make multicd.sh pause for 1 second so the notifications are readable
			CUTOUT1=$(echo "$i"|awk 'BEGIN {FS = "*"} ; {print $1}') #The parts of the ISO name before the asterisk
			CUTOUT2=$(echo "$i"|awk '{print $1}'|awk 'BEGIN {FS = "*"} ; {print $2}') #The parts after the asterisk
			VERSION=$(echo "$IM1"|awk '{sub(/'"$CUTOUT1"'/,"");sub(/'"$CUTOUT2"'/,"");print}') #Cuts out whatever the asterisk represents (which will be the version number)
			if [ "$VERSION" != "*" ] && [ "$VERSION" != "$IM1" ];then
				echo $VERSION > $ISOBASENAME.version #The SystemRescueCD plugin does not use this, but I figure it won't do any harm to have an extra file sitting there.
				echo "Made a link named $IM2 pointing to $IM1 (version $VERSION)"
			else	
				echo "Made a link named $IM2 pointing to $IM1"
				VERSION="*" #Should remain an asterisk in .defaultname file (see below)
			fi
			if [ -n "$(echo $i|awk '{print $3}')" ];then
				#The third field of the row will be the default name when multicd.sh asks the user to enter a name.
				#This could also be used by the menu-writing portion of the plugin script if $TAGS/whatever.name is not present.
				#Underscores are replaced with spaces. Asterisks are replaced with the $VERSION found above.
				echo $i|awk '{print $3}'|sed -e 's/_/ /g' -e "s/\*/$VERSION/g">$ISOBASENAME.defaultname
			fi
		fi
	fi
done
if [ -f $TAGS/madelinks ];then
	rm $TAGS/madelinks
	sleep 1
fi
}

tinycorecommon () {
	if [ ! -z "$1" ] && [ -f $1.iso ];then
		mcdmount $1
		mkdir $WORK/boot/tinycore
		cp $MNT/$1/boot/bzImage $WORK/boot/tinycore/bzImage #Linux kernel
		cp $MNT/$1/boot/*.gz $WORK/boot/tinycore/ #Copy any initrd there may be - this works for microcore too
		if [ -d $MNT/$1/tce ];then
			cp -r $MNT/$1/tce $WORK/
		fi
		sleep 1
		umcdmount $1
	else
		echo "$0: \"$1\" is empty or not an ISO"
		exit 1
	fi
}
puppycommon () {
	if [ ! -z "$1" ] && [ -f $1.iso ];then
		mcdmount $1
		#The installer will only work if Puppy is in the root dir of the disc
		if [ -f $TAGS/puppies/$1.inroot ];then
			cp $MNT/$1/*.sfs $WORK/
			cp $MNT/$1/vmlinuz $WORK/vmlinuz
			cp $MNT/$1/initrd.gz $WORK/initrd.gz
		else
			mkdir $WORK/$1
			cp $MNT/$1/*.sfs $WORK/$1/
			cp $MNT/$1/vmlinuz $WORK/$1/vmlinuz
			cp $MNT/$1/initrd.gz $WORK/$1/initrd.gz
		fi
		umcdmount $1
	else
		echo "$0: \"$1\" is empty or not an ISO"
		exit 1
	fi
}
ubuntucommon () {
	if [ ! -z "$1" ] && [ -f $1.iso ];then
		mcdmount $1
		cp -R $MNT/$1/casper $WORK/boot/$1 #Live system
		if [ -d $MNT/$1/preseed ];then
			cp -R $MNT/$1/preseed $WORK/boot/$1
		fi
		# Fix the isolinux.cfg
		if [ -f $MNT/$1/isolinux/text.cfg ];then
			UBUCFG=text.cfg
		elif [ -f $MNT/$1/isolinux/txt.cfg ];then
			UBUCFG=txt.cfg
		else
			UBUCFG=isolinux.cfg #For custom-made live CDs
		fi
		cp $MNT/$1/isolinux/$UBUCFG $WORK/boot/$1/$1.cfg
		sed -i "s@default live@default menu.c32@g" $WORK/boot/$1/$1.cfg #Show menu instead of boot: prompt
		sed -i "s@file=/cdrom/preseed/@file=/cdrom/boot/$1/preseed/@g" $WORK/boot/$1/$1.cfg #Preseed folder moved - not sure if ubiquity uses this
		sed -i "s^initrd=/casper/^live-media-path=/boot/$1 ignore_uuid initrd=/boot/$1/^g" $WORK/boot/$1/$1.cfg #Initrd moved, ignore_uuid added
		sed -i "s^kernel /casper/^kernel /boot/$1/^g" $WORK/boot/$1/$1.cfg #Kernel moved
		if [ $(cat $TAGS/lang) != en ];then
			sed -i "s^initrd=/boot/$1/^debian-installer/language=$(cat $TAGS/lang) console-setup/layoutcode?=$(cat $TAGS/lang) initrd=/boot/$1/^g" $WORK/boot/$1/$1.cfg #Add language codes to cmdline
		fi
		umcdmount $1
	else
		echo "$0: \"$1\" is empty or not an ISO"
		exit 1
	fi
}
#END FUNCTIONS
#END PREPARE#

isoaliases #This function is in functions.sh

#START SCAN
	if [ -f antix.iso ];then
		echo "AntiX"
	fi
	if [ -f arch.iso ];then
		echo "Arch Linux"
	fi
	if [ -f archdual.iso ];then
		echo "Arch Linux Dual"
	fi
	if [ -f archiso-live.iso ];then
		echo "Archiso-live"
	fi
	if [ -f austrumi.iso ];then
		echo "Austrumi"
	fi
	if [ -f avg.iso ];then
		echo "AVG Rescue CD"
	fi
	if [ -f backtrack.iso ];then
		echo "BackTrack"
	fi
	if [ -f caine.iso ];then
		echo "Caine"
	fi
	if [ -f cdl.iso ];then
		echo "CDlinux"
	fi
	if [ -f clonezilla.iso ];then
		echo "Clonezilla"
	fi
	if [ -f dban.iso ];then
		echo "DBAN"
	fi
	if [ -f debian-install.iso ];then
		echo "Debian installer"
	fi
	if [ -f binary.iso ];then
		echo "Debian Live"
		touch $TAGS/debian-live.needsname #Comment out this line and multicd.sh won't ask for a custom name for this ISO
	fi
	if [ -f debian-mini.iso ];then
		echo "Debian netboot installer"
	fi
	if [ -f deli.iso ];then
		echo "DeLi Linux"
	fi
	if [ -f diskcopy.iso ];then
		echo "EASEUS Disk Copy"
	fi
	if [ -f dsl.iso ];then
		echo "Damn Small Linux"
	fi
	if [ -f dvl.iso ];then
		echo "Damn Vulnerable Linux"
	fi
	if [ -f efw.iso ];then
		echo "Endian Firewall"
	fi
	if [ -f elastix.iso ];then
		echo "Elastix"
		touch $TAGS/redhats/elastix
	fi
	if [ -f feather.iso ];then
		echo "Feather"
	fi
	if [ -f fedora-boot.iso ];then
		echo "Fedora netboot installer"
		touch $TAGS/redhats/fedora-boot
	fi
	if [ -f fedora-boot64.iso ];then
		echo "Fedora 64-bit netboot installer"
		touch $TAGS/redhats/fedora-boot64
	fi
	if [ -f finnix.iso ];then
		echo "Finnix"
	fi
	if [ -f fdfullcd.iso ] || [ -f fdbasecd.iso ];then
		echo "FreeDOS"
	fi
	if [ -f geexbox.iso ];then
		echo "GeeXboX"
	fi
	if [ -f gparted.iso ];then
		echo "GParted Live"
	fi
	if [ -f hirens.iso ];then
		echo "Hiren's BootCD (Not open source - do not distribute)"
		DUPLICATES=false #Initialize variable
		for i in riplinux dban konboot ntpasswd;do
			if [ -f $i.iso ];then
				echo
				echo "Note: Hiren's BootCD already includes $i."
				DUPLICATES=true
			fi
		done
		if $DUPLICATES;then
			echo "Continuing anyway."
			echo
		fi
	fi
	if [ -f insert.iso ];then
		echo "INSERT"
	fi
	if [ -f ipcop.iso ];then
		echo "IPCop"
		touch $TAGS/redhats/ipcop
	fi
	if [ -f knoppix.iso ];then
		echo "Knoppix"
		export KNOPPIX=1
	fi
	if [ -f linuxmint.iso ];then
		echo "Linux Mint (8/Helena or newer)"
	fi
	if [ -f macpup.iso ];then
		echo "Macpup"
		touch $TAGS/puppies/macpup
	fi
	if [ -f mandriva-boot.iso ];then
		echo "Mandriva netboot installer"
	fi
	if [ -f mintdebian.iso ];then
		echo "Linux Mint Debian Edition"
	fi
	if [ -f netbootcd.iso ];then
		echo "NetbootCD"
	fi
	if [ -f ntpasswd.iso ];then
		echo "NT Password Editor"
	fi
	if [ -f opensuse-gnome.iso ];then
		echo "openSUSE GNOME Live CD"
	fi
	if [ -f opensuse-net.iso ];then
		echo "openSUSE netboot installer"
	fi
	if [ -f opensuse-net64.iso ];then
		echo "openSUSE 64-bit netboot installer"
	fi
	if [ -f ophxp.iso ] && [ ! -f ophvista.iso ];then
		echo "OPH Crack XP"
	fi
	if [ ! -f ophxp.iso ] && [ -f ophvista.iso ];then
		echo "OPH Crack Vista"
	fi
	if [ -f ophxp.iso ] && [ -f ophvista.iso ];then
		echo "OPH Crack XP/Vista"
	fi
	if [ -f pclos.iso ];then
		echo "PCLinuxOS"
	fi
	if [ -f pclx.iso ];then
		echo "PCLinuxOS LXDE"
	fi
	if [ -f ping.iso ];then
		echo "PING"
	fi
	if [ -f pmagic.iso ];then
		echo "Parted Magic"
	fi
	if [ -f puppy.iso ];then
		echo "Puppy Linux"
		touch $TAGS/puppies/puppy
		#touch $TAGS/puppy.needsname #Comment out this line and multicd.sh won't ask for a custom name for this ISO
	fi
	if [ -f puppy2.iso ];then
		echo "Puppy Linux #2"
		touch $TAGS/puppies/puppy2
		touch $TAGS/puppy2.needsname #Comment out this line and multicd.sh won't ask for a custom name for this ISO
	fi
	if [ -f riplinux.iso ];then
		echo "RIPLinuX"
	fi
	if [ -f slax.iso ];then
		echo "Slax"
	fi
	if [ -f slitaz.iso ];then
		echo "SliTaz"
	fi
	if [ -f sysrcd.iso ];then
		echo "SystemRescueCd"
	fi
	if [ -f tcnet.iso ];then
		echo "TCNet"
	fi
	if [ -f tinycore.iso ];then
		echo "Tiny Core Linux"
		#touch $TAGS/tinycore.needsname #Comment out this line and multicd.sh won't ask for a custom name for this ISO
	fi
	if [ -f tinycore2.iso ];then
		echo "Tiny Core Linux"
		touch $TAGS/tinycore2.needsname #Comment out this line and multicd.sh won't ask for a custom name for this ISO
	fi
	if [ -f tinyme.iso ];then
		echo "TinyMe"
	fi
	if [ -f trk.iso ];then
		echo "Trinity Rescue Kit"
	fi
	if [ -f ubcd.iso ];then
		echo "Ultimate Boot CD"
	fi
	if [ -f dban.iso ] && [ -f ubcd.iso ];then
		echo
		echo "Note: Ultimate Boot CD includes DBAN, so it is not necessary alone as well."
		echo "Continuing anyway."
	fi
	if [ -f ntpasswd.iso ] && [ -f ubcd.iso ];then
		echo
		echo "Note: UBCD includes NT Password & Registry Editor, so it is not necessary alone as well."
		echo "Continuing anyway."
	fi
	if [ -f ubuntu-mini.iso ];then
		echo "Ubuntu netboot installer"
	fi
	if [ "*.ubuntu.iso" != "$(echo *.ubuntu.iso)" ];then for i in *.ubuntu.iso; do
		BASENAME=$(echo $i|sed -e 's/\.iso//g')
		if [ -f $BASENAME.defaultname ] && [ "$(cat $BASENAME.defaultname)" != "" ];then
			cat $BASENAME.defaultname
		else
			echo $i
		fi
		echo > $TAGS/$(echo $i|sed -e 's/\.iso/\.needsname/g') #Comment out this line and multicd.sh won't ask for a custom name for this ISO
	done;fi
	if [ -f vyatta.iso ];then
		echo "Vyatta"
	fi
	if [ -f weaknet.iso ];then
		echo "WeakNet Linux"
	fi
	if [ -f win7recovery.iso ];then
		echo "Windows 7 Recovery Disc (Not open source - do not distribute)"
	fi
	if [ -f win98se.iso ];then
		echo "Windows 98 SE (Not open source - do not distribute)"
		touch tags/win9x
	fi
	if [ -f winme.iso ];then
		echo "Windows Me (Not open source - do not distribute)"
		touch tags/win9x
	fi
	if [ -f wolvix.iso ];then
		echo "Wolvix"
	fi
#END SCAN

for i in *.im[agz]; do
 test -r "$i" || continue
 echo $i|sed 's/\.im.//'
done
GAMES=0 #Will be changed if there are games
for i in games/*.im[agz]; do
 test -r "$i" || continue
 echo Game: $(echo $i|sed 's/\.im.//'|sed 's/games\///')
 GAMES=1
done
if [ -f grub.exe ];then
 echo "GRUB4DOS"
fi
if $MEMTEST;then
 echo "Memtest86+"
fi

echo
echo "Continuing in 2 seconds - press Ctrl+C to cancel"
sleep 2

if $INTERACTIVE;then
	if ! which dialog &> /dev/null;then
		echo "You must install dialog to use the interactive options."
		exit 1
	fi
	dialog --inputbox "What would you like the title of the CD's main menu to be?" 8 70 "MultiCD - Created $(date +"%b %d, %Y")" 2> /tmp/cdtitle
	CDTITLE=$(cat /tmp/cdtitle)
	rm /tmp/cdtitle
	dialog --inputbox "What would you like the CD label to be?" 9 40 "MultiCD" 2> /tmp/cdlabel
	export CDLABEL=$(cat /tmp/cdlabel)
	rm /tmp/cdlabel
	dialog --menu "What menu color would you like?" 0 0 0 40 black 41 red 42 green 43 brown 44 blue 45 magenta 46 cyan 2> /tmp/color
	MENUCOLOR=$(cat /tmp/color)
	echo $(echo -e "\r\033[0;$(cat /tmp/color)m")Color chosen.$(echo -e '\033[0;39m')
	rm /tmp/color
	dialog --inputbox "Enter the two-letter language code for the language you would like to use." 9 50 "en" 2> $TAGS/lang
	if [ -f slax.iso ];then
		dialog --checklist "Slax modules to include:" 13 45 6 \
		002 Xorg on \
		003 KDE on \
		004 "KDE applications" on \
		005 "KDE Office" on \
		006 Development on \
		007 Firefox on \
		2> ./slaxlist0
		echo >> ./slaxlist0
		cat ./slaxlist0|sed -e 's/"//g' -e 's/ /\n/g'>$TAGS/slaxlist
		rm ./slaxlist0
		if wc -c $TAGS/slaxlist|grep -q 24;then #24 bytes means they are all checked
			rm $TAGS/slaxlist #If they are all checked, delete the file
		fi
	fi
	if [ -f win98se.iso ] || [ -f winme.iso ];then
		if dialog --yesno "Would you like to copy the \"tools\" and \"add-ons\" folders from the Windows 9x/Me CD?" 0 0;then
			touch $TAGS/9xextras
		fi
	fi
	if [ $(find $TAGS/puppies -maxdepth 1 -type f|wc -l) -gt 1 ] && which dialog &> /dev/null;then
		echo "dialog --radiolist \"Which Puppy variant would you like to be installable to HD from the disc?\" 13 45 6 \\">puppychooser
		for i in $TAGS/puppies/*;do
			echo $(basename $i) \"\" off \\ >> puppychooser
		done
		echo "2> puppyresult" >> puppychooser
		sh puppychooser
		touch $TAGS/puppies/$(cat puppyresult).inroot
		rm puppychooser puppyresult
	fi
	if [ $(find $TAGS/redhats -maxdepth 1 -type f|wc -l) -gt 1 ] && which dialog &> /dev/null;then
		echo "dialog --radiolist \"Which Red Hat/Fedora variant should have its files stored on the CD, so they don't need to be downloaded later?\" 13 45 6 \\">puppychooser
		for i in $TAGS/redhats/*;do
			echo $(basename $i) \"\" off \\ >> redhatchooser
		done
		echo "2> rehdatresult" >> redhatchooser
		sh redhatchooser
		touch $TAGS/redhats/$(cat redhatresult).images
		rm redhatchooser redhatresult
	fi
	if [ $(find $TAGS/puppies -maxdepth 1 -type f|wc -l) -eq 1 ];then
		NAME=$(ls $TAGS/puppies)
		true>$(find $TAGS/puppies -maxdepth 1 -type f).inroot
	fi
	if which dialog &> /dev/null;then
		for i in $(find $TAGS -maxdepth 1 -name \*.needsname);do
			BASENAME=$(basename $i|sed -e 's/\.needsname//g')
			if [ -f $BASENAME.defaultname ];then
				DEFUALTTEXT=$(cat $BASENAME.defaultname)
			else
				DEFAULTTEXT=""
			fi
			dialog --inputbox "What would you like $BASENAME to be called on the CD boot menu?\n(Leave blank for the default.)" 10 70 \
			2> $(echo $i|sed -e 's/needsname/name/g')
			if [ "$(cat $TAGS/$BASENAME.name)" = "" ] && [ -f $BASENAME.defaultname ];then
				cp $BASENAME.defaultname $TAGS/$BASENAME.name
			fi
		done
	else
		for i in $(find $TAGS -maxdepth 1 -name \*.needsname);do
			BASENAME=$(basename $i|sed -e 's/\.needsname//g')
			if [ -f $BASENAME.defaultname ];then
				cp $BASENAME.defaultname $TAGS/$BASENAME.name
			fi
		done
	fi
else
	CDTITLE="MultiCD - Created $(date +"%b %d, %Y")"
	export CDLABEL=MultiCD
	MENUCOLOR=44
	echo en > $TAGS/lang
	touch $TAGS/9xextras
	for i in puppies redhats;do
		if [ $(find $TAGS/$i -maxdepth 1 -type f|wc -l) -ge 1 ] && which dialog &> /dev/null;then #Greater or equal to 1 puppy installed
			touch $(find $TAGS/$i -maxdepth 1 -type f|head -n 1) #This way, the first one alphabetically will be in the root dir
		fi
	done
	for i in $(find $TAGS -maxdepth 1 -name \*.needsname);do
		BASENAME=$(basename $i|sed -e 's/\.needsname//g')
		if [ -f $BASENAME.defaultname ];then
			cp $BASENAME.defaultname $TAGS/$BASENAME.name
		fi
	done
fi

if [ -d $WORK ];then
 rm -r $WORK/*
else
 mkdir $WORK
fi

#Make sure it exists, you need to put stuff there later
mkdir -p $WORK/boot/isolinux

#START COPY
	if [ -f antix.iso ];then
		echo "Copying AntiX..."
		mcdmount antix
		cp -r $MNT/antix/mepis $WORK/ #Everything in antiX but the kernel and initrd
		mkdir -p $WORK/boot/antix
		cp $MNT/antix/boot/vmlinuz $WORK/boot/antix/vmlinuz #Kernel
		cp $MNT/antix/boot/initrd.gz $WORK/boot/antix/initrd.gz #Initrd
		umcdmount antix
	fi
	if [ -f arch.iso ];then
		echo "Copying Arch Linux..."
		mcdmount arch
		mkdir $WORK/boot/arch
		cp $MNT/arch/boot/vmlinuz26 $WORK/boot/arch/vmlinuz26 #Kernel
		cp $MNT/arch/boot/archiso.img $WORK/boot/arch/archiso.img #initrd
		cp $MNT/arch/*.sqfs $WORK/ #Compressed filesystems
		cp $MNT/arch/isomounts $WORK/ #Text file
		umcdmount arch
	fi
	if [ -f archdual.iso ];then
		echo "Copying Arch Linux Dual..."
		mcdmount archdual
		mkdir -p $WORK/boot/arch/i686
		mkdir -p $WORK/boot/arch/x86_64
		mkdir $WORK/i686
		mkdir $WORK/x86_64
		cp $MNT/archdual/boot/i686/vmlinuz26 $WORK/boot/arch/i686/vmlinuz26 #i686 Kernel
		cp $MNT/archdual/boot/x86_64/vmlinuz26 $WORK/boot/arch/x86_64/vmlinuz26 #x86_64 Kernel
		cp $MNT/archdual/boot/i686/archiso.img $WORK/boot/arch/i686/archiso.img #i686 initrd
		cp $MNT/archdual/boot/x86_64/archiso.img $WORK/boot/arch/x86_64/archiso.img #x86_64 initrd
		cp $MNT/archdual/i686/*.sqfs $WORK/i686 #i686 Compressed filesystems
		cp $MNT/archdual/x86_64/*.sqfs $WORK/x86_64 #x86_64 Compressed filesystems
		cp $MNT/archdual/isomounts $WORK/ #Text file
		umcdmount archdual
	fi
	if [ -f archiso-live.iso ];then
		echo "Copying Archiso-live..."
		mcdmount archiso-live
		mkdir $WORK/boot/archiso-live
		cp $MNT/archiso-live/boot/vmlinuz $WORK/boot/archiso-live/vmlinuz
		cp $MNT/archiso-live/boot/initrd.img $WORK/boot/archiso-live/initrd.img
		cp -r $MNT/archiso-live/archiso-live $WORK/ #Compressed filesystems
		umcdmount archiso-live
	fi
	if [ -f austrumi.iso ];then
		mcdmount austrumi
		cp -r $MNT/austrumi/austrumi $WORK/ #This folder also has the kernel and initrd
		cp $MNT/austrumi/isolinux.cfg $WORK/boot/isolinux/al.menu
		umcdmount austrumi
	fi
	if [ -f avg.iso ];then
		echo "Copying AVG Rescue CD..."
		mcdmount avg
		mkdir $WORK/boot/avg
		cp $MNT/avg/isolinux/vmlinuz $WORK/boot/avg/
		cp $MNT/avg/isolinux/initrd.lzm $WORK/boot/avg/
		cp $MNT/avg/CHANGELOG $WORK/boot/avg/
		cp $MNT/avg/arl-version $WORK/
		umcdmount avg
	fi
	if [ -f backtrack.iso ];then
		echo "Copying BackTrack..."
		mcdmount backtrack
		cp -R $MNT/backtrack/casper $WORK/boot/backtrack
		cp $MNT/backtrack/boot/vmlinuz $WORK/boot/backtrack/
		cp $MNT/backtrack/boot/initrd* $WORK/boot/backtrack/
		umcdmount backtrack
		echo -n "Making initrd(s)..." #This initrd code is common to distros using old versions of casper
		for i in initrd.gz initrd800.gz initrdfr.gz;do
			if [ -d $MNT/initrd-tmp-mount ];then rm -r $MNT/initrd-tmp-mount;fi
			mkdir $MNT/initrd-tmp-mount
			cd $MNT/initrd-tmp-mount
			gzip -cd $WORK/boot/backtrack/$i | cpio -id
			perl -pi -e 's/path\/casper/path\/boot\/backtrack/g' scripts/casper
			perl -pi -e 's/directory\/casper/directory\/boot\/backtrack/g' scripts/casper
			find . | cpio --create --format='newc' | gzip -c > $WORK/boot/backtrack/$i
			cd -
			rm -r $MNT/initrd-tmp-mount
		done
		echo " done."
	fi
	if [ -f caine.iso ];then
		echo "Copying Caine..."
		mcdmount caine
		cp -R $MNT/caine/casper $WORK/boot/caine #Live system
		cp $MNT/caine/README.diskdefines multicd-working/
		mkdir $WORK/CaineFiles
		cp -R $MNT/caine/{AutoPlay,autorun.exe,autorun.inf,comdlg32.ocx,files,license.txt,page5,preseed,Programs,RegOcx4Vista.bat,rw_common,tabctl32.ocx,vbrun60.exe,WinTaylor.exe} $WORK/CaineFiles
		umcdmount caine
		echo -n "Making initrd(s)..."
		if [ -d $MNT/caine-inittmp ];then rm -r $MNT/caine-inittmp;fi
		mkdir $MNT/caine-inittmp
		cd $MNT/caine-inittmp
		gzip -cd $WORK/boot/caine/initrd.gz | cpio -id
		perl -pi -e 's/path\/casper/path\/boot\/caine/g' scripts/casper
		perl -pi -e 's/directory\/casper/directory\/boot\/caine/g' scripts/casper
		find . | cpio --create --format='newc' | gzip -c > $WORK/boot/caine/initrd.gz
		cd -
		rm -r $MNT/caine-inittmp
		echo " done."
	fi
	if [ -f cdl.iso ];then
		echo "Copying CDlinux..."
		mcdmount cdl
		cp -r $MNT/cdl/CDlinux $WORK/CDlinux #Everything in one folder
		rm $WORK/CDlinux/boot/memtest.bin.gz #Remove redundant memtest
		umcdmount cdl
	fi
	if [ -f clonezilla.iso ];then
		echo "Copying Clonezilla..."
		mcdmount clonezilla
		cp $MNT/clonezilla/isolinux/ocswp.png $WORK/boot/isolinux/ocswp.png #Boot menu logo
		cp -R $MNT/clonezilla/live $WORK/boot/clonezilla #Another Debian Live-based ISO
		sed '/MENU BEGIN Memtest/,/MENU END/d' $MNT/clonezilla/isolinux/isolinux.cfg > $WORK/boot/isolinux/clonezil.cfg #Remove FreeDOS and Memtest
		umcdmount clonezilla
		rm $WORK/boot/clonezilla/memtest
	fi
	if [ -f dban.iso ];then
		echo "Copying DBAN..."
		mcdmount dban
		mkdir -p $WORK/boot/dban1
		cp $MNT/dban/dban.bzi $WORK/boot/dban1/dban.bzi
		umcdmount dban
	fi
	if [ -f debian-install.iso ];then
		echo "Copying Debian installer..."
		mcdmount debian-install
		cp -r $MNT/debian-install/.disk $WORK
		cp -r $MNT/debian-install/dists $WORK
		cp -r $MNT/debian-install/install.386 $WORK
		cp -r $MNT/debian-install/pool $WORK
		cp $MNT/debian-install/dedication.txt $WORK || true
		umcdmount debian-install
	fi
	if [ -f binary.iso ];then
		echo "Copying Debian Live..."
		mcdmount binary
		cp $MNT/binary/isolinux/live.cfg $WORK/boot/isolinux/dlive.cfg
		cp -r $MNT/binary/live $WORK/ #Copy live folder - usually all that is needed
		if [ -d dlive/install ];then
			cp -r $MNT/binary/install $WORK/ #Doesn't hurt to check
		fi
		umcdmount binary
		rm $WORK/live/memtest||true
	fi
	if [ -f debian-mini.iso ];then
		echo "Copying Debian netboot installer..."
		mcdmount debian-mini
		mkdir $WORK/boot/debian
		cp $MNT/debian-mini/linux $WORK/boot/debian/linux
		cp $MNT/debian-mini/initrd.gz $WORK/boot/debian/initrd.gz
		umcdmount debian-mini
	fi
	if [ -f deli.iso ];then
		echo "Copying DeLi Linux..."
		mcdmount deli
		cp -r $MNT/deli/isolinux $WORK/ #Kernel and filesystem
		cp -r $MNT/deli/pkg $WORK/ #Packages
		umcdmount deli
	fi
	if [ -f diskcopy.iso ];then
		echo "Copying EASUS Disk Copy..."
		mcdmount diskcopy
		mkdir -p $WORK/boot/diskcopy
		cp $MNT/diskcopy/bzImage $WORK/boot/diskcopy/bzImage
		cp $MNT/diskcopy/initrd.img $WORK/boot/diskcopy/initrd.img
		umcdmount diskcopy
	fi
	if [ -f dsl.iso ];then
		echo "Copying Damn Small Linux..."
		mcdmount dsl
		mkdir $WORK/KNOPPIX
		cp -r $MNT/dsl/KNOPPIX/* $WORK/KNOPPIX/ #Compressed filesystem. We put it here so DSL's installer can find it.
		cp $MNT/dsl/boot/isolinux/linux24 $WORK/boot/isolinux/linux24 #Kernel. See above.
		cp $MNT/dsl/boot/isolinux/minirt24.gz $WORK/boot/isolinux/minirt24.gz #Initial ramdisk. See above.
		umcdmount dsl
	fi
	if [ -f dvl.iso ];then
		echo "Copying Damn Vulnerable Linux..."
		mcdmount dvl
		cp -r $MNT/dvl/BT $WORK/
		mkdir $WORK/boot/dvl
		cp $MNT/dvl/boot/vmlinuz $WORK/boot/dvl/vmlinuz
		cp $MNT/boot/initrd.gz $WORK/boot/dvl/initrd.gz
		umcdmount dvl
	fi
	if [ -f efw.iso ];then
		echo "Copying Endian Firewall..."
		mcdmount efw
		mkdir -p $WORK/boot/endian/
		cp $MNT/efw/boot/isolinux/vmlinuz $WORK/boot/endian/ #Kernel
		cp $MNT/efw/boot/isolinux/instroot.gz $WORK/boot/endian/ #Filesystem
		cp -r $MNT/efw/data $WORK/ #data and rpms folders are located
		cp -r $MNT/efw/rpms $WORK/ #at the root of the original CD
		cp $MNT/efw/LICENSE.txt $WORK/EFW-LICENSE.txt #License terms
		cp $MNT/efw/README.txt $WORK/EFW-README.txt
		umcdmount efw
	fi
	if [ -f elastix.iso ];then
		echo "Copying Elastix..."
		mcdmount elastix
		cp -r $MNT/elastix/isolinux $WORK/boot/elastix
		cp -r $MNT/elastix/Elastix $WORK/
		if [ -d $WORK/images ];then
			echo "There is already a folder called \"images\". Are you adding another Red Hat-based distro?"
			echo "Copying anyway - be warned that on the final CD, something might not work properly."
		fi
		cp -r $MNT/elastix/images $WORK/
		cp -r $MNT/elastix/repodata $WORK/
		cp $MNT/elastix/.discinfo $WORK/
		cp $MNT/elastix/* $WORK/ 2>/dev/null || true
		umcdmount elastix
	fi
	if [ -f feather.iso ];then
		echo "Copying Feather..."
		mcdmount feather
		mkdir multicd-working/FEATHER
		cp -R $MNT/feather/KNOPPIX/* multicd-working/FEATHER/ #Compressed filesystem
		mkdir multicd-working/boot/feather
		cp $MNT/feather/boot/isolinux/linux24 multicd-working/boot/feather/linux24
		cp $MNT/feather/boot/isolinux/minirt24.gz multicd-working/boot/feather/minirt24.gz
		umcdmount feather
	fi
	if [ -f fedora-boot.iso ];then
		echo "Copying Fedora netboot installer..."
		mcdmount fedora-boot
		mkdir multicd-working/boot/fedora
		cp $MNT/fedora-boot/isolinux/vmlinuz multicd-working/boot/fedora/vmlinuz
		cp $MNT/fedora-boot/isolinux/initrd.img multicd-working/boot/fedora/initrd.img
		if [ -d multicd-working/images ];then
			echo "There is already an \"images\" folder on the multicd. You might have another Red Hat-based distro on it."
			echo "Fedora's \"images\" folder won't be copied; instead, these files will be downloaded before the installer starts."
		else
			#Commenting out the below line will save about 100MB on the CD, but it will have to be downloaded when you install Fedora
			cp -R $MNT/fedora-boot/images multicd-working/
		fi
		umcdmount fedora-boot
	fi
	if [ -f fedora-boot64.iso ];then
		echo "Copying Fedora 64-bit netboot installer..."
		mcdmount fedora-boot64
		mkdir multicd-working/boot/fedora64
		cp $MNT/fedora-boot64/isolinux/vmlinuz multicd-working/boot/fedora64/vmlinuz
		cp $MNT/fedora-boot64/isolinux/initrd.img multicd-working/boot/fedora64/initrd.img
		if [ -d multicd-working/images ];then
			echo "There is already an \"images\" folder on the multicd. You might have another Red Hat-based distro on it."
			echo "64-bit Fedora's \"images\" folder won't be copied; instead, these files will be downloaded before the installer starts."
		else
			#Commenting out the below line will save about 100MB on the CD, but it will have to be downloaded when you install Fedora
			cp -R $MNT/fedora-boot64/images multicd-working/
		fi
		umcdmount fedora-boot64
	fi
	if [ -f finnix.iso ];then
		echo "Copying Finnix..."
		mcdmount finnix
		# Copies compressed filesystem
		cp -r $MNT/finnix/FINNIX multicd-working/
		# Copies kernel, and initramdisk
		mkdir multicd-working/boot/finnix
		cp $MNT/finnix/isolinux/linux multicd-working/boot/finnix/
		cp $MNT/finnix/isolinux/linux64 multicd-working/boot/finnix/
		cp $MNT/finnix/isolinux/minirt multicd-working/boot/finnix/
		# Copies memdisk and Smart Boot Manager
		cp $MNT/finnix/isolinux/memdisk multicd-working/boot/finnix/
		cp $MNT/finnix/isolinux/sbm.imz multicd-working/boot/finnix/
		umcdmount finnix
	fi
	if [ -f fdfullcd.iso ] || [ -f fdbasecd.iso ];then
		echo "Copying FreeDOS..."
		if [ ! -d $MNT/freedos ];then
			mkdir $MNT/freedos
		fi
		if grep -q "$MNT/freedos" /etc/mtab ; then
			umount $MNT/freedos
		fi
		if [ -f fdfullcd.iso ];then
			mount -o loop fdfullcd.iso $MNT/freedos/ #It might be fdbasecd or fdfullcd
		else
			mount -o loop fdbasecd.iso $MNT/freedos/
		fi
		mkdir multicd-working/boot/freedos
		cp -r $MNT/freedos/freedos multicd-working/ #Core directory with the packages
		cp $MNT/freedos/setup.bat multicd-working/setup.bat #FreeDOS setup
		cp $MNT/freedos/isolinux/data/fdboot.img multicd-working/boot/freedos/fdboot.img #Initial DOS boot image
		if [ -d $MNT/freedos/fdos ];then
			cp -r $MNT/freedos/fdos multicd-working/ #Live CD
		fi
		if [ -d $MNT/freedos/gemapps ];then
			cp -r $MNT/freedos/gemapps multicd-working/ #OpenGEM
		fi
		if [ -f $MNT/freedos/gem.bat ];then
			cp -r $MNT/freedos/gem.bat multicd-working/ #OpenGEM setup
		fi
		umcdmount freedos
	fi
	if [ -f geexbox.iso ];then
		echo "Copying GeeXboX..."
		mcdmount geexbgox
		cp -r $MNT/geexbox/GEEXBOX multicd-working/ #Everything GeeXbox has is in one folder. :)
		umcdmount geexbox
	fi
	if [ -f gparted.iso ];then
		echo "Copying GParted Live..."
		mcdmount gparted
		cp -R $MNT/gparted/live $WORK/boot/gparted #Compressed filesystem and kernel/initrd
		rm $WORK/boot/gparted/memtest || true #Remember how we needed to do this with Debian Live? They use the same framework
		umcdmount gparted
	fi
	if [ -f hirens.iso ];then
		echo "Copying Hiren's BootCD..."
		mcdmount hirens
		if [ -f hirens/BootCD.txt ];then
			head -n 1 $MNT/hirens/BootCD.txt |sed -e 's/\t//g'>$TAGS/hirens.name
		else
			echo "Warning: No BootCD.txt in hirens.iso" 1>&2
			echo "Hiren's BootCD" > $TAGS/hirens.name
		fi
		cp -r $MNT/hirens/HBCD multicd-working/
		umcdmount hirens
	fi
	if [ -f insert.iso ];then
		echo "Copying INSERT..."
		mcdmount insert
		cp -R $MNT/insert/INSERT multicd-working/ #Compressed filesystem
		mkdir multicd-working/boot/insert
		cp $MNT/insert/isolinux/vmlinuz multicd-working/boot/insert/vmlinuz
		cp $MNT/insert/isolinux/miniroot.lz multicd-working/boot/insert/miniroot.lz
		umcdmount insert
	fi
	if [ -f ipcop.iso ];then
		echo "Copying IPCop..."
		mcdmount ipcop
		cp -r $MNT/ipcop/boot/isolinux multicd-working/boot/ipcop
		if [ -d multicd-working/images ];then
			echo "There is already a folder called \"images\". Are you adding another Red Hat-based distro?"
			echo "Copying anyway - be warned that on the final CD, something might not work properly."
		fi
		cp -r $MNT/ipcop/images multicd-working/
		cp $MNT/ipcop/*.tgz multicd-working
		cp -r $MNT/ipcop/doc multicd-working/boot/ipcop/ || true
		cp $MNT/ipcop/*.txt multicd-working/boot/ipcop/ || true
		umcdmount ipcop
	fi
	if [ -f knoppix.iso ];then
		echo "Copying Knoppix..."
		mcdmount knoppix
		mkdir multicd-working/KNOPPIX6
		#Compressed filesystem and docs. We have to call it KNOPPIX6 because DSL uses KNOPPIX, and if we change that DSL's installer won't work.
		for i in $(ls $MNT/knoppix/KNOPPIX*|grep -v '^KNOPPIX2$');do
			cp -r $MNT/knoppix/KNOPPIX/$i multicd-working/KNOPPIX6/
		done
		mkdir -p multicd-working/boot/knoppix
		cp $MNT/knoppix/boot/isolinux/linux multicd-working/boot/knoppix/linux
		cp $MNT/knoppix/boot/isolinux/minirt.gz multicd-working/boot/knoppix/minirt.gz
		umcdmount knoppix
	fi
	if [ -f linuxmint.iso ];then
		echo "Copying Linux Mint..."
		ubuntucommon linuxmint
	fi
	if [ -f macpup.iso ];then
		echo "Copying Macpup..."
		puppycommon macpup
	fi
	if [ -f mandriva-boot.iso ];then
		echo "Copying Mandriva netboot installer..."
		if [ ! -d mandriva-boot ];then
			mkdir mandriva-boot
		fi
		if grep -q "`pwd`/mandriva-boot" /etc/mtab ; then
			umount mandriva-boot
		fi
		mount -o loop mandriva-boot.iso mandriva-boot/
		mkdir multicd-working/boot/mandriva
		cp -r mandriva-boot/isolinux/alt0 multicd-working/boot/mandriva/
		cp -r mandriva-boot/isolinux/alt1 multicd-working/boot/mandriva/
		umount mandriva-boot
		rmdir mandriva-boot
	fi
	if [ -f mintdebian.iso ];then
		echo "Copying Linux Mint Debian Edition..."
		ubuntucommon mintdebian
	fi
	if [ -f netbootcd.iso ];then
		echo "Copying NetbootCD..."
		mcdmount netbootcd
		mkdir -p multicd-working/boot/nbcd
		cp $MNT/netbootcd/isolinux/kexec.bzI multicd-working/boot/nbcd/kexec.bzI
		cp $MNT/netbootcd/isolinux/* multicd-working/boot/nbcd/
		sleep 1;umcdmount netbootcd
	fi
	if [ -f ntpasswd.iso ];then
		mcdmount ntpasswd
		mkdir $WORK/boot/ntpasswd
		cp $MNT/ntpasswd/vmlinuz $WORK/boot/ntpasswd/vmlinuz
		cp $MNT/ntpasswd/initrd.cgz $WORK/boot/ntpasswd/initrd.cgz
		cp $MNT/ntpasswd/scsi.cgz $WORK/boot/ntpasswd/scsi.cgz #Alternate initrd
		umcdmount ntpasswd
	fi
	if [ -f opensuse-gnome.iso ];then
		echo "Copying openSUSE GNOME Live CD..."
		mcdmount opensuse-gnome
		mkdir -p $WORK/boot/opensuse-gnome
		cp $MNT/opensuse-gnome/openSUSE* $WORK/
		cp $MNT/opensuse-gnome/config.isoclient $WORK/
		mkdir $WORK/boot/susegnom
		cp $MNT/opensuse-gnome/boot/i386/loader/linux $WORK/boot/susegnom/linux
		cp $MNT/opensuse-gnome/boot/i386/loader/initrd $WORK/boot/susegnom/initrd
		umcdmount opensuse-gnome
	fi
	if [ -f opensuse-net.iso ];then
		echo "Copying openSUSE netboot installer..."
		mcdmount opensuse-net
		mkdir -p $WORK/boot/opensuse
		awk '/^VERSION/ {print $2}' $MNT/opensuse-net/content > $TAGS/opensuse-net.version
		cp $MNT/opensuse-net/boot/i386/loader/linux $WORK/boot/opensuse/linux
		cp $MNT/opensuse-net/boot/i386/loader/initrd $WORK/boot/opensuse/initrd
		umcdmount opensuse-net
	fi
	if [ -f opensuse-net64.iso ];then
		echo "Copying openSUSE 64-bit netboot installer..."
		mcdmount opensuse-net64
		mkdir -p $WORK/boot/opensuse
		awk '/^VERSION/ {print $2}' $MNT/opensuse-net64/content > $TAGS/opensuse-net.version
		cp $MNT/opensuse-net64/boot/x86_64/loader/linux $WORK/boot/opensuse/linux64
		cp $MNT/opensuse-net64/boot/x86_64/loader/initrd $WORK/boot/opensuse/initrd64
		umcdmount opensuse-net64
	fi
	if [ -f ophxp.iso ];then
		echo "Copying OPH Crack XP..."
		if [ ! -d ophxp ];then
			mkdir ophxp
		fi
		if grep -q "`pwd`/ophxp" /etc/mtab ; then
			umount ophxp
		fi
		mount -o loop ophxp.iso ophxp/
		mkdir multicd-working/boot/ophcrack/
		cp -r ophxp/tables multicd-working/tables
		cp ophxp/boot/bzImage multicd-working/boot/ophcrack/bzImage
		cp ophxp/boot/ophcrack.cfg multicd-working/boot/ophcrack/ophcrack.cfg
		cp ophxp/boot/splash.png multicd-working/boot/ophcrack/splash.png
		cp ophxp/boot/rootfs.gz multicd-working/boot/ophcrack/rootfs.gz
		umount ophxp
		rmdir ophxp
	fi
	if [ -f ophvista.iso ] && [ ! -f ophxp.iso ];then
		echo "Copying OPH Crack Vista..."
		if [ ! -d ophvista ];then
			mkdir ophvista
		fi
		if grep -q "`pwd`/ophvista" /etc/mtab ; then
			umount ophvista
		fi
		mount -o loop ophvista.iso ophvista/
		mkdir multicd-working/boot/ophcrack/
		cp -r ophvista/tables multicd-working/tables
		cp ophvista/boot/bzImage multicd-working/boot/ophcrack/bzImage
		cp ophvista/boot/ophcrack.cfg multicd-working/boot/ophcrack/ophcrack.cfg
		cp ophvista/boot/splash.png multicd-working/boot/ophcrack/splash.png
		cp ophvista/boot/rootfs.gz multicd-working/boot/ophcrack/rootfs.gz
		umount ophvista
		rmdir ophvista
	fi
	if [ -f ophvista.iso ] && [ -f ophxp.iso ];then
		echo "Getting OPH Crack Vista tables..."
		if [ ! -d ophvista ];then
			mkdir ophvista
		fi
		if grep -q "`pwd`/ophvista" /etc/mtab ; then
			umount ophvista
		fi
		mount -o loop ophvista.iso ophvista/
		cp -r ophvista/tables multicd-working
		umount ophvista
		rmdir ophvista
	fi
	if [ -f pclos.iso ];then
		echo "Copying PCLinuxOS..."
		mcdmount pclos
		mkdir $WORK/PCLinuxOS
		# Kernel, initrd
		cp -r $MNT/pclos/isolinux $WORK/PCLinuxOS/isolinux
		# Filesystem
		cp $MNT/pclos/livecd.sqfs $WORK/PCLinuxOS/livecd.sqfs
		# Remove memtest and mediacheck
		if [ -f $WORK/PCLinuxOS/isolinux/memtest ];then
			rm $WORK/PCLinuxOS/isolinux/memtest
		fi
		if [ -f $WORK/PCLinuxOS/isolinux/mediacheck ];then
			rm $WORK/PCLinuxOS/isolinux/mediacheck
		fi
		umcdmount pclos
	fi
	if [ -f pclx.iso ];then
		echo "Copying PCLinuxOS LXDE..."
		if [ ! -d pclinuxos ];then
			mkdir pclinuxos
		fi
		if grep -q `pwd`/pclinuxos /etc/mtab ; then
			umount pclinuxos
		fi
		mount -o loop pclx.iso pclinuxos/
		mkdir multicd-working/pclosLXDE
		# Kernel, initrd
		cp -r pclinuxos/isolinux multicd-working/pclosLXDE/isolinux
		# Empty boot folder, don't ask me...
		# cp -r pclinuxos/boot multicd-working/pclosLXDE/boot
		# Filesystem
		cp pclinuxos/livecd.sqfs multicd-working/pclosLXDE/livecd.sqfs
		# Remove memtest and mediacheck
		if [ -f multicd-working/pclosLXDE/isolinux/memtest ];then
			rm multicd-working/pclosLXDE/isolinux/memtest 
		fi
		if [ -f multicd-working/pclosLXDE/isolinux/mediacheck ];then
			rm multicd-working/pclosLXDE/isolinux/mediacheck
		fi
		umount pclinuxos
		rmdir pclinuxos
	fi
	if [ -f ping.iso ];then
		echo "Copying PING..."
		if [ ! -d ping ];then
			mkdir ping
		fi
		if grep -q "`pwd`/ping" /etc/mtab ; then
			umount ping
		fi
		mount -o loop ping.iso ping/
		mkdir -p multicd-working/boot/ping
		cp ping/kernel multicd-working/boot/ping/kernel
		cp ping/initrd.gz multicd-working/boot/ping/initrd.gz
		umount ping
		rmdir ping
	fi
	if [ -f pmagic.iso ];then
	echo "Copying Parted Magic..."
	if [ ! -d pmagic ];then
		mkdir pmagic
	fi
	if grep -q "`pwd`/pmagic" /etc/mtab ; then
		umount pmagic
	fi
	mount -o loop pmagic.iso pmagic/
	#Sudo is needed b/c of weird permissions on 4.7 ISO for the initrd
	sudo cp -r pmagic/pmagic multicd-working/ #Compressed filesystem and kernel/initrd
	umount pmagic
	rmdir pmagic
	fi
	if [ -f puppy.iso ];then
		echo "Copying Puppy..."
		puppycommon puppy
	fi
	if [ -f puppy2.iso ];then
		echo "Copying Puppy #2..."
		puppycommon puppy2
	fi
	if [ -f riplinux.iso ];then
		if [ ! -d riplinux ];then
echo "Copying RIP Linux..."
			mkdir riplinux
		fi
		if grep -q "`pwd`/riplinux" /etc/mtab ; then
			umount riplinux
		fi
		mount -o loop riplinux.iso riplinux/
		mkdir -p multicd-working/boot/riplinux
		cp -r riplinux/boot/doc multicd-working/boot/ #Documentation
		cp -r riplinux/boot/grub4dos multicd-working/boot/riplinux/ #GRUB4DOS :)
		cp riplinux/boot/kernel32 multicd-working/boot/riplinux/kernel32 #32-bit kernel
		cp riplinux/boot/kernel64 multicd-working/boot/riplinux/kernel64 #64-bit kernel
		cp riplinux/boot/rootfs.cgz multicd-working/boot/riplinux/rootfs.cgz #Initrd
		perl -pi -e 's/\/boot\/kernel/\/boot\/riplinux\/kernel/g' multicd-working/boot/riplinux/grub4dos/menu-cd.lst #Fix the menu.lst
		perl -pi -e 's/\/boot\/rootfs.cgz/\/boot\/riplinux\/rootfs.cgz/g' multicd-working/boot/riplinux/grub4dos/menu-cd.lst #Fix it some more
		umount riplinux
		rmdir riplinux
	fi
	if [ -f slax.iso ];then
		echo "Copying Slax..."
		mcdmount slax
		if [ -f $TAGS/slaxlist ];then
			mkdir $WORK/$MNT/slax
			for i in `ls $MNT/slax/slax|sed -e '/^base$/ d'`;do
				cp -R $MNT/slax/slax/$i $WORK/slax/ #Copy everything but the base modules
			done
			mkdir $WORK/slax/base
			for i in `cat $TAGS/slaxlist`;do
				cp $MNT/slax/slax/base/${i}* $WORK/slax/base/ #Copy only the modules you wanted
			done
			cp $MNT/slax/slax/base/001-*.lzm $WORK/slax/base/ #Don't forget the core module!
			rm $TAGS/slaxlist
		else
			cp -R $MNT/slax/slax $WORK/ #Copy everything
		fi
		mkdir -p $WORK/boot/slax
		cp $MNT/slax/boot/vmlinuz $WORK/boot/slax/vmlinuz
		if [ -f $MNT/slax/boot/initrd.lz ];then
			SUFFIX=lz
		else
			SUFFIX=gz
		fi
		cp $MNT/slax/boot/initrd.$SUFFIX $WORK/boot/slax/initrd.$SUFFIX
		umcdmount slax
		##########
		if [ "`ls -1 *.lzm 2> /dev/null;true`" != "" ];then
			echo "Copying Slax modules..."
		fi
		for i in `ls -1 *.lzm 2> /dev/null;true`; do
			cp $i $WORK/slax/modules/ #Copy the .lzm module to the modules folder
			if $VERBOSE;then
				echo \(Copied $i\)
			fi
		done
	fi
	if [ -f slitaz.iso ];then
		echo "Copying SliTaz..."
		if [ ! -d slitaz ];then
			mkdir slitaz
		fi
		if grep -q "`pwd`/slitaz" /etc/mtab ; then
			umount slitaz
		fi
		mount -o loop slitaz.iso slitaz/
		mkdir -p multicd-working/boot/slitaz
		cp slitaz/boot/bzImage multicd-working/boot/slitaz/bzImage #Kernel
		cp slitaz/boot/rootfs.gz multicd-working/boot/slitaz/rootfs.gz #Root filesystem
		umount slitaz
		rmdir slitaz
	fi
	if [ -f sysrcd.iso ];then
		echo "Copying SystemRescueCd..."
		mcdmount sysrcd
		mkdir multicd-working/boot/sysrcd
		cp $MNT/sysrcd/sysrcd.* multicd-working/boot/sysrcd/ #Compressed filesystem
		cp $MNT/sysrcd/isolinux/altker* multicd-working/boot/sysrcd/ #Kernels
		cp $MNT/sysrcd/isolinux/rescue* multicd-working/boot/sysrcd/ #Kernels
		cp $MNT/sysrcd/isolinux/initram.igz multicd-working/boot/sysrcd/initram.igz #Initrd
		cp $MNT/sysrcd/version multicd-working/boot/sysrcd/version
		umcdmount sysrcd
	fi
	if [ -f tcnet.iso ];then
		echo "Copying TCNet..."
		if [ ! -d tcnet ];then
			mkdir tcnet
		fi
		if grep -q "`pwd`/tcnet" /etc/mtab ; then
			umount tcnet
		fi
		mount -o loop tcnet.iso tcnet/
		mkdir multicd-working/boot/tcnet
		cp tcnet/boot/bzImage multicd-working/boot/tcnet/bzImage #Linux kernel
		cp tcnet/boot/tcnet.gz multicd-working/boot/tcnet/tcnet.gz #TCNet image w/o apps - must load them from TCEs
		cp tcnet/boot/tcntfull.gz multicd-working/boot/tcnet/tcntfull.gz #TCNet image w/o apps - must have 192 MB RAM or more
		umount tcnet
		rmdir tcnet
	fi
	if [ -f tinycore.iso ];then
		echo "Copying Tiny Core..."
		tinycorecommon tinycore
	fi
	if [ -f tinycore2.iso ];then
		echo "Copying Tiny Core..."
		tinycorecommon tinycore2
	fi
	if [ -f tinyme.iso ];then
		echo "Copying TinyMe..."
		if [ ! -d tinyme ];then
			mkdir tinyme
		fi
		if grep -q "`pwd`/tinyme" /etc/mtab ; then
			umount tinyme
		fi
		mount -o loop tinyme.iso tinyme/
		cp tinyme/livecd.sqfs multicd-working/livecd.sqfs #Compressed filesystem
		mkdir -p multicd-working/boot/tinyme
		cp tinyme/isolinux/vmlinuz multicd-working/boot/tinyme/vmlinuz
		cp tinyme/isolinux/initrd.gz multicd-working/boot/tinyme/initrd.gz
		umount tinyme
		rmdir tinyme
	fi
	if [ -f trk.iso ];then
		echo "Copying Trinity Rescue Kit..."
		mcdmount trk
		cp -r $MNT/trk/trk3 $WORK/ #TRK files
		mkdir $WORK/boot/trinity
		cp $MNT/trk/isolinux.cfg $WORK/boot/isolinux/trk.menu
		cp $MNT/trk/kernel.trk $WORK/boot/trinity/kernel.trk
		cp $MNT/trk/initrd.trk $WORK/boot/trinity/initrd.trk
		cp $MNT/trk/bootlogo.jpg $WORK/boot/isolinux/trklogo.jpg #Boot logo
		umcdmount trk
	fi
	set -e
	if [ -f ubcd.iso ];then
		echo "Copying Ultimate Boot CD..."
		if [ ! -d ubcd ];then
			mkdir ubcd
		fi
		if grep -q "`pwd`/ubcd" /etc/mtab ; then
			umount ubcd
		fi
		mount -o loop ubcd.iso ubcd/
		cp -r ubcd/ubcd multicd-working/
		cp -r ubcd/pmagic multicd-working/
		cp -r ubcd/antivir multicd-working/
		cp ubcd/license.txt multicd-working/ubcd-license.txt
		cp ubcd/boot/syslinux/econfig.c32 multicd-working/boot/isolinux/
		cp ubcd/boot/syslinux/reboot.c32 multicd-working/boot/isolinux/
		for i in multicd-working/ubcd/menus/*/*.cfg multicd-working/ubcd/menus/*/*/*.cfg multicd-working/pmagic/boot/*/*.cfg;do
			perl -pi -e 's/\/boot\/syslinux/\/boot\/isolinux/g' $i
		done
		head -n 1 ubcd/ubcd/menus/syslinux/defaults.cfg | awk '{ print $6 }'>ubcdver.tmp.txt
		#echo "$VERSION" > multicd-working/boot/ubcd/version
		umount ubcd
		rmdir ubcd
	fi
	if [ -f ubuntu-mini.iso ];then
		echo "Copying Ubuntu netboot installer..."
		if [ ! -d ubuntu-mini ];then
			mkdir ubuntu-mini
		fi
		if grep -q "`pwd`/ubuntu-mini" /etc/mtab ; then
			umount ubuntu-mini
		fi
		mount -o loop ubuntu-mini.iso ubuntu-mini/
		mkdir multicd-working/boot/ubuntu
		cp ubuntu-mini/linux multicd-working/boot/ubuntu/linux
		cp ubuntu-mini/initrd.gz multicd-working/boot/ubuntu/initrd.gz
		umount ubuntu-mini
		rmdir ubuntu-mini
	fi
	if [ "*.ubuntu.iso" != "$(echo *.ubuntu.iso)" ];then for i in *.ubuntu.iso; do
		BASENAME=$(echo $i|sed -e 's/\.iso//g')
		if [ -f $TAGS/$BASENAME.name ] && [ "$(cat $TAGS/$BASENAME.name)" != "" ];then #Check for a custom name that is not empty (it could be the default name from the "links" section of this plugin"
			UBUNAME="$(cat $TAGS/$BASENAME.name)"
		else
			UBUNAME=$(echo $i|sed -e 's/\.ubuntu\.iso//g') #No custom name found
		fi
		echo "Copying $UBUNAME..."
		ubuntucommon $(echo $i|sed -e 's/\.iso//g')
	done;fi
	if [ -f vyatta.iso ];then
		echo "Copying Vyatta..."
		if [ ! -d vyatta ];then
			mkdir vyatta
		fi
		if grep -q "`pwd`/vyatta" /etc/mtab ; then
			umount vyatta
		fi
		mount -o loop vyatta.iso vyatta/
		cp -r vyatta/live multicd-working/Vyatta #Pretty much everything except documentation/help
		umount vyatta
		rmdir vyatta
	fi
	if [ -f weaknet.iso ];then
		echo "Copying WeakNet Linux..."
		if [ ! -d weaknet ];then
			mkdir weaknet
		fi
		if grep -q "`pwd`/weaknet" /etc/mtab ; then
			umount weaknet
		fi
		mount -o loop weaknet.iso weaknet/
		mkdir multicd-working/boot/weaknet
		cp -R weaknet/casper/* multicd-working/boot/weaknet/
		echo -n "Making initrd..."
		mkdir weaknet-inittmp
		cd weaknet-inittmp
		gzip -cd ../multicd-working/boot/weaknet/initrd.gz|cpio -id
		perl -pi -e 's/path\/casper/path\/boot\/weaknet/g' scripts/casper
		perl -pi -e 's/directory\/casper/directory\/boot\/weaknet/g' scripts/casper
		find . | cpio --create --format='newc' | gzip -c > ../multicd-working/boot/weaknet/initrd.gz
		cd ..
		echo " done."
		rm -r weaknet-inittmp
		umount weaknet
		rmdir weaknet
	fi
	if [ -f win7recovery.iso ];then
		echo "Copying Windows 7 Recovery Disc..."
		if [ ! -d win7recovery ];then
			mkdir win7recovery
		fi
		if grep -q "`pwd`/win7recovery" /etc/mtab ; then
			umount win7recovery
		fi
		mount -o loop win7recovery.iso win7recovery/
		cp win7recovery/boot/* multicd-working/boot/
		cp -r win7recovery/sources multicd-working/
		cp win7recovery/bootmgr multicd-working/
		umount win7recovery;rmdir win7recovery
	fi
	if [ -f win98se.iso ];then
		echo "Copying Windows 98 SE..."
		if [ ! -d win98se ];then
			mkdir win98se
		fi
		if grep -q "`pwd`/win98se" /etc/mtab ; then
			umount win98se
		fi
		mount -o loop win98se.iso win98se/
		cp -r win98se/win98 multicd-working/
		rm -r multicd-working/win98/ols
		if [ -f $TAGS/9xextras ];then
			cp -r win98se/add-ons multicd-working/win98/add-ons
			cp -r win98se/tools multicd-working/win98/tools
		fi
		umount win98se;rmdir win98se
		dd if=win98se.iso bs=43008 skip=1 count=35 of=/tmp/dat
		dd if=/tmp/dat bs=1474560 count=1 of=multicd-working/boot/win98se.img
		rm /tmp/dat
		if which mdel > /dev/null;then
			mdel -i multicd-working/boot/win98se.img ::JO.SYS #Disable HD/CD boot prompt - not needed, but a nice idea
		fi
	fi
	if [ -f winme.iso ];then
		echo "Copying Windows Me..."
		if [ ! -d winme ];then
			mkdir winme
		fi
		if grep -q "`pwd`/winme" /etc/mtab ; then
			umount winme
		fi
		mount -o loop winme.iso winme/
		cp -r winme/win9x multicd-working/
		rm -r multicd-working/win9x/ols
		if [ -f $TAGS/9xextras ];then
			cp -r winme/add-ons multicd-working/win9x/add-ons
			cp -r winme/tools multicd-working/win9x/tools
		fi
		umount winme;rmdir winme
		dd if=winme.iso bs=716800 skip=1 count=3 of=/tmp/dat
		dd if=/tmp/dat bs=1474560 count=1 of=multicd-working/boot/winme.img
		rm /tmp/dat
	fi
	if [ -f wolvix.iso ];then
		echo "Copying Wolvix..."
		if [ ! -d wolvix ];then
			mkdir wolvix
		fi
		if grep -q "`pwd`/wolvix" /etc/mtab ; then
			umount wolvix
		fi
		mount -o loop wolvix.iso wolvix/
		cp -r wolvix/wolvix multicd-working/ #The Wolvix folder with all its files
		mkdir -p multicd-working/boot/wolvix
		#The kernel/initrd must be here for the installer
		cp wolvix/boot/vmlinuz multicd-working/boot/vmlinuz
		cp wolvix/boot/initrd.gz multicd-working/boot/initrd.gz
		umount wolvix
		rmdir wolvix
	fi
#END COPY

#The below chunk copies floppy images.
j="0"
for i in *.im[agz]; do
	test -r "$i" || continue
	cp "$i" $WORK/boot/$j.img
	echo -n Copying $(echo $i|sed 's/\.im.//')"... "
	if $VERBOSE;then
		echo "Saved as "$j".img."
	else
		echo
	fi
	j=$( expr $j + 1 )
done

#This chunk copies floppy images in the "games" folder. They will have their own submenu.
if [ $GAMES = 1 ];then
	k="0"
	mkdir -p $WORK/boot/games
	for i in games/*.im[agz]; do
		test -r "$i" || continue
		echo -n Copying $(echo $i|sed 's/\.im.//'|sed 's/games\///')"... "
		cp "$i" $WORK/boot/games/$k.img
		if $VERBOSE;then
			echo "Saved as games/"$k".img."
		else
			echo
		fi
		k=$( expr $k + 1 )
	done
fi

if [ -f grub.exe ];then
 echo "Copying GRUB4DOS..."
 cp grub.exe $WORK/boot/grub.exe
fi

echo "Downloading SYSLINUX..." #Option 1 is to use an already present syslinux.tar.gz
if [ ! -f syslinux.tar.gz ] && [ -d /usr/lib/syslinux ];then #Option 2: Use installed syslinux
	#This will only be run if there is no syslinux.tar.gz file in the current dir.
	cp /usr/lib/syslinux/isolinux.bin $WORK/boot/isolinux/
	cp /usr/lib/syslinux/memdisk $WORK/boot/isolinux/
	cp /usr/lib/syslinux/menu.c32 $WORK/boot/isolinux/
	cp /usr/lib/syslinux/vesamenu.c32 $WORK/boot/isolinux/
	cp /usr/lib/syslinux/chain.c32 $WORK/boot/isolinux/
else
	if [ ! -f syslinux.tar.gz ];then #Option 3: Get syslinux.tar.gz and save it here
		if $VERBOSE ;then #These will only be run if there is no syslinux.tar.gz AND if syslinux is not installed on your PC
			#Both of these need to be changed when a new version of syslinux comes out.
			wget -O syslinux.tar.gz ftp://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.03.tar.gz
		else
			wget -qO syslinux.tar.gz ftp://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.03.tar.gz
		fi
	fi
	echo "Unpacking and copying files..."
	tar -C /tmp -xzf syslinux.tar.gz
	cp /tmp/syslinux-*/core/isolinux.bin $WORK/boot/isolinux/
	cp /tmp/syslinux-*/memdisk/memdisk $WORK/boot/isolinux/
	cp /tmp/syslinux-*/com32/menu/menu.c32 $WORK/boot/isolinux/
	cp /tmp/syslinux-*/com32/menu/vesamenu.c32 $WORK/boot/isolinux/
	cp /tmp/syslinux-*/com32/modules/chain.c32 $WORK/boot/isolinux/
	cp /tmp/syslinux-*/utils/isohybrid ./isohybrid
	chmod +x ./isohybrid
	rm -r /tmp/syslinux-*/
fi

if $MEMTEST;then
	if [ -f memtest ];then
		cp memtest $WORK/boot/memtest
	elif [ -f /boot/memtest86+.bin ];then
		cp /boot/memtest86+.bin $WORK/boot/memtest
	else
		echo "Downloading memtest86+ 4.10 from memtest.org..."
		if $VERBOSE;then
			wget -O- http://memtest.org/download/4.10/memtest86+-4.10.bin.gz|gzip -cd>memtest
		else
			wget -qO- http://memtest.org/download/4.10/memtest86+-4.10.bin.gz|gzip -cd>memtest
		fi
		cp memtest $WORK/boot/memtest
	fi
fi

echo "Writing isolinux.cfg..."

##BEGIN ISOLINUX MENU CODE##
#The ISOLINUX menu can be rearranged by renaming your plugin scripts - they are processed in alphabetical order.

#BEGIN HEADER#
#Don't move this part. You can change the timeout and menu title, however.
echo "DEFAULT menu.c32
TIMEOUT 0
PROMPT 0
menu title $CDTITLE" > $WORK/boot/isolinux/isolinux.cfg
#END HEADER#

#BEGIN COLOR CODE#
	if [ $MENUCOLOR = 40 ];then
		BORDERCOLOR=37
	else
		BORDERCOLOR=30
	fi
	echo "	menu color screen 37;40
	menu color border 30;44
	menu color title 1;36;44
	menu color unsel 37;44
	menu color hotkey 1;37;44
	menu color sel 7;37;40
	menu color hotsel 1;7;37;40
	menu color disabled 1;30;44
	menu color scrollbar 30;44
	menu color tabmsg 31;40
	menu color cmdmark 1;36;40
	menu color cmdline 37;40
	menu color pwdborder 30;47
	menu color pwdheader 31;47
	menu color pwdentry 30;47
	menu color timeout_msg 37;40
	menu color timeout 1;37;40
	menu color help 37;40
	menu color msg07 37;40"|sed -e "s/30/$BORDERCOLOR/g" -e "s/44/$MENUCOLOR/g">>$WORK/boot/isolinux/isolinux.cfg
#END COLOR CODE#

#BEGIN HD BOOT OPTION#
#If this bugs you, get rid of it.
echo "label local
menu label Boot from ^hard drive
kernel chain.c32
append hd0" >> $WORK/boot/isolinux/isolinux.cfg
#END HD BOOT OPTION#
#START WRITE
if [ -f antix.iso ];then
echo "label anitX
menu label ^antiX
com32 menu.c32
append antix.menu" >> $WORK/boot/isolinux/isolinux.cfg
echo "DEFAULT menu.c32
TIMEOUT 0
PROMPT 0
menu title AntiX Options

label  antiX-Default
menu label ^antiX-Default
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init quiet nosplash vga=791 aufs  initrd=/boot/antix/initrd.gz

label  antiX-Lite-noNet
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init quiet nosplash vga=791 aufs mean lean initrd=/boot/antix/initrd.gz

label  antiX-Vesa
menu label antiX-Vesa (display problem or virtualbox)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=normal quiet nosplash drvr=vesa aufs lean initrd=/boot/antix/initrd.gz

label  antiX-UltraLite-Vesa
menu label antiX-UltraLite-Vesa (Fast boot)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=normal quiet nosplash drvr=vesa aufs lean Xtralean initrd=/boot/antix/initrd.gz

label  antiX-Failsafe
menu label antiX-Failsafe (minimum options, small display)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init quiet nosplash vga=normal nosound noapic noscsi nodma noapm nousb nopcmcia nofirewire noagp nomce nodhcp nodbus nocpufreq nobluetooth drvr=fbdev aufs res=800x600v initrd=/boot/antix/initrd.gz

label  antiX-60Hz
menu label antiX-60Hz (force monitor to 58-62 Hz)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=791 quiet nosplash vsync=58-62 aufs initrd=/boot/antix/initrd.gz

label  antiX-75Hz
menu label antiX-75Hz (force monitor to 73-77 Hz)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=791 quiet nosplash vsync=73-77 aufs initrd=/boot/antix/initrd.gz

label back
menu label ^Back to main menu
com32 menu.c32
append isolinux.cfg
" > $WORK/boot/isolinux/antix.menu
fi
if [ -f arch.iso ];then
echo "label arch
menu label Boot ArchLive
kernel /boot/arch/vmlinuz26
append lang=en locale=en_US.UTF-8 usbdelay=5 ramdisk_size=75% archisolabel=$(cat $TAGS/cdlabel)
initrd /boot/arch/archiso.img
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f archdual.iso ];then
echo "label arch1
menu label Boot ArchLive i686
kernel /boot/arch/i686/vmlinuz26
append lang=en locale=en_US.UTF-8 usbdelay=5 ramdisk_size=75% archisolabel=$(cat $TAGS/cdlabel)
initrd /boot/arch/i686/archiso.img

label arch2
menu label Boot ArchLive x86_64
kernel /boot/arch/x86_64/vmlinuz26
append lang=en locale=en_US.UTF-8 usbdelay=5 ramdisk_size=75% archisolabel=$(cat $TAGS/cdlabel)
initrd /boot/arch/x86_64/archiso.img
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f archiso-live.iso ];then
if [ -f archiso-live.version ] && [ "$(cat archiso-live.version)" != "" ];then
	VERSION=" ($(cat archiso-live.version))" #Version based on isoaliases()
else
	VERSION=""
fi
echo "LABEL archiso-live
TEXT HELP
Boot the Arch Linux live medium. It allows you to install Arch Linux or
perform system maintenance.
ENDTEXT
MENU LABEL Boot ^archiso-live$VERSION
KERNEL /boot/archiso-live/vmlinuz
APPEND initrd=/boot/archiso-live/initrd.img locale=en_US.UTF-8 load=overlay cdname=archiso-live session=xfce
IPAPPEND 0

LABEL archiso-livebaseonly
TEXT HELP
Boot the Arch Linux live medium. It allows you to install Arch Linux or
perform system maintenance. Basic LXDE desktop and apps.
ENDTEXT
MENU LABEL Boot archiso-live with baseonly$VERSION
KERNEL /boot/archiso-live/vmlinuz
APPEND initrd=/boot/archiso-live/initrd.img locale=en_US.UTF-8 load=overlay cdname=archiso-live session=lxde baseonly
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f austrumi.iso ];then
echo "label austrumilinux
	menu label ^Austrumi
	com32 vesamenu.c32
	append al.menu
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f avg.iso ];then
#if [ -f avg.version ] && [ "$(cat avg.version)" != "" ];then
#	AVGVER=" (avg_$(cat avg.version))"
#else
#	AVGVER=""
#fi
AVGVER=" ($(cat $WORK/arl-version))"
echo "MENU BEGIN --> AVG Rescue CD$AVGVER

label arl
	menu label AVG Rescue CD
	menu default
	kernel /boot/avg/vmlinuz
	initrd /boot/avg/initrd.lzm
	append max_loop=255 vga=791 init=linuxrc

label nofb
	menu label AVG Rescue CD with Disabled Framebuffer
	kernel /boot/avg/vmlinuz
	initrd /boot/avg/initrd.lzm
	append max_loop=255 video=vesafb:off init=linuxrc

label vgask
	menu label AVG Rescue CD with Resolution Selection
	kernel /boot/avg/vmlinuz
	initrd /boot/avg/initrd.lzm
	append max_loop=255 init=linuxrc vga=ask

label back
	menu label Back to main menu
	com32 menu.c32
	append isolinux.cfg
menu end" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f backtrack.iso ];then
cat >> $WORK/boot/isolinux/isolinux.cfg << "EOF"
label			backtrack1024
menu label		Start ^BackTrack FrameBuffer (1024x768)
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper nopersistent rw quiet vga=0x317 ignore_uuid
initrd			/boot/backtrack/initrd.gz

label			backtrack800
menu label		Start BackTrack FrameBuffer (800x600)
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper nopersistent rw quiet vga=0x314 ignore_uuid
initrd			/boot/backtrack/initrd800.gz

label			backtrack-forensics
menu label		Start BackTrack Forensics (no swap)
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper nopersistent rw vga=0x317 ignore_uuid
initrd			/boot/backtrack/initrdfr.gz

label			backtrack-safe
menu label 		Start BackTrack in Safe Graphical Mode
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper xforcevesa rw quiet ignore_uuid
initrd			/boot/backtrack/initrd.gz

label			backtrack-persistent
menu label		Start Persistent Backtrack Live CD
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper persistent rw quiet ignore_uuid
initrd			/boot/backtrack/initrd.gz

label			backtrack-text
menu label		Start BackTrack in Text Mode
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper nopersistent textonly rw quiet ignore_uuid
initrd			/boot/backtrack/initrd.gz

label			backtrack-ram
menu label		Start BackTrack Graphical Mode from RAM
kernel			/boot/backtrack/vmlinuz
append			BOOT=casper boot=casper toram nopersistent rw quiet ignore_uuid
initrd			/boot/backtrack/initrd.gz
EOF
fi
if [ -f caine.iso ];then
echo "label caine2
kernel /boot/caine/vmlinuz
initrd /boot/caine/initrd.gz
append live-media-path=/boot/caine ignore_uuid noprompt persistent BOOT_IMAGE=/casper/vmlinuz file=/cdrom/CaineFiles/custom.seed boot=casper -- debian-installer/language=$(cat $TAGS/lang) console-setup/layoutcode=$(cat $TAGS/lang)
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f cdl.iso ];then
#CDLinux uses country codes longer than two letters, so I don't think I'll get much out of $TAGS/lang here.
echo "menu begin --> ^CDlinux

label cdlinux-en_US
	menu label ^CDlinux (en_US) English
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=en_US.UTF-8
	initrd /CDlinux/initrd
label cdlinux-de_DE
	menu label ^CDlinux (de_DE) Deutsch
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=de_DE.UTF-8
	initrd /CDlinux/initrd
label cdlinux-en_CA
	menu label ^CDlinux (en_CA) English
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=en_CA.UTF-8
	initrd /CDlinux/initrd
label cdlinux-en_GB
	menu label ^CDlinux (en_GB) English
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=en_GB.UTF-8
	initrd /CDlinux/initrd
label cdlinux-fr_CA
	menu label ^CDlinux (fr_CA) French
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=fr_CA.UTF-8
	initrd /CDlinux/initrd
label cdlinux-fr_CH
	menu label ^CDlinux (fr_CH) French
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=fr_CH.UTF-8
	initrd /CDlinux/initrd
label cdlinux-fr_FR
	menu label ^CDlinux (fr_FR) French
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=fr_FR.UTF-8
	initrd /CDlinux/initrd
label cdlinux-ja_JP
	menu label ^CDlinux (ja_JP) Japanese
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=ja_JP.UTF-8
	initrd /CDlinux/initrd
label cdlinux-ru_RU
	menu label ^CDlinux (ru_RU) Russian
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=ru_RU.UTF-8
	initrd /CDlinux/initrd
label cdlinux-zh_CN
	menu label ^CDlinux (zh_CN) Chinese
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=zh_CN.UTF-8
	initrd /CDlinux/initrd
label cdlinux-zh_TW
	menu label ^CDlinux (zh_TW) Chinese
	kernel /CDlinux/bzImage
	append quiet CDL_LANG=zh_TW.UTF-8
	initrd /CDlinux/initrd
label cdlinux-sfg
	menu label ^CDlinux Safe Graphics Mode
	kernel /CDlinux/bzImage
	append quiet CDL_SAFEG=yes
	initrd /CDlinux/initrd 
label back
	menu label Back to Main Menu
	com32 menu.c32
	append isolinux.cfg
menu end
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f clonezilla.iso ];then
echo "label clonezilla
menu label --> ^Clonezilla
com32 vesamenu.c32
append clonezil.cfg
" >> $WORK/boot/isolinux/isolinux.cfg
#GNU sed syntax
sed -i -e 's/\/live\//\/boot\/clonezilla\//g' multicd-working/boot/isolinux/clonezil.cfg #Change directory to /boot/clonezilla
sed -i -e 's/append initrd=/append live-media-path=\/boot\/clonezilla initrd=/g' multicd-working/boot/isolinux/clonezil.cfg #Tell the kernel we moved it
echo "label back
menu label Back to main menu
com32 menu.c32
append isolinux.cfg
" >> $WORK/boot/isolinux/clonezil.cfg
fi
#BEGIN DBAN ENTRY#
if [ -f dban.iso ];then
echo "#Most of the DBAN options are commented out on the menu because they're so dangerous.
#Even if you uncomment them, they won't appear on the menu unless you also remove MENU HIDE (you can still press Esc and enter them to boot.)

LABEL  dban
MENU LABEL ^DBAN
KERNEL /boot/dban1/dban.bzi
APPEND nuke=\"dwipe --method prng --rounds 8 --verify off\" floppy=0,16,cmos

#LABEL  autonuke
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"dwipe --autonuke\" silent
#
#LABEL  dod
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"dwipe --autonuke --method dod522022m\" silent
#
#LABEL  dod3pass
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"dwipe --autonuke --method dod3pass\" silent
#
#LABEL  dodshort
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"dwipe --autonuke --method dodshort\" silent
#
#LABEL  gutmann
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"dwipe --autonuke --method gutmann\" silent
#
#LABEL  ops2
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe --autonuke --method ops2\" silent
#
#LABEL  paranoid
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe --autonuke --method prng --rounds 8 --verify all\" silent
#
#LABEL  prng
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe --autonuke --method prng --rounds 8\" silent
#
#LABEL  quick
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe --autonuke --method quick\" silent
#
#LABEL  zero
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe --autonuke --method zero\" silent
#
#LABEL  nofloppy
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe\" floppy=0,16,cmos
#
#LABEL  nosilent
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe\"
#
#LABEL  noverify
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc quiet nuke=\"dwipe --verify off\"
#
#LABEL  debug
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"exec ash\" debug
#
#LABEL  shell
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"exec ash\"
#
#LABEL  verbose
#MENU HIDE
#KERNEL /boot/dban1/kernel.bzi
#APPEND initrd=/boot/dban1/initrd.gz root=/dev/ram0 init=/rc nuke=\"dwipe --method quick\"
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
#END DBAN ENTRY#
if [ -f debian-install.iso ];then
if [ -f debian-install.version ] && [ "$(cat debian-install.version)" != "" ];then
	VERSION=" (5$(cat debian-install.version))" #The 5 here is intentional
else
	VERSION=""
fi
echo "menu begin --> ^Debian GNU/Linux installer$VERSION

label install
	menu label ^Install
	menu default
	kernel /install.386/vmlinuz
	append vga=normal initrd=/install.386/initrd.gz -- quiet 
label expert
	menu label ^Expert install
	kernel /install.386/vmlinuz
	append priority=low vga=normal initrd=/install.386/initrd.gz -- 
label rescue
	menu label ^Rescue mode
	kernel /install.386/vmlinuz
	append vga=normal initrd=/install.386/initrd.gz rescue/enable=true -- quiet 
label auto
	menu label ^Automated install
	kernel /install.386/vmlinuz
	append auto=true priority=critical vga=normal initrd=/install.386/initrd.gz -- quiet 
label installgui
	menu label ^Graphical install
	kernel /install.386/vmlinuz
	append video=vesa:ywrap,mtrr vga=788 initrd=/install.386/gtk/initrd.gz -- quiet 
label expertgui
	menu label Graphical expert install
	kernel /install.386/vmlinuz
	append priority=low video=vesa:ywrap,mtrr vga=788 initrd=/install.386/gtk/initrd.gz -- 
label rescuegui
	menu label Graphical rescue mode
	kernel /install.386/vmlinuz
	append video=vesa:ywrap,mtrr vga=788 initrd=/install.386/gtk/initrd.gz rescue/enable=true -- quiet  
label autogui
	menu label Graphical automated install
	kernel /install.386/vmlinuz
	append auto=true priority=critical video=vesa:ywrap,mtrr vga=788 initrd=/install.386/gtk/initrd.gz -- quiet 
label Back to main menu
	com32 menu.c32
	append isolinux.cfg

menu end" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f binary.iso ];then
if [ -f $TAGS/debian-live.name ] && [ "$(cat $TAGS/debian-live.name)" != "" ];then
	DEBNAME=$(cat $TAGS/debian-live.name)
else
	DEBNAME="Debian Live"
fi
echo "label debian-live
menu label >> ^$DEBNAME
com32 menu.c32
append dlive.cfg" >> $WORK/boot/isolinux/isolinux.cfg
sed '/memtest/d' $WORK/boot/isolinux/dlive.cfg | sed '/Memory test/d' > /tmp/dlive.cfg
mv /tmp/dlive.cfg $WORK/boot/isolinux/dlive.cfg
echo "label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
" >> multicd-working/boot/isolinux/dlive.cfg
fi
if [ -f debian-mini.iso ];then
echo "LABEL dinstall
menu label ^Install Debian
	kernel /boot/debian/linux
	append vga=normal initrd=/boot/debian/initrd.gz -- quiet 
LABEL dexpert
menu label Install Debian - expert mode
	kernel /boot/debian/linux
	append priority=low vga=normal initrd=/boot/debian/initrd.gz -- 
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f deli.iso ];then
echo "label deli-ide
	menu label ^DeLi Linux
	kernel /isolinux/bzImage
	append initrd=/isolinux/initrd.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=6464 rw root=/dev/ram

label deli-scsi
	menu label ^DeLi Linux - SCSI
	kernel /isolinux/scsi
	append initrd=/isolinux/initrd.gz load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=6464 rw root=/dev/ram" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f diskcopy.iso ];then
echo "label diskcopy
menu label ^EASEUS Disk Copy
kernel /boot/diskcopy/bzImage
append initrd=/boot/diskcopy/initrd.img
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f dsl.iso ];then
echo "menu begin --> ^DSL

LABEL dsl
MENU LABEL DSL
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/isolinux/minirt24.gz nomce noapic quiet BOOT_IMAGE=knoppix

LABEL dsl-toram
MENU LABEL DSL (load to RAM)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/isolinux/minirt24.gz nomce noapic quiet toram BOOT_IMAGE=knoppix

LABEL dsl-2
MENU LABEL DSL (boot to command line)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/isolinux/minirt24.gz nomce noapic quiet 2 BOOT_IMAGE=knoppix

LABEL dsl-expert
MENU LABEL DSL (expert mode)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/isolinux/minirt24.gz nomce BOOT_IMAGE=expert

LABEL dsl-fb1280x1024
MENU LABEL DSL (1280x1024 framebuffer)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=794 xmodule=fbdev initrd=/boot/isolinux/minirt24.gz nomce noapic quiet BOOT_IMAGE=knoppix

LABEL dsl-fb1024x768
MENU LABEL DSL (1024x768 framebuffer)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 xmodule=fbdev initrd=/boot/isolinux/minirt24.gz nomce noapic quiet BOOT_IMAGE=knoppix

LABEL dsl-fb800x600
MENU LABEL DSL (800x600 framebuffer)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=788 xmodule=fbdev initrd=/boot/isolinux/minirt24.gz nomce noapic quiet BOOT_IMAGE=knoppix

LABEL dsl-lowram
MENU LABEL DSL (for low RAM)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=normal initrd=/boot/isolinux/minirt24.gz noscsi noideraid nosound nousb nofirewire noicons minimal nomce noapic noapm lowram quiet BOOT_IMAGE=knoppix

LABEL dsl-install
MENU LABEL Install DSL
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=normal initrd=/boot/isolinux/minirt24.gz noscsi noideraid nosound nofirewire legacy base norestore _install_ nomce noapic noapm quiet BOOT_IMAGE=knoppix

LABEL dsl-failsafe
MENU LABEL DSL (failsafe)
KERNEL /boot/isolinux/linux24
APPEND ramdisk_size=100000 init=/etc/init 2 lang=us vga=normal atapicd nosound noscsi nousb nopcmcia nofirewire noagp nomce nodhcp xmodule=vesa initrd=/boot/isolinux/minirt24.gz BOOT_IMAGE=knoppix base norestore legacy

label back
menu label ^Back to main menu
com32 menu.c32
append isolinux.cfg

MENU END
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f dvl.iso ];then
echo "label dvl
menu label Damn ^Vulnerable Linux
kernel /boot/dvl/vmlinuz
initrd /boot/dvl/initrd.gz
append vga=0x317 max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=4444 root=/dev/ram0 rw

label dvlsafe
menu label Damn Vulnerable Linux (dvlsafe)
kernel /boot/dvl/vmlinuz
initrd /boot/dvl/initrd.gz
append vga=769 max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=4444 root=/dev/ram0 rw
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f efw.iso ];then
echo "label endianfirewall
	menu label ^Endian Firewall - Default
	kernel /boot/endian/vmlinuz 
	append initrd=/boot/endian/instroot.gz root=/dev/ram0 rw
label endianfirewall_unattended 
	menu label ^Endian Firewall - Unattended
	kernel /boot/endian/vmlinuz
	append initrd=/boot/endian/instroot.gz root=/dev/ram0 rw unattended
label endianfirewall_nopcmcia 
	menu label ^Endian Firewall - No PCMCIA
	kernel /boot/endian/vmlinuz
	append ide=nodma initrd=/boot/endian/instroot.gz root=/dev/ram0 rw nopcmcia
label endianfirewall_nousb
	menu label ^Endian Firewall - No USB
	kernel /boot/endian/vmlinuz
	append ide=nodma initrd=/boot/endian/instroot.gz root=/dev/ram0 rw nousb
label endianfirewall_nousborpcmcia
	menu label ^Endian Firewall - No USB nor PCMCIA
	kernel /boot/endian/vmlinuz
	append ide=nodma initrd=/boot/endian/instroot.gz root=/dev/ram0 rw nousb nopcmcia
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f elastix.iso ];then
echo "label elastixmenu
menu label --> ^Elastix
config /boot/isolinux/elastix.cfg
" >> $WORK/boot/isolinux/isolinux.cfg
echo "default linux
prompt 1
timeout 600
display /boot/elastix/boot.msg
F1 /boot/elastix/boot.msg
F2 /boot/elastix/options.msg
F3 /boot/elastix/general.msg
F4 /boot/elastix/param.msg
F5 /boot/elastix/rescue.msg
F7 /boot/elastix/snake.msg
label advanced
  kernel /boot/elastix/vmlinuz
  append ks=cdrom:/ks_advanced.cfg initrd=/boot/elastix/initrd.img ramdisk_size=8192
label elastix
  kernel /boot/elastix/vmlinuz
  append initrd=/boot/elastix/initrd.img ramdisk_size=8192
label linux
  kernel /boot/elastix/vmlinuz
  append ks=cdrom:/ks.cfg initrd=/boot/elastix/initrd.img ramdisk_size=8192
label rhinoraid
  kernel /boot/elastix/vmlinuz
  append ks=cdrom:/ks_rhinoraid.cfg initrd=/boot/elastix/initrd.img ramdisk_size=8192
label local
  localboot 1
label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
" > $WORK/boot/isolinux/elastix.cfg
fi
if [ -f feather.iso ];then
echo "LABEL feather
MENU LABEL ^Feather Linux
KERNEL /boot/feather/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/feather/minirt24.gz knoppix_dir=FEATHER nomce quiet BOOT_IMAGE=knoppix
LABEL feather-toram
MENU LABEL Feather Linux (load to RAM)
KERNEL /boot/feather/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/feather/minirt24.gz knoppix_dir=FEATHER nomce quiet toram BOOT_IMAGE=knoppix
LABEL feather-2
MENU LABEL Feather Linux (boot to command line)
KERNEL /boot/feather/linux24
APPEND ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=/boot/feather/minirt24.gz knoppix_dir=FEATHER nomce quiet 2 BOOT_IMAGE=knoppix
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f fedora-boot.iso ];then
if [ -f fedora-boot.version ] && [ "$(cat fedora-boot.version)" != "" ];then
	VERSION=" $(cat fedora-boot.version)" #Version based on isoaliases()
fi
echo "label flinux
  #TIP: If you change the method= entry in the append line, you can change the mirror and version installed.
  menu label ^Install Fedora$VERSION from mirrors.kernel.org (Fedora 13 only)
  kernel /boot/fedora/vmlinuz
  append initrd=/boot/fedora/initrd.img method=http://mirrors.kernel.org/fedora/releases/13/Fedora/i386/os
label flinux
  menu label ^Install or upgrade Fedora$VERSION from another mirror
  kernel /boot/fedora/vmlinuz
  append initrd=/boot/fedora/initrd.img
label ftext
  menu label Install or upgrade Fedora$VERSION (text mode)
  kernel /boot/fedora/vmlinuz
  append initrd=/boot/fedora/initrd.img text
label frescue
  menu label Rescue installed Fedora$VERSION system
  kernel /boot/fedora/vmlinuz
  append initrd=/boot/fedora/initrd.img rescue
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f fedora-boot64.iso ];then
if [ -f fedora-boot64.version ] && [ "$(cat fedora-boot64.version)" != "" ];then
	VERSION=" $(cat fedora-boot64.version)" #Version based on isoaliases()
fi
echo "label flinux64
  #TIP: If you change the method= entry in the append line, you can change the mirror and version installed.
  menu label ^Install 64-bit Fedora$VERSION from mirrors.kernel.org (Fedora 13 only)
  kernel /boot/fedora64/vmlinuz
  append initrd=/boot/fedora64/initrd.img method=http://mirrors.kernel.org/fedora/releases/13/Fedora/x86_64/os
label flinux64
  menu label ^Install or upgrade 64-bit Fedora$VERSION from another mirror
  kernel /boot/fedora64/vmlinuz
  append initrd=/boot/fedora64/initrd.img
label ftext64
  menu label Install or upgrade 64-bit Fedora$VERSION (text mode)
  kernel /boot/fedora64/vmlinuz
  append initrd=/boot/fedora64/initrd.img text
label frescue64
  menu label Rescue installed 64-bit Fedora$VERSION system
  kernel /boot/fedora64/vmlinuz
  append initrd=/boot/fedora64/initrd.img rescue
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f finnix.iso ];then
echo "menu begin --> ^Finnix

label Finnix
  MENU LABEL ^Finnix (x86)
  kernel /boot/finnix/linux
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt apm=power-off vga=791 quiet

label Finnix64
  MENU LABEL Finnix (AMD64)
  kernel /boot/finnix/linux64
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt apm=power-off vga=791 quiet

label FinnixText
  MENU LABEL ^Finnix (x86, textmode)
  kernel /boot/finnix/linux
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt apm=power-off vga=normal quiet

label FinnixDebug
  MENU LABEL ^Finnix (x86, debug mode)
  kernel /boot/finnix/linux
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt apm=power-off vga=normal debug

label Finnix64Text
  MENU LABEL Finnix (AMD64, textmode)
  kernel /boot/finnix/linux64
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt apm=power-off vga=normal quiet

label Finnix64Debug
  MENU LABEL Finnix (AMD64, debug mode)
  kernel /boot/finnix/linux64
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt apm=power-off vga=normal debug

label FinnixFailsafe
  MENU LABEL ^Finnix (failsafe)
  kernel /boot/finnix/linux
  append finnixfile=/FINNIX/FINNIX initrd=/boot/finnix/minirt vga=normal noapic noacpi pnpbios=off acpi=off nofstab nodma noapm nodhcp nolvm nomouse noeject

label sbm
  MENU LABEL Smart Boot Manager
  kernel /boot/finnix/memdisk
  append initrd=/boot/finnix/sbm.imz

menu end
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f fdfullcd.iso ];then
echo "label fdos
menu label ^FreeDOS 1.0 (full)
kernel memdisk
append initrd=/boot/freedos/fdboot.img
" >> multicd-working/boot/isolinux/isolinux.cfg
elif [ -f fdbasecd.iso ];then
echo "label fdos
menu label ^FreeDOS 1.0 (base)
kernel memdisk
append initrd=/boot/freedos/fdboot.img
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f geexbox.iso ];then
echo "label gbox
	menu label ^GeeXboX
	com32 vesamenu.c32
	append gbox.menu
" >> multicd-working/boot/isolinux/isolinux.cfg
echo "PROMPT 0

TIMEOUT 20

MENU BACKGROUND /GEEXBOX/boot/splash.png
MENU TITLE Welcome to GeeXboX i386 (C) 2002-2009
MENU VSHIFT 11
MENU ROWS 6
MENU TABMSGROW 15
MENU CMDLINEROW 14
MENU HELPMSGROW 16
MENU TABMSG Press [Tab] to edit options, [F1] for boot options.
MENU COLOR sel 7;37;40 #e0000000 #fa833b all
MENU COLOR border 30;44 #00000000 #00000000 none

LABEL geexbox
  MENU LABEL Start GeeXboX ...
  KERNEL /GEEXBOX/boot/vmlinuz
  APPEND initrd=/GEEXBOX/boot/initrd.gz root=/dev/ram0 rw rdinit=linuxrc boot=cdrom lang=en remote=atiusb receiver=atiusb keymap=qwerty splash=silent vga=789 video=vesafb:ywrap,mtrr quiet

LABEL hdtv
  MENU DEFAULT
  MENU LABEL Start GeeXboX for HDTV ...
  KERNEL /GEEXBOX/boot/vmlinuz
  APPEND initrd=/GEEXBOX/boot/initrd.gz root=/dev/ram0 rw rdinit=linuxrc boot=cdrom lang=en remote=atiusb receiver=atiusb keymap=qwerty splash=silent vga=789 video=vesafb:ywrap,mtrr hdtv quiet

LABEL install
  MENU LABEL Install GeeXboX to disk ...
  KERNEL /GEEXBOX/boot/vmlinuz
  APPEND initrd=/GEEXBOX/boot/initrd.gz root=/dev/ram0 rw rdinit=linuxrc boot=cdrom lang=en remote=atiusb receiver=atiusb keymap=qwerty splash=silent vga=789 video=vesafb:ywrap,mtrr installator quiet

#CFG#LABEL configure
#CFG#  MENU LABEL Reconfigure a GeeXboX installation ...
#CFG#  KERNEL /GEEXBOX/boot/vmlinuz
#CFG#  APPEND initrd=/GEEXBOX/boot/initrd.gz root=/dev/ram0 rw rdinit=linuxrc boot=cdrom lang=en remote=atiusb receiver=atiusb keymap=qwerty splash=silent vga=789 video=vesafb:ywrap,mtrr configure

MENU SEPARATOR

LABEL debug
  MENU LABEL Start in debugging mode ...
  KERNEL /GEEXBOX/boot/vmlinuz
  APPEND initrd=/GEEXBOX/boot/initrd.gz root=/dev/ram0 rw rdinit=linuxrc boot=cdrom lang=en remote=atiusb receiver=atiusb keymap=qwerty splash=0 vga=789 video=vesafb:ywrap,mtrr debugging

LABEL hdtvdebug
  MENU LABEL Start HDTV edition in debugging mode ...
  KERNEL /GEEXBOX/boot/vmlinuz
  APPEND initrd=/GEEXBOX/boot/initrd.gz root=/dev/ram0 rw rdinit=linuxrc boot=cdrom lang=en remote=atiusb receiver=atiusb keymap=qwerty splash=0 vga=789 video=vesafb:ywrap,mtrr hdtv debugging

F1 help.msg #00000000
" > multicd-working/boot/isolinux/gbox.menu
fi
if [ -f gparted.iso ];then
echo "# Since no network setting in the squashfs image, therefore if ip=frommedia, the network is disabled. That's what we want.
label GParted Live
  # MENU HIDE
  MENU LABEL GParted Live (Default settings)
  # MENU PASSWD
  kernel /boot/gparted/vmlinuz1
  append initrd=/boot/gparted/initrd1.img boot=live config i915.modeset=0 xforcevesa radeon.modeset=0 noswap nomodeset vga=788 ip=frommedia nosplash live-media-path=/boot/gparted
  TEXT HELP
  * GParted live version: 0.6.4-1. Live version maintainer: Steven Shiau
  * Disclaimer: GParted live comes with ABSOLUTELY NO WARRANTY
  ENDTEXT

MENU BEGIN Other modes of GParted Live
label GParted Live (To RAM)
  # MENU DEFAULT
  # MENU HIDE
  MENU LABEL GParted Live (To RAM. Boot media can be removed later)
  # MENU PASSWD
  kernel /boot/gparted/vmlinuz1
  append initrd=/boot/gparted/initrd1.img boot=live config i915.modeset=0 xforcevesa radeon.modeset=0 noswap nomodeset noprompt vga=788 toram=filesystem.squashfs live-media-path=/boot/gparted ip=frommedia  nosplash
  TEXT HELP
  All the programs will be copied to RAM, so you can
  remove boot media (CD or USB flash drive) later
  ENDTEXT

label GParted Live without framebuffer
  # MENU DEFAULT
  # MENU HIDE
  MENU LABEL GParted Live (Safe graphic settings, vga=normal)
  # MENU PASSWD
  kernel /boot/gparted/vmlinuz1
  append initrd=/boot/gparted/initrd1.img boot=live config i915.modeset=0 xforcevesa radeon.modeset=0 noswap nomodeset ip=frommedia vga=normal nosplash live-media-path=/boot/gparted
  TEXT HELP
  Disable console frame buffer support
  ENDTEXT

label GParted Live failsafe mode
  # MENU DEFAULT
  # MENU HIDE
  MENU LABEL GParted Live (Failsafe mode)
  # MENU PASSWD
  kernel /boot/gparted/vmlinuz1
  append initrd=/boot/gparted/initrd1.img boot=live config i915.modeset=0 xforcevesa radeon.modeset=0 noswap nomodeset acpi=off irqpoll noapic noapm nodma nomce nolapic nosmp ip=frommedia vga=normal nosplash live-media-path=/boot/gparted
  TEXT HELP
  acpi=off irqpoll noapic noapm nodma nomce nolapic 
  nosmp vga=normal nosplash
  ENDTEXT
MENU END
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f hirens.iso ];then
echo "label hirens
menu label --> ^$(cat $TAGS/hirens.name) - main menu
com32 menu.c32
append /HBCD/isolinux.cfg" >> multicd-working/boot/isolinux/isolinux.cfg
rm $TAGS/hirens.name
fi
if [ -f insert.iso ];then
echo "LABEL insert
menu label ^INSERT
KERNEL /boot/insert/vmlinuz
APPEND ramdisk_size=100000 init=/etc/init lang=en apm=power-off vga=773 initrd=/boot/insert/miniroot.lz nomce noapic dma BOOT_IMAGE=insert
LABEL insert-txt
menu label INSERT (vga=normal)
KERNEL /boot/insert/vmlinuz
APPEND ramdisk_size=100000 init=/etc/init lang=en apm=power-off vga=normal initrd=/boot/insert/miniroot.lz nomce noapic dma BOOT_IMAGE=insert
LABEL expert
menu label INSERT (expert mode)
KERNEL /boot/insert/vmlinuz
APPEND ramdisk_size=100000 init=/etc/init lang=en apm=power-off vga=773 initrd=/boot/insert/miniroot.lz nomce noapic dma BOOT_IMAGE=expert
LABEL failsafe
menu label INSERT (failsafe)
KERNEL /boot/insert/vmlinuz
APPEND ramdisk_size=100000 init=/etc/init lang=en vga=normal atapicd nosound noapic noacpi pnpbios=off acpi=off nofstab noscsi nodma noapm nousb nopcmcia nofirewire noagp nomce nodhcp xmodule=vesa initrd=/boot/insert/miniroot.lz BOOT_IMAGE=insert
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f ipcop.iso ];then
echo "label ipcopmenu
menu label --> ^IPCop
config /boot/isolinux/ipcop.cfg
" >> multicd-working/boot/isolinux/isolinux.cfg
echo "TIMEOUT 5000
F1 /boot/ipcop/f1.txt
F2 /boot/ipcop/f2.txt
F3 /boot/ipcop/f3.txt
DISPLAY /boot/ipcop/f1.txt
PROMPT 1
DEFAULT /boot/ipcop/vmlinuz
APPEND ide=nodma initrd=/boot/ipcop/instroot.gz root=/dev/ram0 rw
LABEL nopcmcia 
  KERNEL /boot/ipcop/vmlinuz
  APPEND ide=nodma initrd=/boot/ipcop/instroot.gz root=/dev/ram0 rw nopcmcia
LABEL noscsi
  KERNEL /boot/ipcop/vmlinuz
  APPEND ide=nodma initrd=/boot/ipcop/instroot.gz root=/dev/ram0 rw scsi=none
LABEL nousb
  KERNEL /boot/ipcop/vmlinuz
  APPEND ide=nodma initrd=/boot/ipcop/instroot.gz root=/dev/ram0 rw nousb
LABEL nousborpcmcia
  KERNEL v/boot/ipcop/mlinuz
  APPEND ide=nodma initrd=/boot/ipcop/instroot.gz root=/dev/ram0 rw nousb nopcmcia
LABEL dma
  KERNEL /boot/ipcop/vmlinuz
  APPEND initrd=/boot/ipcop/instroot.gz root=/dev/ram0 rw
LABEL memtest
  KERNEL /boot/memtest
  APPEND -
" > multicd-working/boot/isolinux/ipcop.cfg
fi
if [ -f knoppix.iso ];then
if [ -f knoppix.version ] && [ "$(cat knoppix.version)" != "" ];then
	KNOPPIXVER=" $(cat knoppix.version)"
else
	KNOPPIXVER=""
fi
echo "MENU BEGIN --> ^Knoppix$KNOPPIXVER

LABEL knoppix
MENU LABEL Knoppix
KERNEL /boot/knoppix/linux
INITRD /boot/knoppix/minirt.gz
APPEND ramdisk_size=100000 lang=$(cat $TAGS/lang) vt.default_utf8=0 apm=power-off vga=791 nomce quiet loglevel=0 tz=localtime knoppix_dir=KNOPPIX6

LABEL adriane
MENU LABEL Adriane (Knoppix)
KERNEL /boot/knoppix/linux
INITRD /boot/knoppix/minirt.gz
APPEND ramdisk_size=100000 lang=$(cat $TAGS/lang) vt.default_utf8=0 apm=power-off vga=791 nomce quiet loglevel=0 tz=localtime knoppix_dir=KNOPPIX6 adriane

LABEL knoppix-2
MENU LABEL Knoppix (boot to command line)
KERNEL /boot/knoppix/linux
INITRD /boot/knoppix/minirt.gz
APPEND ramdisk_size=100000 lang=$(cat $TAGS/lang) vt.default_utf8=0 apm=power-off vga=791 nomce quiet loglevel=0 tz=localtime knoppix_dir=KNOPPIX6 2

LABEL fb1024x768
KERNEL linux
APPEND ramdisk_size=100000 lang=en vt.default_utf8=0 apm=power-off vga=791 xmodule=fbdev initrd=minirt.gz nomce quiet loglevel=0 tz=localtime
LABEL fb1280x1024
KERNEL linux
APPEND ramdisk_size=100000 lang=en vt.default_utf8=0 apm=power-off vga=794 xmodule=fbdev initrd=minirt.gz nomce quiet loglevel=0 tz=localtime
LABEL fb800x600
KERNEL linux
APPEND ramdisk_size=100000 lang=en vt.default_utf8=0 apm=power-off vga=788 xmodule=fbdev initrd=minirt.gz nomce quiet loglevel=0 tz=localtime

label back
menu label Back to main menu
com32 menu.c32
append isolinux.cfg

MENU END
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f linuxmint.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << EOF
label linuxmint
menu label --> Linux ^Mint Menu
com32 vesamenu.c32
append /boot/linuxmint/linuxmint.cfg

EOF
cat >> multicd-working/boot/linuxmint/linuxmint.cfg << EOF

label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
EOF
fi
if [ -f macpup.iso ];then
if [ -f $TAGS/macpup.name ] && [ "$(cat $TAGS/macpup.name)" != "" ];then
	PUPNAME=$(cat $TAGS/macpup.name)
else
	PUPNAME="Macpup"
fi
if [ -d $WORK/macpup ];then
	EXTRAARGS="psubdir=macpup"
fi
echo "label macpup
menu label ^$PUPNAME
kernel /macpup/vmlinuz
append pmedia=cd $EXTRAARGS
initrd /macpup/initrd.gz
#label macpup-nox
#menu label $PUPNAME (boot to command line)
#kernel /macpup/vmlinuz
#append pmedia=cd pfix=nox $EXTRAARGS
#initrd /macpup/initrd.gz
#label macpup-noram
#menu label $PUPNAME (don't load to RAM)
#kernel /macpup/vmlinuz
#append pmedia=cd pfix=noram $EXTRAARGS
#initrd /macpup/initrd.gz
" >> $WORK/boot/isolinux/isolinux.cfg
fi
if [ -f mandriva-boot.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label alt0
  menu label Install ^Mandriva
  kernel /boot/mandriva/alt0/vmlinuz
  append initrd=/boot/mandriva/alt0/all.rdz  vga=788 splash=silent
label alt0-vgahi
  menu label Install Mandriva (hi-res installer)
  kernel /boot/mandriva/alt0/vmlinuz
  append initrd=/boot/mandriva/alt0/all.rdz  vga=791
label alt0-text
  menu label Install Mandriva (text-mode installer)
  kernel /boot/mandriva/alt0/vmlinuz
  append initrd=/boot/mandriva/alt0/all.rdz  text
label alt1
  menu label Install Mandriva (server kernel)
  kernel /boot/mandriva/alt1/vmlinuz
  append initrd=/boot/mandriva/alt1/all.rdz vga=788 splash=silent
EOF
fi
if [ -f mintdebian.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << EOF
label mintdebian
menu label --> Linux Mint ^Debian Edition Menu
com32 vesamenu.c32
append /boot/mintdebian/mintdebian.cfg

EOF
cat >> multicd-working/boot/mintdebian/mintdebian.cfg << EOF

label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
EOF
fi
#BEGIN NETBOOTCD ENTRY#
if [ -f netbootcd.iso ];then
if [ -f netbootcd.version ] && [ "$(cat netbootcd.version)" != "" ];then
	NBCDVER=" $(cat netbootcd.version)"
else
	NBCDVER=""
fi
if [ -f multicd-working/boot/nbcd/nbinit4.lz ];then
echo "LABEL netbootcd
MENU LABEL ^NetbootCD$NBCDVER
KERNEL /boot/nbcd/kexec.bzI
initrd /boot/nbcd/nbinit4.lz
APPEND quiet
" >> multicd-working/boot/isolinux/isolinux.cfg
else
echo "LABEL netbootcd
MENU LABEL ^NetbootCD$NBCDVER
KERNEL /boot/nbcd/kexec.bzI
initrd /boot/nbcd/nbinit3.gz
APPEND quiet
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
fi
#END NETBOOTCD ENTRY#
if [ -f ntpasswd.iso ];then
echo "label ntpasswd
menu label ^NT Offline Password & Registry Editor
kernel /boot/ntpasswd/vmlinuz
append rw vga=1 init=/linuxrc initrd=/boot/ntpasswd/initrd.cgz,/boot/ntpasswd/scsi.cgz
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f opensuse-gnome.iso ];then
echo "label openSUSE_Live_(GNOME)
  menu label ^openSUSE Live (GNOME)
  kernel /boot/susegnom/linux
  initrd /boot/susegnom/initrd
  append ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null showopts 
label linux
  menu label Install openSUSE (GNOME)
  kernel /boot/susegnom/linux
  initrd /boot/susegnom/initrd
  append ramdisk_size=512000 ramdisk_blocksize=4096 splash=silent quiet preloadlog=/dev/null liveinstall showopts
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f opensuse-net.iso ];then
echo "label opensuse-kernel
  menu label Install ^openSUSE $(cat $TAGS/opensuse-net.version) (from mirrors.kernel.org)
  kernel /boot/opensuse/linux
  append initrd=/boot/opensuse/initrd splash=silent showopts install=ftp://mirrors.kernel.org/opensuse/distribution/"$(cat $TAGS/opensuse-net.version)"/repo/oss
label opensuse
  menu label Install openSUSE $(cat $TAGS/opensuse-net.version) (specify mirror)
  kernel /boot/opensuse/linux
  append initrd=/boot/opensuse/initrd splash=silent showopts
label opensuse-repair
  menu label Repair an installed openSUSE system
  kernel /boot/opensuse/linux
  append initrd=/boot/opensuse/initrd splash=silent repair=1 showopts
label opensuse-rescue
  menu label openSUSE rescue system
  kernel /boot/opensuse/linux
  append initrd=/boot/opensuse/initrd splash=silent rescue=1 showopts
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f opensuse-net64.iso ];then
echo "label opensuse-kernel
  menu label Install ^openSUSE $(cat $TAGS/opensuse-net.version) x86_64 (from mirrors.kernel.org)
  kernel /boot/opensuse/linux64
  append initrd=/boot/opensuse/initrd64 splash=silent showopts install=ftp://mirrors.kernel.org/opensuse/distribution/"$(cat $TAGS/opensuse-net.version)"/repo/oss
label opensuse
  menu label Install openSUSE $(cat $TAGS/opensuse-net.version) x86_64 (specify mirror)
  kernel /boot/opensuse/linux64
  append initrd=/boot/opensuse/initrd64 splash=silent showopts
label opensuse-repair
  menu label Repair an installed openSUSE x86_64 system
  kernel /boot/opensuse/linux64
  append initrd=/boot/opensuse/initrd64 splash=silent repair=1 showopts
label opensuse-rescue
  menu label openSUSE x86_64 rescue system
  kernel /boot/opensuse/linux64
  append initrd=/boot/opensuse/initrd64 splash=silent rescue=1 showopts
" >> multicd-working/boot/isolinux/isolinux.cfg
fi
	name=""
	if [ -f ophxp.iso ] && [ ! -f ophvista.iso ];then
		name="XP"
	fi
	if [ ! -f ophxp.iso ] && [ -f ophvista.iso ];then
		name="Vista"
	fi
	if [ -f ophxp.iso ] && [ -f ophvista.iso ];then
		name="XP/Vista"
	fi

	if [ -f ophxp.iso ] || [ -f ophvista.iso ];then
		echo "label ophcrack
		menu label --> ophcrack $name
		com32 vesamenu.c32
		append ophcrack.menu" >> multicd-working/boot/isolinux/isolinux.cfg

		sed 's/\/boot\//\/boot\/ophcrack\//g' multicd-working/boot/ophcrack/ophcrack.cfg > multicd-working/boot/isolinux/ophcrack.menu
		
		echo "
		label back
		menu label Back to main menu
		com32 menu.c32
		append /boot/isolinux/isolinux.cfg" >> multicd-working/boot/isolinux/ophcrack.menu

		rm multicd-working/boot/ophcrack/ophcrack.cfg
	fi
#elif [ $1 = category ];then
#	echo "tools"
if [ -f pclos.iso ];then
echo "menu begin --> ^PCLinuxOS

label LiveCD
    menu label ^PCLinuxOS Live
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto noscsi
label LiveCD_sata_probe
    menu label ^PCLinuxOS Live - SATA probe
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto
label Video_SafeMode_FBDevice
    menu label ^PCLinuxOS Live - SafeMode FBDevice
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto framebuffer
label Video_SafeMode_Vesa
    menu label ^PCLinuxOS Live - SafeMode VESA
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto vesa
label Safeboot
    menu label ^PCLinuxOS Live - Safeboot
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=off vga=normal keyb=us noscsi nopcmcia
label Console
    menu label ^PCLinuxOS Live - Console
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd 3 initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto
label Copy_to_ram
    menu label ^PCLinuxOS Live - Copy to RAM
    kernel /PCLinuxOS/isolinux/vmlinuz
    append livecd=/PCLinuxOS/livecd copy2ram initrd=/PCLinuxOS/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto splash=verbose
label back
    menu label ^Back to main menu
    com32 menu.c32
    append isolinux.cfg" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f pclx.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label LiveCD
    menu label ^PCLinuxOS LXDE Live
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto noscsi
label LiveCD_sata_probe
    menu label ^PCLinuxOS LXDE Live - SATA probe
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto
label Video_SafeMode_FBDevice
    menu label ^PCLinuxOS LXDE Live - SafeMode FBDevice
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto framebuffer
label Video_SafeMode_Vesa
    menu label ^PCLinuxOS LXDE Live - SafeMode VESA
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto vesa
label Safeboot
    menu label ^PCLinuxOS LXDE Live - Safeboot
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=off vga=normal keyb=us noscsi nopcmcia
label Console
    menu label ^PCLinuxOS LXDE Live - Console
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd 3 initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto
label Copy_to_ram
    menu label ^PCLinuxOS LXDE Live - Copy to RAM
    kernel /pclosLXDE/isolinux/vmlinuz
    append livecd=/pclosLXDE/livecd copy2ram initrd=/pclosLXDE/isolinux/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,auto splash=verbose
EOF
fi
if [ -f ping.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label ping
menu label ^PING (Partimage Is Not Ghost)
kernel /boot/ping/kernel
append vga=normal devfs=nomount pxe ramdisk_size=33000 load_ramdisk=1 init=/linuxrc prompt_ramdisk=0 initrd=/boot/ping/initrd.gz root=/dev/ram0 rw noapic nolapic lba combined_mode=libata ide0=noprobe nomce pci=nommconf pci=nomsi irqpoll
EOF
fi
if [ -f pmagic.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
LABEL normal
MENU LABEL ^Parted Magic: Default settings (Runs from RAM / Ejects CD)
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=791 sleep=10 loglevel=0 keymap=us

LABEL live
MENU LABEL ^Parted Magic: Live with default settings (USB not usable)
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=791 sleep=10 livemedia noeject loglevel=0 keymap=us

LABEL lowram
MENU LABEL ^Parted Magic: Live with low RAM settings
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=normal sleep=10 lowram livemedia noeject nogpm nolvm nonfs nofstabdaemon nosmart noacpid nodmeventd nohal loglevel=0 xvesa keymap=us

LABEL xvesa
MENU LABEL ^Parted Magic: Alternate graphical server
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=791 sleep=10 xvesa loglevel=0 keymap=us

LABEL normal-vga
MENU LABEL ^Parted Magic: Safe Graphics Settings (vga=normal)
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=normal sleep=10 loglevel=0 keymap=us

LABEL failsafe
MENU LABEL ^Parted Magic: Failsafe Settings
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=normal sleep=10 acpi=off noapic nolapic nopcmcia noscsi nogpm consoleboot nosmart keymap=us

LABEL console
MENU LABEL ^Parted Magic: Console (boots to the shell)
KERNEL /pmagic/bzImage
APPEND noapic initrd=/pmagic/initramfs load_ramdisk=1 prompt_ramdisk=0 rw vga=normal sleep=10 consoleboot keymap=us
EOF
fi
#BEGIN PUPPY ENTRY#
if [ -f puppy.iso ];then
if [ -f $TAGS/puppy.name ] && [ "$(cat $TAGS/puppy.name)" != "" ];then
	PUPNAME=$(cat $TAGS/puppy.name) #User-entered name
elif [ -f puppy.defaultname ] && [ "$(cat puppy.defaultname)" != "" ];then
	PUPNAME=$(cat puppy.defaultname) #Default name based on the automatic links made in isoaliases()
else
	PUPNAME="Puppy Linux" #Fallback name
fi
if [ -f puppy.version ] && [ "$(cat puppy.version)" != "" ];then
	PUPNAME="$PUPNAME $(cat puppy.version)" #Version based on isoaliases()
fi
if [ -d $WORK/puppy ];then
	EXTRAARGS="psubdir=puppy"
fi
echo "label puppy
menu label ^$PUPNAME
kernel /puppy/vmlinuz
append pmedia=cd $EXTRAARGS
initrd /puppy/initrd.gz
#label puppy-nox
#menu label $PUPNAME (boot to command line)
#kernel /puppy/vmlinuz
#append pmedia=cd pfix=nox $EXTRAARGS
#initrd /puppy/initrd.gz
#label puppy-noram
#menu label $PUPNAME (don't load to RAM)
#kernel /puppy/vmlinuz
#append pmedia=cd pfix=noram $EXTRAARGS
#initrd /puppy/initrd.gz
" >> $WORK/boot/isolinux/isolinux.cfg
fi
#END PUPPY ENTRY#
#BEGIN PUPPY2 ENTRY#
if [ -f puppy2.iso ];then
if [ -f $TAGS/puppy2.name ] && [ "$(cat $TAGS/puppy2.name)" != "" ];then
	PUPNAME=$(cat $TAGS/puppy2.name)
elif [ -f puppy2.defaultname ] && [ "$(cat puppy2.defaultname)" != "" ];then
	PUPNAME=$(cat puppy2.defaultname)
else
	PUPNAME="Puppy Linux #2"
fi
if [ -d $WORK/puppy2 ];then
	EXTRAARGS="psubdir=puppy2"
fi
echo "label puppy2
menu label ^$PUPNAME
kernel /puppy2/vmlinuz
append pmedia=cd $EXTRAARGS
initrd /puppy2/initrd.gz
#label puppy2-nox
#menu label $PUPNAME (boot to command line)
#kernel /puppy2/vmlinuz
#append pmedia=cd pfix=nox $EXTRAARGS
#initrd /puppy2/initrd.gz
#label puppy2-noram
#menu label $PUPNAME (don't load to RAM)
#kernel /puppy2/vmlinuz
#append pmedia=cd pfix=noram $EXTRAARGS
#initrd /puppy2/initrd.gz
" >> $WORK/boot/isolinux/isolinux.cfg
fi
#END PUPPY2 ENTRY#
if [ -f riplinux.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label riplinux
menu label ^RIPLinuX
com32 menu.c32
append riplinux.cfg
EOF
cat >> multicd-working/boot/isolinux/riplinux.cfg << "EOF"
DEFAULT menu.c32
PROMPT 0
MENU TITLE RIPLinuX v6.7

LABEL Boot Linux system! (32-bit kernel)
KERNEL /boot/riplinux/kernel32
APPEND vga=normal initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system! (skip keymap prompt)
KERNEL /boot/riplinux/kernel32
APPEND vga=normal nokeymap initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system to X! (32-bit kernel)
KERNEL /boot/riplinux/kernel32
APPEND vga=normal xlogin initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system to X! (skip keymap prompt)
KERNEL /boot/riplinux/kernel32
APPEND vga=normal xlogin nokeymap initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system! (64-bit kernel)
KERNEL /boot/riplinux/kernel64
APPEND vga=normal initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system! (skip keymap prompt)
KERNEL /boot/riplinux/kernel64
APPEND vga=normal nokeymap initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system to X! (64-bit kernel)
KERNEL /boot/riplinux/kernel64
APPEND vga=normal xlogin initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Boot Linux system to X! (skip keymap prompt)
KERNEL /boot/riplinux/kernel64
APPEND vga=normal xlogin nokeymap initrd=/boot/riplinux/rootfs.cgz root=/dev/ram0 rw

LABEL Edit and put Linux partition to boot! (32-bit kernel)
KERNEL /boot/riplinux/kernel
APPEND vga=normal ro root=/dev/XXXX

LABEL Edit and put Linux partition to boot! (64-bit kernel)
KERNEL /boot/riplinux/kernel64
APPEND vga=normal ro root=/dev/XXXX

LABEL Boot memory tester!
KERNEL /boot/memtest
APPEND -

LABEL Boot GRUB bootloader!
KERNEL /boot/riplinux/grub4dos/grub.exe
APPEND --config-file=(cd)/boot/riplinux/grub4dos/menu-cd.lst

LABEL Boot MBR on first hard drive!
KERNEL chain.c32
APPEND hd0 0

LABEL Boot partition #1 on first hard drive!
KERNEL chain.c32
APPEND hd0 1

LABEL Boot partition #2 on first hard drive!
KERNEL chain.c32
APPEND hd0 2

LABEL Boot partition #3 on first hard drive!
KERNEL chain.c32
APPEND hd0 3

LABEL Boot partition #4 on first hard drive!
KERNEL chain.c32
APPEND hd0 4

LABEL Boot MBR on second hard drive!
KERNEL chain.c32
APPEND hd1 0

LABEL Boot partition #1 on second hard drive!
KERNEL chain.c32
APPEND hd1 1

LABEL Boot partition #2 on second hard drive!
KERNEL chain.c32
APPEND hd1 2

LABEL Boot partition #3 on second hard drive!
KERNEL chain.c32
APPEND hd1 3

LABEL Boot partition #4 on second hard drive!
KERNEL chain.c32
APPEND hd1 4

label back
menu label Back to main menu
com32 menu.c32
append isolinux.cfg
EOF
fi
#BEGIN SLAX ENTRY#
if [ -f slax.iso ];then
if [ -f $WORK/slax/base/002-desktop.sq4.lzm ];then
if [ -f slax.version ] && [ "$(cat slax.version)" != "" ];then
	SLAXVER=" $(cat slax.version)"
else
	SLAXVER=""
fi
echo "LABEL xconf
MENU LABEL ^Slax$SLAXVER Graphics mode (KDE)
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.lz ramdisk_size=6666 root=/dev/ram0 rw vga=791 splash=silent quiet autoexec=xconf;telinit~4  changes=/slax/

LABEL lxde
MENU LABEL Slax$SLAXVER (LXDE) (if available)
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.lz ramdisk_size=6666 root=/dev/ram0 rw vga=791 splash=silent quiet autoexec=lxde;xconf;telinit~4 changes=/slax/

LABEL copy2ram
MENU LABEL Slax$SLAXVER Graphics mode, Copy To RAM
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.lz ramdisk_size=6666 root=/dev/ram0 rw vga=791 splash=silent quiet copy2ram autoexec=xconf;telinit~4

LABEL startx
MENU LABEL Slax$SLAXVER Graphics VESA mode
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.lz ramdisk_size=6666 root=/dev/ram0 rw autoexec=telinit~4  changes=/slax/

LABEL slax
MENU LABEL Slax$SLAXVER Text mode
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.lz ramdisk_size=6666 root=/dev/ram0 rw  changes=/slax/" >> $WORK/boot/isolinux/isolinux.cfg
elif [ -f $WORK/slax/base/002-xorg.lzm ];then
echo "LABEL xconf
MENU LABEL ^Slax$SLAXVER Graphics mode (KDE)
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.gz ramdisk_size=6666 root=/dev/ram0 rw autoexec=xconf;telinit~4  changes=/slax/

LABEL copy2ram
MENU LABEL Slax$SLAXVER Graphics mode, Copy To RAM
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.gz ramdisk_size=6666 root=/dev/ram0 rw copy2ram autoexec=xconf;telinit~4

LABEL startx
MENU LABEL Slax$SLAXVER Graphics VESA mode
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.gz ramdisk_size=6666 root=/dev/ram0 rw autoexec=telinit~4  changes=/slax/

LABEL slax
MENU LABEL Slax$SLAXVER Text mode
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.gz ramdisk_size=6666 root=/dev/ram0 rw  changes=/slax/" >> $WORK/boot/isolinux/isolinux.cfg
else
echo "LABEL slax
MENU LABEL ^Slax$SLAXVER Text mode
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.$SUFFIX ramdisk_size=6666 root=/dev/ram0 rw  changes=/slax/

LABEL slax2ram
MENU LABEL Slax$SLAXVER Text mode, Copy To RAM
KERNEL /boot/slax/vmlinuz
APPEND initrd=/boot/slax/initrd.$SUFFIX ramdisk_size=6666 root=/dev/ram0 rw copy2ram" >> $WORK/boot/isolinux/isolinux.cfg
fi
fi
#END SLAX ENTRY#
if [ -f slitaz.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label slitaz
	menu label ^SliTaz GNU/Linux
	kernel /boot/slitaz/bzImage
	append initrd=/boot/slitaz/rootfs.gz rw root=/dev/null vga=normal
EOF
fi
if [ -f sysrcd.iso ];then
VERSION=$(cat multicd-working/boot/sysrcd/version)
echo "menu begin --> ^System Rescue Cd ($VERSION)

label rescuecd0
menu label ^SystemRescueCd 32-bit
kernel /boot/sysrcd/rescuecd
append initrd=/boot/sysrcd/initram.igz subdir=/boot/sysrcd
label rescuecd1
menu label SystemRescueCd 64-bit
kernel /boot/sysrcd/rescue64
append initrd=/boot/sysrcd/initram.igz subdir=/boot/sysrcd
label rescuecd2
menu label SystemRescueCd 32-bit (alternate kernel)
kernel /boot/sysrcd/altker32
append initrd=/boot/sysrcd/initram.igz video=ofonly subdir=/boot/sysrcd
label rescuecd3
menu label SystemRescueCd 64-bit (alternate kernel)
kernel /boot/sysrcd/altker64
append initrd=/boot/sysrcd/initram.igz video=ofonly subdir=/boot/sysrcd
label rescuecd-rootauto
menu label SysRCD: rescue installed Linux (root=auto; 32-bit)
kernel /boot/sysrcd/rescuecd
append initrd=/boot/sysrcd/initram.igz root=auto subdir=/boot/sysrcd

label back
menu label Back to main menu
com32 menu.c32
append isolinux.cfg

menu end" >> multicd-working/boot/isolinux/isolinux.cfg
fi
#BEGIN TCNET ENTRY#
if [ -f tcnet.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label tcnet-hdc
	menu label ^Boot TCNet (128 MB RAM or less; CD drive must be IDE secondary master)
	kernel /boot/bzImage
	append initrd=/boot/tcnet.gz max_loop=255 norestore tce=hdc/tcnet
label tcnet-full
	menu label ^Boot TCNet (192 MB RAM or more; everything loaded to RAM)
	kernel /boot/bzImage
	append initrd=/boot/tcntfull.gz max_loop=255 norestore base
EOF
fi
#END TCNET ENTRY#
#BEGIN TINY CORE ENTRY#
if [ -f tinycore.iso ];then
	if [ -f $TAGS/tinycore.name ] && [ "$(cat $TAGS/tinycore.name)" != "" ];then
		TCNAME=$(cat $TAGS/tinycore.name)
	elif [ -f tinycore.defaultname ] && [ "$(cat tinycore.defaultname)" != "" ];then
		TCNAME=$(cat tinycore.defaultname)
	else
		TCNAME="Tiny Core Linux"
	fi
	if [ -f tinycore.version ] && [ "$(cat tinycore.version)" != "" ];then
		TCNAME="$TCNAME $(cat tinycore.version)"
	fi
	for i in $(ls $WORK/boot/tinycore|grep '\.gz');do
		echo "label tinycore-$i
		menu label ^$TCNAME
		kernel /boot/tinycore/bzImage
		append quiet
		initrd /boot/tinycore/$(basename $i)">>multicd-working/boot/isolinux/isolinux.cfg
	done
fi
#END TINY CORE ENTRY#
#BEGIN TINY CORE 2 ENTRY#
if [ -f tinycore2.iso ];then
	if [ -f $TAGS/tinycore2.name ] && [ "$(cat $TAGS/tinycore2.name)" != "" ];then
		TCNAME=$(cat $TAGS/tinycore2.name)
	elif [ -f tinycore2.defaultname ] && [ "$(cat tinycore2.defaultname)" != "" ];then
		TCNAME=$(cat tinycore2.defaultname)
	else
		TCNAME="Tiny Core Linux #2"
	fi
	if [ -f tinycore2.version ] && [ "$(cat tinycore2.version)" != "" ];then
		TCNAME="$TCNAME $(cat tinycore2.version)"
	fi
	for i in $(ls $WORK/boot/tinycore2|grep '\.gz');do
		echo "label tinycore2-$i
		menu label ^$TCNAME
		kernel /boot/tinycore2/bzImage
		append quiet
		initrd /boot/tinycore2/$(basename $i)">>multicd-working/boot/isolinux/isolinux.cfg
	done
fi
#END TINY CORE 2 ENTRY#
if [ -f tinyme.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label LiveCD
    menu label ^TinyMe - LiveCD
    kernel /boot/tinyme/vmlinuz
    append livecd=livecd initrd=/boot/tinyme/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,noauto
label VideoSafeModeFBDev
    menu label TinyMe - VideoSafeModeFBDev
    kernel /boot/tinyme/vmlinuz
    append livecd=livecd initrd=/boot/tinyme/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,noauto framebuffer
label VideoSafeModeVesa
    menu label TinyMe - VideoSafeModeVesa
    kernel /boot/tinyme/vmlinuz
    append livecd=livecd initrd=/boot/tinyme/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,noauto vesa
label Safeboot
    menu label TinyMe - Safeboot
    kernel /boot/tinyme/vmlinuz
    append livecd=livecd initrd=/boot/tinyme/initrd.gz root=/dev/rd/3 acpi=off vga=normal keyb=us noapic nolapic noscsi nopcmcia
label Console
    menu label TinyMe - Console
    kernel /boot/tinyme/vmlinuz
    append livecd=livecd 3 initrd=/boot/tinyme/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,noauto
label Copy2ram
    menu label TinyMe - Copy2ram
    kernel /boot/tinyme/vmlinuz
    append livecd=livecd copy2ram initrd=/boot/tinyme/initrd.gz root=/dev/rd/3 acpi=on vga=788 keyb=us splash=silent fstab=rw,noauto splash=verbose
EOF
fi
if [ -f trk.iso ];then
echo "label trk
menu label --> ^Trinity Rescue Kit
com32 vesamenu.c32
append trk.menu
" >> $WORK/boot/isolinux/isolinux.cfg
#REQUIRES GNU sed to work (usage of -i option.)
sed -i -e 's^bootlogo.jpg^trklogo.jpg^g' $WORK/boot/isolinux/trk.menu
sed -i -e 's^kernel kernel.trk^kernel /boot/trinity/kernel.trk^g' $WORK/boot/isolinux/trk.menu
sed -i -e "s^initrd=initrd.trk^initrd=/boot/trinity/initrd.trk vollabel=$CDLABEL^g" $WORK/boot/isolinux/trk.menu #This line both changes the initrd path and adds the volume label argument ($CDLABEL is set [exported] in multicd.sh)
sed -i '/^label t$/d' $WORK/boot/isolinux/trk.menu #Remove memtest part1
sed -i '/Memory tester/d' $WORK/boot/isolinux/trk.menu #Remove memtest part2
sed -i '/memtest/d' $WORK/boot/isolinux/trk.menu #Remove memtest part3
echo "
label back
menu label ^Back to main menu
com32 menu.c32
append isolinux.cfg" >> $WORK/boot/isolinux/trk.menu
fi
if [ -f ubcd.iso ];then
VERSION=$(cat ubcdver.tmp.txt)
rm ubcdver.tmp.txt
echo "label ubcd
menu label --> ^Ultimate Boot CD ($VERSION) - Main menu
com32 menu.c32
append /ubcd/menus/isolinux/main.cfg" >> multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f ubuntu-mini.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
LABEL uinstall
menu label Install ^Ubuntu
	kernel /boot/ubuntu/linux
	append vga=normal initrd=/boot/ubuntu/initrd.gz -- 
LABEL ucli
menu label Install Ubuntu (CLI)
	kernel /boot/ubuntu/linux
	append tasks=standard pkgsel/language-pack-patterns= pkgsel/install-language-support=false vga=normal initrd=/boot/ubuntu/initrd.gz -- 

LABEL uexpert
menu label Install Ubuntu - expert mode
	kernel /boot/ubuntu/linux
	append priority=low vga=normal initrd=/boot/ubuntu/initrd.gz -- 
LABEL ucli-expert
menu label Install Ubuntu (CLI) - expert mode
	kernel /boot/ubuntu/linux
	append tasks=standard pkgsel/language-pack-patterns= pkgsel/install-language-support=false priority=low vga=normal initrd=/boot/ubuntu/initrd.gz -- 
EOF
fi
if [ "*.ubuntu.iso" != "$(echo *.ubuntu.iso)" ];then for i in *.ubuntu.iso; do

BASENAME=$(echo $i|sed -e 's/\.iso//g')
if [ -f $TAGS/$BASENAME.name ] && [ "$(cat $TAGS/$BASENAME.name)" != "" ];then #Same chunk of code as above...
	UBUNAME="$(cat $TAGS/$BASENAME.name)"
else
	UBUNAME=$(echo $i|sed -e 's/\.ubuntu\.iso//g')
fi #...ends here

if [ -f $BASENAME.version ] && [ "$(cat $BASENAME.version)" != "" ] \
&& [ "$(cat $TAGS/$BASENAME.name)" == "$(cat $BASENAME.defaultname)" ];then
	VERSION=" $(cat $BASENAME.version)" #Version based on isoaliases()
else
	VERSION=""
fi

echo "label ubuntu
menu label --> $UBUNAME$VERSION Menu
com32 menu.c32
append /boot/$BASENAME/$BASENAME.cfg
" >> multicd-working/boot/isolinux/isolinux.cfg
echo "label back
menu label Back to main menu
com32 menu.c32
append /boot/isolinux/isolinux.cfg
" >> multicd-working/boot/$BASENAME/$BASENAME.cfg
done;fi
if [ -f vyatta.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label vyatta-live
	menu label ^Vyatta - Live
	kernel /Vyatta/vmlinuz1
	append console=ttyS0 console=tty0 quiet initrd=/Vyatta/initrd1.img boot=live nopersistent noautologin nonetworking nouser hostname=vyatta live-media-path=/Vyatta
label vyatta-console
	menu label ^Vyatta - VGA Console
	kernel /Vyatta/vmlinuz1
	append quiet initrd=/Vyatta/initrd1.img boot=live nopersistent noautologin nonetworking nouser hostname=vyatta live-media-path=/Vyatta
label vyatta-serial
	menu label ^Vyatta - Serial Console
	kernel /Vyatta/vmlinuz1
	append console=ttyS0 quiet initrd=/Vyatta/initrd1.img boot=live nopersistent noautologin nonetworking nouser hostname=vyatta live-media-path=/Vyatta
label vyatta-debug
	menu label ^Vyatta - Debug
	kernel /Vyatta/vmlinuz1
	append console=ttyS0 console=tty0 debug verbose initrd=/Vyatta/initrd1.img boot=live nopersistent noautologin nonetworking nouser hostname=vyatta  live-media-path=/Vyatta
EOF
fi
if [ -f weaknet.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
LABEL live
  menu label ^WeakNet Linux (live)
  kernel /boot/weaknet/vmlinuz
  append  file=/cdrom/preseed/custom.seed boot=casper initrd=/boot/weaknet/initrd.gz quiet splash ignore_uuid --
LABEL xforcevesa
  menu label WeakNet Linux (safe graphics mode)
  kernel /boot/weaknet/vmlinuz
  append  file=/cdrom/preseed/custom.seed boot=casper xforcevesa initrd=/boot/weaknet/initrd.gz quiet splash ignore_uuid --
LABEL install
  menu label Install WeakNet Linux
  kernel /boot/weaknet/vmlinuz
  append  file=/cdrom/preseed/custom.seed boot=casper only-ubiquity initrd=/boot/weaknet/initrd.gz quiet splash ignore_uuid --
EOF
fi
if [ -f win7recovery.iso ];then
echo "label win7recovery
menu label Windows ^7 Recovery Disc
kernel chain.c32
append boot ntldr=/bootmgr">>multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f win98se.iso ];then
echo "label win98se
menu label ^Windows 98 Second Edition Setup
kernel memdisk
initrd /boot/win98se.img">>multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f winme.iso ];then
echo "label winme
menu label ^Windows Me Setup
kernel memdisk
initrd /boot/winme.img">>multicd-working/boot/isolinux/isolinux.cfg
fi
if [ -f wolvix.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label wolvix
menu label ^Wolvix GNU/Linux (login as root, password is toor)
kernel /boot/vmlinuz
append changes=wolvixsave.xfs max_loop=255 initrd=/boot/initrd.gz ramdisk_size=6666 root=/dev/ram0 rw vga=791 splash=silent
EOF
fi
#END WRITE

#BEGIN DISK IMAGE ENTRY#
j="0"
for i in *.im[agz]; do
	test -r "$i" || continue
	BASICNAME=$(echo $i|sed 's/\.im.//')
	echo label "$BASICNAME" >> $WORK/boot/isolinux/isolinux.cfg
	echo kernel memdisk >> $WORK/boot/isolinux/isolinux.cfg
	echo initrd /boot/$j.img >> $WORK/boot/isolinux/isolinux.cfg
	j=$( expr $j + 1 )
done
#END DISK IMAGE ENTRY#

#BEGIN GRUB4DOS ENTRY#
if [ -f $WORK/boot/grub.exe ];then
echo "label grub4dos
menu label ^GRUB4DOS
kernel /boot/grub.exe">>$WORK/boot/isolinux/isolinux.cfg
elif [ -f $WORK/boot/riplinux/grub4dos/grub.exe ];then
echo "label grub4dos
menu label ^GRUB4DOS
kernel /boot/riplinux/grub4dos/grub.exe">>$WORK/boot/isolinux/isolinux.cfg
fi
#END GRUB4DOS ENTRY#

#BEGIN GAMES ENTRY#
if [ $GAMES = 1 ];then
echo "label games
menu label ^Games on disk images
com32 menu.c32
append games.cfg">>$WORK/boot/isolinux/isolinux.cfg
fi
#END GAMES ENTRY#

#BEGIN MEMTEST ENTRY#
if [ -f $WORK/boot/memtest ];then
echo "label memtest
menu label ^Memtest86+
kernel /boot/memtest">>$WORK/boot/isolinux/isolinux.cfg
fi
#END MEMTEST ENTRY#
##END ISOLINUX MENU CODE##

if [ $GAMES = 1 ];then
k="0"
cat > $WORK/boot/isolinux/games.cfg << "EOF"
default menu.c32
timeout 300

menu title "Choose a game to play:"
EOF
for i in games/*.im[agz]; do
	test -r "$i" || continue
	BASICNAME=$(echo $i|sed 's/\.im.//'|sed 's/games\///')
	echo label "$BASICNAME" >> $WORK/boot/isolinux/games.cfg
	echo kernel memdisk >> $WORK/boot/isolinux/games.cfg
	echo initrd /boot/games/$k.img >> $WORK/boot/isolinux/games.cfg
	k=$( expr $k + 1 )
done
echo "label back
menu label Back to main menu
com32 menu.c32
append isolinux.cfg">>$WORK/boot/isolinux/games.cfg
fi

if [ -d includes ];then
 echo "Copying includes..."
 cp -r includes/* $WORK/
fi

if $WAIT;then
	chmod -R a+w $WORK/boot/isolinux #So regular users can edit menus
	echo "    Dropping to root prompt. Type \"exit\" to build the ISO image."
	echo "    Don't do anything hasty."
	echo "PS1=\"    mcd waiting# \"">/tmp/mcdprompt
	bash --rcfile /tmp/mcdprompt || sh
	rm /tmp/mcdprompt || true
fi

if $MD5;then
 echo "Generating MD5 checksums..."
 if $VERBOSE;then
	find $WORK/ -type f -not -name md5sum.txt -not -name boot.cat -not -name isolinux.bin \
	-exec md5sum '{}' \; | sed "s^$WORK^^g" | tee $WORK/md5sum.txt
 else
	find $WORK/ -type f -not -name md5sum.txt -not -name boot.cat -not -name isolinux.bin\
	-exec md5sum '{}' \; | sed "s^$WORK^^g" > $WORK/md5sum.txt
 fi
fi

if which genisoimage > /dev/null;then
 GENERATOR="genisoimage"
elif which mkisofs > /dev/null;then
 GENERATOR="mkisofs"
else
 echo "Neither genisoimage nor mkisofs was found."
 exit 1
fi
EXTRAARGS=""
if ! $VERBOSE;then
	EXTRAARGS="$EXTRAARGS -quiet"
fi
if [ ! -f $TAGS/win9x ];then
	EXTRAARGS="$EXTRAARGS -iso-level 4" #To ensure that Windows 9x installation CDs boot properly
fi
echo "Building CD image..."
$GENERATOR -o multicd.iso \
-b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
-r -J $EXTRAARGS \
-V "$CDLABEL" $WORK/
rm -r $WORK/
if [ -f isohybrid ];then
	./isohybrid multicd.iso || true
	rm isohybrid
else
	isohybrid multicd.iso || true
fi
chmod 666 multicd.iso
rm -r $TAGS
#END SCRIPTwget -
