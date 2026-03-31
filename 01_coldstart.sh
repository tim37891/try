#!/usr/bin/env bash
#####################################################################################
# sudo apt-get update -qq
# sudo apt-get install y -qq git
# cd ~
# git clone https://github.com/tim37891/try.git
# cd ~/try
# bash 01_coldstart.sh
#####################################################################################
#####################################################################################
#####################################################################################
# VPS Security Setup — Ubuntu 24.04 (Netcup)
# Assuming root or sudo no passwd user
sudo -l &>/dev/null || { echo "No sudo access."; exit 1; }
#####################################################################################
set -euo pipefail
TIMEZONE="America/New_York"
# TIMEZONE="America/Los_Angeles"
sudo timedatectl set-timezone "$TIMEZONE"
#####################################################################################
# new user setup
#####################################################################################
read -e -p "Please enter the username for your new user: " NEW_USER_NAME
sudo adduser --disabled-password --gecos "" ${NEW_USER_NAME}
sudo usermod -aG sudo ${NEW_USER_NAME}
echo "$NEW_USER_NAME  ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/init_${NEW_USER_NAME} > /dev/null
sudo su --login --pty ${NEW_USER_NAME}
#####################################################################################
