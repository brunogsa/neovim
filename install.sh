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

################################################################################
# PART 1: Language Dependencies
################################################################################

# Install python and pip
if [[ "$OS" == "macos" ]]; then
    brew install python
    pip3 install --upgrade pip --break-system-packages
    pip3 install pynvim --break-system-packages
    pip3 install --upgrade pynvim --break-system-packages
    brew install ruff flake8
elif [[ "$OS" == "linux" ]]; then
    sudo apt-get update
    sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
    sudo apt-get install -y python3 python3-pip python3-flake8
    pip3 install --user --break-system-packages pynvim
    pip3 install --user --break-system-packages --upgrade pynvim
    pip3 install --user --break-system-packages ruff
fi

# Install Ruby
if [[ "$OS" == "macos" ]]; then
    brew install ruby gcc rbenv gnupg
elif [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y ruby rubygems ruby-dev gcc
fi

# Install RVM (macOS only, for stable Ruby)
if [[ "$OS" == "macos" ]]; then
    command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
    curl -sSL https://get.rvm.io | bash
    rvm get stable --ruby
fi

# Install Rust
if [[ "$OS" == "macos" ]]; then
    brew install rustup
    rustup-init
elif [[ "$OS" == "linux" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Install Lua
if [[ "$OS" == "macos" ]]; then
    brew install lua luarocks
    luarocks install luacheck
elif [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y lua5.3 liblua5.3-dev luarocks
    luarocks install --local luacheck
fi

# Install Lua tools (common, requires Rust from earlier step)
cargo install selene

# Install perl
if [[ "$OS" == "macos" ]]; then
    brew install perl
elif [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y perl
fi

# Install node and npm
if [[ "$OS" == "macos" ]]; then
    brew install node
elif [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y nodejs npm
fi

# Node version management and global packages (common)
node -v && npm -v
npm i -g n
sudo n lts
npm i -g yarn node-gyp

# Setup npm directory
mkdir -p ~/.npm
if [[ "$OS" == "macos" ]]; then
    chown -R $USER:$GROUP ~/.npm
elif [[ "$OS" == "linux" ]]; then
    chown -R $USER ~/.npm
fi

# Install global npm packages (common)
npm i -g eslint_d typescript

################################################################################
# PART 2: Neovim and Development Tools
################################################################################

# Globally install Node tools for development (common)
npm install -g tern prettier @asyncapi/generator @asyncapi/html-template @mermaid-js/mermaid-cli redocly bash-language-server markdownlint-cli yaml-language-server dockerfile-language-server-nodejs tree-sitter-cli

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

    # Symlink system bundled parsers to user location
    # PPA builds include parsers in /usr/lib but nvim looks in ~/.local/share
    mkdir -p ~/.local/share/nvim/site
    ln -sf /usr/lib/x86_64-linux-gnu/nvim/parser ~/.local/share/nvim/site/parser
fi

# Install neovim npm package (common)
npm i -g neovim

################################################################################
# PART 3: Configuration Setup
################################################################################

# Install lazy.nvim (plugin manager) - done automatically by init.lua
mkdir -p ~/.config/nvim/lua/plugins

# Use my configs
mkdir -p ~/.config/nvim/
ln -sf ~/neovim/init.lua ~/.config/nvim/
ln -sf ~/neovim/colors ~/.config/nvim/
ln -sf ~/neovim/.tern-project ~

# Git configuration (cross-platform)
git config --global core.editor "nvim"

echo ""
echo "=========================================="
echo "Installation complete for $OS!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Launch neovim: nvim"
echo "  2. Plugins will auto-install via lazy.nvim"
echo "  3. Run :checkhealth to verify setup"
echo ""
