#!/bin/bash

# Dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y software-properties-common
sudo apt-get -y upgradeudo apt-get install -y python-dev python-pip python3-dev python3-pip
sudo apt-get install -y python-pip
sudo npm install -g eslint_d

# Install it
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Use my configs
sudo mkdir -p ~/.config/nvim/
sudo ln -s ~/neovim/init.vim ~/.config/nvim/
sudo ln -s ~/neovim/colors ~/.config/nvim/
sudo ln -s ~/neovim/.tern-project ~

echo "Done!"
