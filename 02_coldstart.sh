#!/bin/bash
#####################################################################################
# sudo apt update -y
# sudo apt install -y git
# cd ~
# git clone https://github.com/tim37891/try.git
#####################################################################################
# system update
#####################################################################################
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y gnupg pinentry-tty openssh-client openssh-server
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
gpg --no-symkey -d $1 | ssh-add -
ssh -y -T git@github.com
cd ~
git clone git@github.com:tim37891/$2.git
#####################################################################################
