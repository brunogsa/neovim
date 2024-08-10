#!/bin/bash
set -e
set -x

# Install integrations..

# Globally install Tern stuff
sudo npm install -g tern prettier @asyncapi/generator @asyncapi/html-template

# golint installation
# sudo apt-get install -y golint

# Install pgFormatter
sudo rm -fr pgFormatter && git clone https://github.com/darold/pgFormatter
cd pgFormatter
perl Makefile.PL
make && sudo make install
cd -

# Install it
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update || echo "Done"
sudo apt-get install -y neovim

sudo apt install python3-neovim
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
git config --global core.editor "nvim"

# Install nerd-fonts
if [ ! -d "nerd-fonts" ]; then
  git clone https://github.com/ryanoasis/nerd-fonts.git
else
  cd nerd-fonts
  git pull
  sudo chmod +x install.sh
  ./install.sh
  cd -
fi

echo "Done!"
