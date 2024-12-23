#!/bin/bash

# NOTE: Because of the issue in related to stopping the container, see: 
# https://github.com/microsoft/vscode-remote-release/issues/3512#issuecomment-1267053890
# The following installation commands have to be executed within the timeframe
# set in the CMD command in the dockerfile.

# Uncomment the sections you need and add your own commands
# These are dependencies of tensorflow
# Note that cuda-pytorch image used already installs many of these tools

# Update system
apt-get update
apt-get upgrade -y

# Install Linux tools
apt-get install software-properties-common


# Z Shell Setup with p10k
export USERNAME=coder
sudo chown -R $USERNAME:$USERNAME /home/workspace

# Install Python packages
python3 -m pip install --upgrade pip
pip3 install --user -r .devcontainer/requirements.txt

# Clean up - for smaller image size
sudo apt-get autoremove -y
sudo apt-get clean