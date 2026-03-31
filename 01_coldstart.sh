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
get_username() {
    while true; do
        read -e -p "Enter username for new user: " NEW_USER_NAME
        NEW_USER_NAME="${NEW_USER_NAME// /}"   # strip spaces
        NEW_USER_NAME="${NEW_USER_NAME,,}"     # force lowercase

        [[ -z "$NEW_USER_NAME" ]] \
            && { echo "  ✘ Cannot be empty."; continue; }

        [[ ! "$NEW_USER_NAME" =~ ^[a-z_][a-z0-9_-]{2,31}$ ]] \
            && { echo "  ✘ Invalid format."; continue; }

        id "$NEW_USER_NAME" &>/dev/null \
            && { echo "  ✘ User already exists."; continue; }

        break
    done
}
get_username
echo "  ✔ Username accepted: $NEW_USER_NAME"
#####################################################################################
sudo adduser --disabled-password --gecos "" "$NEW_USER_NAME"
sudo usermod -aG sudo "$NEW_USER_NAME"
echo "$NEW_USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$NEW_USER_NAME" > /dev/null
sudo su --login --pty ${NEW_USER_NAME}
#####################################################################################
