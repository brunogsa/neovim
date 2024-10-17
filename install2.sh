#!/bin/bash
set -e

# Globally install Tern and Node stuff
sudo npm install -g tern prettier @asyncapi/generator @asyncapi/html-template @mermaid-js/mermaid-cli

# Install pgFormatter
sudo rm -fr pgFormatter && git clone https://github.com/darold/pgFormatter
cd pgFormatter
perl Makefile.PL
make && sudo make install
cd -

# Install nerd-fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# Install it
brew install neovim

pip3 install --upgrade neovim --break-system-packages
sudo npm i -g neovim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Use my configs
mkdir -p ~/.config/nvim/
ln -sf ~/neovim/init.vim ~/.config/nvim/
ln -sf ~/neovim/init.lua ~/.config/nvim/
ln -sf ~/neovim/colors ~/.config/nvim/
ln -sf ~/neovim/.tern-project ~
ln -sf ~/neovim/coc-settings.json ~/.config/nvim/

echo "Done!"
