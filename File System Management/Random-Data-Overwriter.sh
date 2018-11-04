#!/bin/bash

# The author of this script, Elias Amaral,
# claims no copyright over it.

# http://iamstealingideas.wordpress.com/2010/05/20/writing-random-data-to-a-hard-drive-again

msg() {
  printf "\n - $1\n\n" $2
}

mbs=4 # 4mb
blocksize=$(($mbs * 1024 * 1024))

dev=$1

if [[ -z $dev ]]; then
  msg "usage: $0 <device>"; exit
elif [[ ! -b $dev ]]; then
  msg "$dev: not a block device"; exit
elif [[ ! -w $dev ]]; then
  msg "$dev: no write permission"; exit
elif grep -q $dev /etc/mtab; then
  msg "$dev: mounted filesystem on device, omgomg!"; exit
fi

cat <<end
This program writes random data to a hard disk.
It is intended to be used before storing encrypted data.
It may contain bugs (but seems to work for me).

It seems you have chosen to wipe data from the disk $dev.
Here is the partition table of this disk:
end

fdisk -l $dev

echo
echo 'Are you sure you want to proceed?'

msg 'WARNING: IT WILL DESTROY ALL DATA ON THE DISK'

read -p 'Type uppercase yes if you want to proceed: ' q

if [[ $q != YES  ]]; then
  exit
fi

while
  echo $i > step.new
  mv step.new step

  msg 'Writing at offset %s' $(($mbs * $i))M

  openssl rand \
          -rand /dev/urandom \
          $blocksize | \

  dd of=$dev \
     bs=$blocksize \
     seek=$i
do
  let i++
done

msg Finished.
