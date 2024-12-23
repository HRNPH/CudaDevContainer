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
# apt-get install software-properties-common


# Z Shell Setup with p10k
export USERNAME=$(whoami)
sudo apt-get install -y zsh
sudo chsh -s /usr/bin/zsh $USERNAME
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' /home/$USERNAME/.zshrc
sudo sed -i 's/plugins=(git)/plugins=(git docker)/g' /home/$USERNAME/.zshrc
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.oh-my-zsh
sudo chown -R $USERNAME:root /home/workspace

# CUDA and Libraries
# Update CUDA Linux GPG repository key
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb
rm cuda-keyring_1.0-1_all.deb

# Install cuDNN
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" -y
apt-get update
apt-get install libcudnn8=8.9.0.*-1+cuda11.8
apt-get install libcudnn8-dev=8.9.0.*-1+cuda11.8

Install recommended packages
Some of these support x11 forwarding on linux
apt-get install zlib1g g++ freeglut3-dev \
    libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev libfreeimage-dev -y


# Install Python packages
python3 -m pip install --upgrade pip
pip3 install --user -r .devcontainer/requirements.txt

# Clean up - for smaller image size
sudo apt-get autoremove -y
sudo apt-get clean