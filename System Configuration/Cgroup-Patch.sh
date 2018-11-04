#!/bin/bash
# credits: superpiwi
# http://ubuntulife.wordpress.com/2010/11/22/el-parche-milagro-de-linux-ahora-con-script-de-instalacion/
# in English and with 3 small fixes by Andrew @ http://www.webupd8.org

YELLOW="\033[1;33m"
RED="\033[0;31m"
ENDCOLOR="\033[0m"

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# PATCH
#
# Apply the kernel enhancements (patch 200 lines)
# but in 4 lines of bash.
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function PATCH()
{

FILE="$HOME/.bashrc"

echo ""
echo -e $YELLOW"Patching [${FILE}]..."$ENDCOLOR
echo ""

# Adding chains. Bashrc

# First look for a string "base" to see whether or not it has already been added
LINES=`cat $FILE | grep "/dev/cgroup/cpu/user" | wc -l`
if [ "$LINES" == "0" ];
then
	echo "Adding the patch..."
	echo "if [ \"\$PS1\" ] ; then" | tee -a $FILE
	echo "mkdir -p -m 0700 /dev/cgroup/cpu/user/\$\$ > /dev/null 2>&1" | tee -a $FILE
	echo "echo \$\$ > /dev/cgroup/cpu/user/\$\$/tasks" | tee -a $FILE
	echo "echo \"1\" > /dev/cgroup/cpu/user/\$\$/notify_on_release" | tee -a $FILE
	echo "fi" | tee -a $FILE
else
	echo "It seems the patch is already included in $FILE"
fi

FILE="/etc/rc.local"
echo ""
echo -e $YELLOW"Patching [${FILE}]..."$ENDCOLOR
echo ""

# Adding strings to / etc / rc.local

# First look for a string "base" to see whether or not it has already been added
LINES=`cat $FILE | grep "/dev/cgroup/cpu/release_agent" | wc -l`
if [ "$LINES" == "0" ];
then

	echo "Adding the patch..."
	POSI=`cat $FILE | grep -n "exit 0" | sort -nr | head -n 1 | awk -F: '{print $1}'`
	#echo "Is possible [$POSI]"
	echo "Making backup of $FILE in /etc/rc.local.backup.txt"
	cp /etc/rc.local /etc/rc.local.backup.txt
	sed "${POSI}imkdir -p /dev/cgroup/cpu\nmount -t cgroup cgroup /dev/cgroup/cpu -o cpu\nmkdir -m 0777 /dev/cgroup/cpu/user\necho \"/usr/local/sbin/cgroup_clean\" > /dev/cgroup/cpu/release_agent" /etc/rc.local | tee /etc/rc.new.local
	mv /etc/rc.new.local /etc/rc.local

	#echo "#========== 200 lines kernel patch alternative ============" | tee -a $FILE
	#echo "mkdir -p /dev/cgroup/cpu" | tee -a $FILE
	#echo "mount -t cgroup cgroup /dev/cgroup/cpu -o cpu" | tee -a $FILE
	#echo "mkdir -m 0777 /dev/cgroup/cpu/user" | tee -a $FILE
	#echo "echo \"/usr/local/sbin/cgroup_clean\" > /dev/cgroup/cpu/release_agent" | tee -a $FILE
	#echo "#====================================" | tee -a $FILE
else
	echo "It seems the patch is already included in $FILE"
fi

echo ""
echo -e $YELLOW"Making [${FILE}] executable"$ENDCOLOR
echo ""
sudo chmod +x $FILE

FILE="/usr/local/sbin/cgroup_clean"
echo ""
echo -e $YELLOW"Creating [${FILE}]..."$ENDCOLOR
echo ""
if [ ! -e $FILE ];
then
	echo "#!/bin/sh" | tee $FILE
	echo "if [ \"\$*\" != \"/user\" ]; then" | tee -a $FILE
	echo "rmdir /dev/cgroup/cpu/\$*" | tee -a $FILE
	echo "fi" | tee -a $FILE

else
	echo "File $FILE already exists."
fi;

echo ""
echo -e $YELLOW"Making [${FILE}] executable"$ENDCOLOR
echo ""
sudo chmod +x $FILE

echo "DONE. The patch has been applied. Restart your computer..."

}
#-----------------------------------------------------------------------------

# Make sure you are root user
if [ $USER != root ]; then
  echo -e $RED"Error: you need to run this script as root."
  echo -e $YELLOW"Exiting..."$ENDCOLOR
  exit 0
fi

# System Patch
PATCH

# end of patch.sh
