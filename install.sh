#!/bin/bash
set -e

# Install python and pip
brew install python
pip3 install --upgrade pip --break-system-packages
pip3 install pynvim --break-system-packages
pip3 install --upgrade pynvim --break-system-packages
brew install ruff flake8

# Install Ruby
brew install ruby
brew install gcc
brew install rbenv
brew install gnupg
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://get.rvm.io | bash
rvm get stable --ruby

# Install Rust
brew install rustup
rustup-init

# Install Lua
brew install lua
brew install luarocks
luarocks install luacheck
cargo install selene

# Install perl
brew install perl

# Install node, npm and n
brew install node
node -v
npm -v
sudo npm i -g n
sudo n lts
sudo npm i -g npm
sudo npm i -g yarn
mkdir -p ~/.npm
sudo npm i -g node-gyp
sudo chown -R $USER:$GROUP ~/.npm
npm install -g eslint_d

# Install typescript
sudo npm i -g typescript
