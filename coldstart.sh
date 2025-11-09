#!/bin/bash
#####################################################################################
# system update
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y git gnupg pinentry-tty openssh-client openssh-server
#####################################################################################
# new user setup
NEW_USER_NAME=$1
sudo adduser --disabled-password --gecos "" ${NEW_USER_NAME}
sudo usermod -aG sudo ${NEW_USER_NAME}
sudo su --login --pty ${NEW_USER_NAME}
cd ~
git clone https://github.com/tim37891/try.git
#####################################################################################
# gpg setup
mkdir -p ~/.gnupg
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
chown -R $(whoami) ~/.gnupg/
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg
gpg-connect-agent reloadagent /bye
#####################################################################################
# git setup
eval "$(ssh-agent -s)"
gpg --no-symkey -d $2 | ssh-add -
ssh -T git@github.com
git clone git@github.com:tim37891/$3.git
#####################################################################################
