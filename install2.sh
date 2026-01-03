#!/bin/bash
set -e

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
        exit 1
    fi
}

OS=$(detect_os)
echo "Detected OS: $OS"

# Globally install Node tools (common)
npm install -g tern prettier @asyncapi/generator @asyncapi/html-template @mermaid-js/mermaid-cli redocly bash-language-server markdownlint-cli yaml-language-server dockerfile-language-server-nodejs

# LSP servers and linters
if [[ "$OS" == "macos" ]]; then
    brew install yamllint vscode-langservers-extracted terraform-ls
elif [[ "$OS" == "linux" ]]; then
    pip3 install --user --break-system-packages yamllint
    npm install -g vscode-langservers-extracted
    # terraform-ls
    wget -O /tmp/terraform-ls.zip https://releases.hashicorp.com/terraform-ls/0.32.7/terraform-ls_0.32.7_linux_amd64.zip
    sudo unzip -o /tmp/terraform-ls.zip -d /usr/local/bin/
    sudo chmod +x /usr/local/bin/terraform-ls
    rm /tmp/terraform-ls.zip
fi

# Install pgFormatter (Postgres SQL formatter)
sudo rm -fr pgFormatter && git clone https://github.com/darold/pgFormatter
cd pgFormatter
perl Makefile.PL
make && sudo make install
cd -

# Install nerd-fonts
if [[ "$OS" == "macos" ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
elif [[ "$OS" == "linux" ]]; then
    if [ ! -d "nerd-fonts" ]; then
        git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1
    fi
    cd nerd-fonts && ./install.sh Hack && cd -
fi

# Install Neovim
if [[ "$OS" == "macos" ]]; then
    brew install neovim
    pip3 install --upgrade neovim --break-system-packages
elif [[ "$OS" == "linux" ]]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt-get update
    sudo apt-get install -y neovim python3-neovim
    pip3 install --user --break-system-packages --upgrade neovim
fi

# Install neovim npm package (common)
npm i -g neovim

# Install lazy.nvim (plugin manager) - done automatically by init.lua
mkdir -p ~/.config/nvim/lua/plugins

# Use my configs
mkdir -p ~/.config/nvim/
ln -sf ~/neovim/init.lua ~/.config/nvim/
ln -sf ~/neovim/colors ~/.config/nvim/
ln -sf ~/neovim/.tern-project ~

# Git configuration (cross-platform)
git config --global core.editor "nvim"

echo "Installation complete for $OS!"
echo "Launch neovim to auto-install plugins via lazy.nvim"
