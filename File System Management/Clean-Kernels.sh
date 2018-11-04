#!/usr/bin/env bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
sudo $0 "$@"
exit
fi

ls /boot/ | grep vmlinuz | sed 's@vmlinuz-@linux-image-@g' | grep -v `uname -r` /tmp/kernelList
for I in `cat /tmp/kernelList`
do
printf "Uninstalling ${I}...\n\n"
apt-get -y purge $I
printf "\n\n"
done
rm -f /tmp/kernelList

printf "Updating grub...\n\n"
update-grub
