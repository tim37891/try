#!/bin/bash
# sudo apt update -y
# sudo apt install -y git
# cd ~
# git clone https://github.com/tim37891/try.git
#####################################################################################
# new user setup
#####################################################################################
NEW_USER_NAME=$1
sudo adduser --disabled-password --gecos "" ${NEW_USER_NAME}
sudo usermod -aG sudo ${NEW_USER_NAME}
echo "$NEW_USER_NAME  ALL=(ALL:ALL) ALL" >> /etc/sudoers
sudo su --login --pty ${NEW_USER_NAME}
#####################################################################################
