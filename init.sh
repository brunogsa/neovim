#!/bin/bash
set -e

# Dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl
sudo apt-get install -y software-properties-common

# Install python and pip
sudo apt-get install -y python-dev python-pip python3-dev python3-pip
sudo apt-get install -y python-pip python3-pip
sudo pip install --upgrade pip

# Install Lua
sudo apt-get install -y luarocks lua-check rubygems ruby-dev
sudo luarocks install luacheck

# Install nvm, node and npm
touch ~/.bash_profile
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node

sudo reboot
