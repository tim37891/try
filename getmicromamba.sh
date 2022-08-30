#!/bin/bash
curl micro.mamba.pm/install.sh | bash
echo "micromamba activate" >> ~/.bashrc
# Restart
micromamba install -c conda-forge gh git gnupg
