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
sudo apt-get install -y zsh
sudo chsh -s /usr/bin/zsh $USERNAME
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' /home/$USERNAME/.zshrc
sudo sed -i 's/plugins=(git)/plugins=(git docker)/g' /home/$USERNAME/.zshrc
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.oh-my-zsh

# Install Python packages
python3 -m pip install --upgrade pip
pip3 install --user -r .devcontainer/requirements.txt

# Clean up - for smaller image size
sudo apt-get autoremove -y
sudo apt-get clean