gpg --no-symkey --pinentry-mode loopback -d | gh auth login --with-token
gh auth setup-git
git config --global user.email "you@example.com"
git config --global user.name "Your Name"


