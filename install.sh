#!/bin/bash
set -e

# Dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl
sudo apt-get install -y software-properties-common

# Install python and pip
sudo apt-get install -y python-dev python-pip python3-dev python3-pip
sudo apt-get install -y python-pip python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install pynvim
sudo pip3 install --upgrade pynvim

# Install Lua
sudo apt-get install -y luarocks lua-check rubygems ruby-dev
sudo luarocks install luacheck

# Install node, npm and n
cd ~
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz
tar -xf node-v8.9.4-linux-x64.tar.xz
rm -f node-v8.9.4-linux-x64.tar.xz
sudo cp node-v8.9.4-linux-x64/bin/node /usr/bin/
sudo node-v8.9.4-linux-x64/bin/npm install -g npm
node -v
npm -v
rm -fr node-v8.9.4-linux-x64
sudo npm i -g n
sudo n lts
sudo npm i -g npm

# Install typescript
sudo npm i -g typescript

# Install go
sudo snap install go --classic

sudo reboot
