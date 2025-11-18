#!/bin/bash
#####################################################################################
# system update
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y git gnupg pinentry-tty openssh-client openssh-server
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
