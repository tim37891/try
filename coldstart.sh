#!/bin/bash
#### system update
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt install -y git gnupg pinentry-tty
#### new user setup
NEW_USER_NAME=$1
sudo adduser --disabled-password --gecos "" ${NEW_USER_NAME}
sudo usermod -aG sudo ${NEW_USER_NAME}
sudo su ${NEW_USER_NAME}
### gpg setup
mkdir -p ~/.gnupg
echo "pinentry-program /usr/bin/pinentry-tty" >> ~/.gnupg/gpg-agent.conf
gpg-connect-agent reloadagent /bye
## git setup




