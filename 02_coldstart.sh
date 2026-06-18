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
sudo apt-get upgrade -y -qq
sudo apt-get autoremove -y -qq
sudo apt-get install -y -qq git gnupg pinentry-tty openssh-client openssh-server curl zsh fzf
#################################################
# zsh setup
#################################################
# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo chsh -s $(which zsh) $USER
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/^plugins=(.*)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
# fzf
grep -q "key-bindings.zsh" ~/.zshrc || cat >> ~/.zshrc <<'EOF'

# fzf
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
EOF
################################################
# Pixi
################################################
curl -fsSL https://pixi.sh/install.sh | sh
export PATH="${HOME}/.pixi/bin:${PATH}"
echo 'export PATH="${HOME}/.pixi/bin:${PATH}"' >> ~/.zshrc
pixi config set shell.change-ps1 false --global
# direnv
pixi global install direnv
mkdir -p ~/.config/direnv
touch ~/.config/direnv/direnv.toml
echo 'export DIRENV_LOG_FORMAT=' >> ~/.zshrc
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
################################################
# Starship
################################################
curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
starship preset plain-text-symbols -o ~/.config/starship.toml
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
#######################################################################################
# #####################################################################################
# # ssh setup
# mkdir -p ~/.ssh
# chmod 700 ~/.ssh
# read -p "-= [ Press Enter to continue ] =-"
# gpg --no-symkey -d $GPGF>  ~/.ssh/github
# ####################################################################################
# if ! grep -q "Host github.com" ~/.ssh/config 2>/dev/null; then
#     cat >> ~/.ssh/config << EOF

# Host github.com
#   User git
#   IdentityFile ~/.ssh/github
#   IdentitiesOnly yes
#   AddKeysToAgent yes
# EOF
# fi
# find ~/.ssh -type f -exec chmod 600 {} \;
# find ~/.ssh -type d -exec chmod 700 {} \;
# ###################################################################################################
# # git use
# ###############################################################################################
# #ssh -y -T git@github.com
# #mkdir -p ~/src
cd ~/src
git clone https://github.com/tim37891/$REPON.git
rm -rf try
git clone https://github.com/tim37891/try.git
# #####################################################################################
echo -e "\n❯ cd ~/src/$REPON;bash 03_coldstart.sh"
