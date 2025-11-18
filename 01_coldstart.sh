#!/bin/bash
# cd ~
# git clone https://github.com/tim37891/try.git
#####################################################################################
# system update
#####################################################################################
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y git gnupg pinentry-tty openssh-client openssh-server
#####################################################################################
# new user setup
#####################################################################################
NEW_USER_NAME=$1
sudo adduser --disabled-password --gecos "" ${NEW_USER_NAME}
sudo usermod -aG sudo ${NEW_USER_NAME}
sudo su --login --pty ${NEW_USER_NAME}
#####################################################################################
