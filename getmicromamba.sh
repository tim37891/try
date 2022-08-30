#!/bin/bash
curl micro.mamba.pm/install.sh | bash
micromamba activate
micromamba install -c condaforge gh git gnupg
