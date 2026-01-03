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
    sudo apt-get install -y python3 python3-pip
    pip3 install --user pynvim
    pip3 install --user --upgrade pynvim
    sudo apt-get install -y ruff python3-flake8
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
elif [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y lua5.3 liblua5.3-dev luarocks
fi

# Install Lua tools (common)
luarocks install luacheck
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
n lts
npm i -g npm yarn node-gyp

# Setup npm directory
mkdir -p ~/.npm
if [[ "$OS" == "macos" ]]; then
    chown -R $USER:$GROUP ~/.npm
elif [[ "$OS" == "linux" ]]; then
    chown -R $USER ~/.npm
fi

# Install global npm packages (common)
npm i -g eslint_d typescript

echo "Installation complete for $OS!"
