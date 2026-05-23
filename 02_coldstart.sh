#!/usr/bin/env bash
#####################################################################################
# git clone https://github.com/tim37891/try.git
# cd ~/try
# bash 02_coldstart.sh
#####################################################################################
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <gpg file> <repo name>"
  exit 1
fi
GPGF=$1
REPON=$2
#####################################################################################
# VPS Security Setup — Setup Git
# Assuming root or sudo access
sudo -l &>/dev/null || { echo "No sudo access."; exit 1; }
set -euo pipefail
#####################################################################################
# system update
sudo apt-get update -y -qq
sudo apt-get upgrade -y -qq 
sudo apt-get autoremove -y -qq
sudo apt-get install -y -qq git gnupg pinentry-tty openssh-client openssh-server curl
#####################################################################################
# gpg setup
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
echo "pinentry-program /usr/bin/pinentry-tty" > ~/.gnupg/gpg-agent.conf
chown -R "$USER:$USER" ~/.gnupg/
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
gpg-connect-agent reloadagent /bye
#####################################################################################
# ssh setup
mkdir -p ~/.ssh
chmod 700 ~/.ssh
read -p "-= [ Press Enter to continue ] =-"
gpg --no-symkey -d $GPGF>  ~/.ssh/github
####################################################################################
if ! grep -q "Host github.com" ~/.ssh/config 2>/dev/null; then
    cat >> ~/.ssh/config << EOF

Host github.com
  User git
  IdentityFile ~/.ssh/github
  IdentitiesOnly yes
  AddKeysToAgent yes
EOF
fi
find ~/.ssh -type f -exec chmod 600 {} \;
find ~/.ssh -type d -exec chmod 700 {} \;
###################################################################################################
# git use
###############################################################################################
#ssh -y -T git@github.com
mkdir -p ~/src
cd ~/src
git clone git@github.com:tim37891/$REPON.git
#####################################################################################
echo -e "\n❯ cd ~/src/$REPON/coldstart;bash 03_coldstart.sh"
