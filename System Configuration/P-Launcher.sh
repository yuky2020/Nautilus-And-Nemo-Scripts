#!/bin/bash
destination=$(pwd)
nkey="12"
returnstate="$destination/P-launcher.sh"
backupfolder="SoftwareBackup"
if [ ! -d $backupfolder ];
then
mkdir $backupfolder
fi
menuitem=`zenity --list --title="Installed Packages" \
--width=300 --height=260 \
--text="Select action" \
--column="Pick" --column="Modename" \
--radiolist TRUE Save-Packages FALSE View-Packages FALSE Upgrade-Packages FALSE Install-Packages FALSE Backup-Sources FALSE Create-HotKey`
case $menuitem in
Create-HotKey )
hkey=$(zenity --entry --text "Create Hot-Key (e.g. <Control>Q) and start using CTRL+Q" --entry-text "" --title "SET your Hot-Key")
if [ -z "$hkey" ]; then
zenity --error --title "SET your Hot-Key "   --text="The Hot-Key is empty."
exit 0
fi
gconftool-2 -t string -s /apps/metacity/global_keybindings/run_command_$nkey "$hkey"
gconftool-2 -t string -s /apps/metacity/keybinding_commands/command_$nkey "$destination/P-launcher.sh"
zenity --info  --width 170 --title "Application Hot Key"  --text "Your Hot-Key has been created"
sh $returnstate
;;
Backup-Sources)
gksudo cp /etc/apt/sources.list $destination/$backupfolder/sources.list.backup
sudo cp --recursive /etc/apt/sources.list.d $destination/$backupfolder/sources.list.d.backup
sudo cp /etc/apt/trusted.gpg $destination/$backupfolder/trusted.gpg.backup
zenity --info  --title "Backup Sources" --text "Your backup of sources has been saved in:\n\n$destination/$backupfolder"
sh $returnstate
;;
Install-Packages)
echo "How to installing packages from saved list?" > $destination/.installpackages
echo "--------------------------------------------------------------------------------------" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "Open terminal, cd to directory where your list is saved" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "Ckeck first if you have installed package: dselect, if not type:" >> $destination/.installpackages
echo "sudo apt-get install dselect" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "Start install packages from list running command:" >> $destination/.installpackages
echo "dpkg --set-selections < installed-software" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "After finish follow with command: dselect" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "--------------------------------------------------------------------------------------" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "Install list to other computer" >> $destination/.installpackages
echo "" >> $destination/.installpackages
echo "Copy first following:" >> $destination/.installpackages
echo "/etc/apt/sources.list | /etc/apt/sources.list.d | /etc/apt/trusted.gpg" >> $destination/.installpackages
echo "To do this, use our Backup-Sources option" >> $destination/.installpackages
echo "Move it to new computer" >> $destination/.installpackages
echo "Run the install list as described above" >> $destination/.installpackages
zenity --text-info  --title "Install Packages from list" --width 500 --height 550 --filename=$destination/.installpackages
sh $returnstate
;;
Save-Packages)
dpkg --get-selections > $backupfolder/installed-packages
zenity --info  --title "Saving Packages" --text "Your packages list is saved in:\n\n$destination/$backupfolder/installed-packages"
sh $returnstate
;;
Upgrade-Packages)
for lockinst in synaptic update-manager software-center apt-get dpkg aptitude
do
if ps -U root -u root u | grep $lockinst | grep -v grep > /dev/null;
then 
zenity --warning --title="Packages upgrade" --text="Upgrading won't work. Please close $lockinst first then try again."
sh $returnstate
exit
fi
done
gksudo "apt-get update"
commandlistu=$(aptitude -F '%?p' search '~U')
if [ -z "$commandlistu" ]; then
zenity --info  --width 200 --title "Packages to upgrade" --text "There are no packages for upgrade" 
sh $returnstate
exit
fi
if [ "$commandlistu" ]; then
zenity --question --text "Packages to upgrade\n$commandlistu"
tTest=$?
if [ "$tTest" -eq "1" ] ; then
sh $returnstate
exit 1
else
sudo apt-get -y --force-yes upgrade | zenity --progress --width 370 --height 180 --pulsate --title "Upgrading packages" --text "Upgrading...\nBe patient please,this can take time" --auto-close  
zenity --info  --width 200 --title "Status" --text "Done..."  
sh $returnstate
exit
fi
exit
fi
;;
View-Packages)
commandlist=$(aptitude -F '%?p %?V %?D' search '~i')
command=$(zenity --width=850 --height=480  --list --title="Installed Packages Viewer"  --column "Package Name" --column "Version Level"  --column "Size" $commandlist)
if [ -z "$command" ]; then
sh $returnstate
exit
fi
ans=`zenity  --width=600 --height=300 --list  --text "Package: $command"  \
--title="Man Pages / Package Content"  \
--column="Modename" --column "Select Action" --separator=";" \
Manual-Viewer            "View the manual page of package" \
Package-Content          "View the content of package" \
Package-Details          "View the details of package (author, architecture,depends etc..)" \
Package-Upgrade          "Try to upgrade or reinstall to latest version" \
Package-Remove          "Remove/Delete an installed package except configuration files" \
Package-Purge          "Remove/Delete everything including configuration files" `
case $ans in
Manual-Viewer)
checkcommand=$(man $command)
if [ -z "$checkcommand" ]; then
zenity --error --title "Manual Viewer"	 --text="The requested man page doe not exist."
sh $returnstate
exit;
fi
man $command | zenity --text-info --title "Manual Viewer" --width 850 --height 480
;;
Package-Content)
commandcontent=$(dpkg -L $command)
options=$(zenity  --width=850 --height=480 --list  --title "Package Content"   --column "Content" $commandcontent)
xdg-open $options
sh $returnstate
;;
Package-Details)
dpkg -p $command | zenity --text-info --title "Package Detailed Info" --width 850 --height 480
sh $returnstate
;;
Package-Upgrade)
gksudo "apt-get update"
sudo apt-get -y --force-yes install $command | zenity --progress --width 370 --height 180 --pulsate --title "Upgrading package components" --text "Upgrading...\nBe patient please." --auto-close  
zenity --info  --width 170 --title "Status" --text "Done..."
sh $returnstate
;;
Package-Remove)
gksudo "apt-get update"
sudo apt-get -y --force-yes remove $command | zenity --progress --width 370 --height 180 --pulsate --title "Removing package components" --text "Removing...\nBe patient please." --auto-close  
zenity --info  --width 170 --title "Status"  --text "Done..." 
sh $returnstate
;;
Package-Purge)
gksudo "apt-get update"
sudo apt-get -y --force-yes --purge remove $command | zenity --progress --width 370 --height 180 --pulsate --title "Removing package components" --text "Removing...\nBe patient please." --auto-close  
zenity --info  --width 170 --title "Status"  --text "Done..."
sh $returnstate
;;
esac
sh $returnstate
;;
esac
