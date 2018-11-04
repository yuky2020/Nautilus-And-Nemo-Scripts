#!/bin/bash
sudo -k
gksu chmod 700 "$1"
sudo chown -R root:root "$1"
sudo -k
