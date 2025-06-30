# Neovim Configuration

A modern Neovim configuration with LSP support, Git integration, AI assistance, and more.

## How to install

### Prerequisites

- Git
- Node.js and npm
- Python 3
- Homebrew (for macOS users)

### Installation Steps

1. Clone this repository:
```sh
git clone https://github.com/yourusername/neovim-config.git ~/neovim
cd ~/neovim
```

2. Run the installation scripts:
```sh
./install.sh    # Installs language dependencies (Node, Python, Ruby, Rust, Lua)
./install2.sh   # Installs Neovim and related tools
```

3. Launch Neovim:
```sh
nvim
```

The configuration will automatically install lazy.nvim (plugin manager) on first launch. The bootstrap code in `init.lua` handles this process by:

- Checking if lazy.nvim exists at `~/.local/share/nvim/lazy/lazy.nvim`
- If not, cloning it from GitHub
- Adding it to the runtime path
- Setting up all plugins defined in the configuration

No manual installation of the plugin manager is required.

### Configuration Structure

- **Main configuration files**:
  - `init.lua` - Main Neovim configuration with plugins, keymaps, and settings
  - `.tern-project` - JavaScript/TypeScript configuration
  - `tsconfig.json` - TypeScript configuration

- **Installation scripts**:
  - `install.sh` - Installs language dependencies
  - `install2.sh` - Installs Neovim and related tools

- **Configuration location**:
  - All configurations are symlinked from this repo to `~/.config/nvim/`
  - Global AI context file is stored at `~/.ai-context`

### Key Features

- Modern Lua-based configuration
- Plugin management with lazy.nvim (auto-installed)
- LSP support for multiple languages (TypeScript, Python, Go, etc.)
- Fuzzy finding with Telescope
- Git integration with Diffview and Signify
- AI coding assistance with CodeCompanion
- Treesitter for better syntax highlighting
- Snippets and autocompletion
- Markdown and code previews

## How to profile its performance

```sh
# Open a file

:profile start profile.log
:profile func*
:profile file*

# Do slow actions here

:profile pause
:noautocmd qa!
```
