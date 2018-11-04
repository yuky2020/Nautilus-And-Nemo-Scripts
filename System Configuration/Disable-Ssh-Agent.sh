#!/bin/bash
# disable ssh-agent from auto starting
sudo sed -i 's/^\(use-ssh-agent.*\)/\#\1/' /etc/X11/Xsession.options
sudo sed -i 's/^\(use-agent.*\)/\#\1/' /root/.gnupg/gpg.conf
