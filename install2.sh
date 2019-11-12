#!/bin/bash
set -e

# Install integrations..

# Globally install ESLint and Tern stuff
sudo npm install -g eslint babel-eslint eslint-config-node eslint-config-airbnb eslint-plugin-jsx-a11y eslint-plugin-react eslint-plugin-import eslint-config-standard eslint-plugin-node eslint-plugin-promise eslint-plugin-standard tern prettier eslint-plugin-cypress eslint-plugin-chai-friendly @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-airbnb-typescript

# tslint installation
sudo npm install -g tslint

# golint installation
sudo apt-get install -y golint

# Install ag
sudo apt-get install -y silversearcher-ag

# Install FZF
sudo rm -fr ~/.fzf && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
export FZF_CTRL_T_COMMAND='ag -g "" `git rev-parse --show-toplevel`'

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
