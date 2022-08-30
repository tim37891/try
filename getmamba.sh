#!/bin/bash
# curl -L -O
wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x86_64.sh -b
rm Mambaforge-Linux-x86_64.sh
~/mambaforge/bin/mamba install --quiet --yes \
    'gnupg' \
    'git' \
    'gh'
~/mambaforge/bin/mamba init bash
exec bash
