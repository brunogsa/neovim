#!/bin/bash

# Dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y software-properties-common
sudo apt-get -y upgradeudo apt-get install -y python-dev python-pip python3-dev python3-pip
sudo apt-get install -y python-pip python3-pip
sudo pip install --upgrade pip
sudo npm install -g eslint_d
sudo npm install -g tern
sudo apt-get install -y silversearcher-ag

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
export FZF_CTRL_T_COMMAND='ag -g "" `git rev-parse --show-toplevel`'

git clone https://github.com/darold/pgFormatter
cd pgFormatter
perl Makefile.PL
make && sudo make install
cd -

sudo apt-get install -y luarocks lua-check
sudo luarocks install luacheck

# Install it
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim

sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim
sudo gem install neovim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Use my configs
sudo mkdir -p ~/.config/nvim/
sudo ln -s ~/neovim/init.vim ~/.config/nvim/
sudo ln -s ~/neovim/colors ~/.config/nvim/
sudo ln -s ~/neovim/.tern-project ~

echo "alias vim=nvim" >> ~/.bashrc
echo "Done!"
