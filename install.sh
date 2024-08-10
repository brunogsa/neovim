#!/bin/bash
set -e
set -x

# Dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl
sudo apt-get install -y software-properties-common

# Install python and pip
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
sudo apt-get install -y python3 python3-pip
sudo apt install python3-pip
sudo apt install python-pynvim

# Install Lua
sudo apt-get install -y luarocks lua-check rubygems ruby-dev
sudo luarocks install luacheck

# Install node, npm and n
sudo apt-get install -y nodejs npm
sudo npm i -g n
sudo n lts
sudo npm i -g npm

# Install typescript
sudo npm i -g typescript

# Install go
sudo snap install go --classic

# Ctags
sudo apt-get install -y exuberant-ctags

# Install PHP, composer
sudo apt-get install -y php
sudo apt-get install -y composer
sudo chown -Rf $USER:$USER ~/.composer
sudo apt-get install -y php-curl

sudo reboot
