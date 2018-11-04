#!/bin/bash
S1='b'
S2='y'
echo "Please enter b for backup or r for restore:"
read action

if [ $action = $S1 ]; then 
    
    echo "These Directories will be excluded:"
    echo -e "\033[1m\033[32m /proc /lost+found */backup.tgz /mnt /sys /dev"
    echo -e "\033[0m"
    echo "To chance these values edit this shell"
    echo "continue (y/n):"
        
    read action
    if [ $action = $S2 ]; then 
        echo "Backing up PC ~ timestamp " ;date
        tar cpzf backup.tgz --exclude=/proc --exclude=/lost+found --exclude=*/backup.tgz --exclude=/mnt --exclude=/sys  /
    fi
else
    echo -e "\033[1m\033[31mWARNING: this will overwrite every single file on your partition with the one in the archive!"    
    echo -e "\033[0m"    
    echo "Please enter name and location of the archive to restore:"        
    read fileName
    echo "You are about to restore $fileName do you want to continue?(y/n)"
    read action
    echo -e "\033[1m\033[47mJust sit back and watch the fireworks.This might take a while. When it is done, you have a fully restored Ubuntu system!"
    sleep 5
    echo "start"
    if [ $action = $S2 ]; then 
        tar xvpfz $fileName -C /
        echo "Creating excluded directories"    
        #Just to make sure that all excluded directories are re-created
        mkdir /proc
        mkdir /lost+found
        mkdir /mnt
        mkdir /sys
        
    fi    
fi
echo -e "\033[0m"
