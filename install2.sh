#!/bin/bash
set -e

# Install integrations..

# Globally install Tern stuff
sudo npm install -g tern prettier

# golint installation
sudo apt-get install -y golint

# Install pgFormatter
sudo rm -fr pgFormatter && git clone https://github.com/darold/pgFormatter
cd pgFormatter
perl Makefile.PL
make && sudo make install
cd -

# Install nerd-fonts
sudo rm -fr nerd-fonts && git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
sudo chmod +x install.sh
./install.sh
cd -

# Install it
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim

sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim
sudo gem install neovim
sudo npm i -g neovim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Use my configs
mkdir -p ~/.config/nvim/
ln -s ~/neovim/init.vim ~/.config/nvim/
ln -s ~/neovim/colors ~/.config/nvim/
ln -s ~/neovim/.tern-project ~

echo "alias sudo=sudo " >> ~/.bashrc
echo "alias vim=nvim" >> ~/.bashrc
echo "Done!"
