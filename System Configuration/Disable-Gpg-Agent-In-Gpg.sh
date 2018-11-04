#!/bin/bash
# disable gpg-agent in gpg.conf
user=`whoami`
sed -i 's/^\(use-agent.*\)/\#\1/' /home/$user/.gnupg/gpg.conf
