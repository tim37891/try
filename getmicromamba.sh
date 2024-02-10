#!/bin/bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
echo "micromamba activate" >> ~/.bashrc
# Restart
source ~/.bashrc
micromamba install -c conda-forge gh git gnupg
