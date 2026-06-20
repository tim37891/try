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
# Assuming root or sudo access
sudo -l &>/dev/null || { echo "No sudo access."; exit 1; }
set -euo pipefail
#####################################################################################
# system update
sudo apt-get update -y -qq
sudo apt-get install -y -qq gnupg pinentry-tty
#####################################################################################
# gpg setup
# ##########
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
echo "pinentry-program /usr/bin/pinentry-tty" > ~/.gnupg/gpg-agent.conf
chown -R "$USER:$USER" ~/.gnupg/
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
gpg-connect-agent reloadagent /bye
#######################################################################################
# gh install and git setup
# #########
(type -p wget >/dev/null || (sudo apt-get update -y -qq && sudo apt-get install wget -y -qq)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt-get update -y -qq \
	&& sudo apt-get install gh -y -qq

read -p "-= [ Press Enter to continue ] =-"
TOKEN=$(gpg --pinentry-mode loopback --no-symkey-cache -d "$GPGF") && echo "$TOKEN" | gh auth login --with-token
gh auth setup-git
#######################################################################################
cd ~/src
git clone https://github.com/tim37891/$REPON.git
rm -rf try
git clone https://github.com/tim37891/try.git
# #####################################################################################
echo -e "\n❯ cd ~/src/$REPON;bash 03_coldstart.sh"
