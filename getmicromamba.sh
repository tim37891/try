#!/bin/bash
curl micro.mamba.pm/install.sh | bash
# Restart
micromamba activate
micromamba install -c conda-forge gh git gnupg
