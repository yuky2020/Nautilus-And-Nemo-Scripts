#!/bin/bash
sudo -k
gksu "chmod -R 777 '$1'"
gksu "chown -R $USER:$USER '$1'"
sudo -k
