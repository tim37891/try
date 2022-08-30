#!/bin/bash
curl micro.mamba.pm/install.sh | bash
echo "micromamba activate" >> ~/.bashrc
# Restart
exec bash
micromamba install -c conda-forge mamba
mamba install --yes --quiet -c conda-forge gh git gnupg
