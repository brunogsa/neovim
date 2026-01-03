# Neovim Configuration

A modern, cross-platform Neovim configuration with LSP support, Git integration, AI assistance, and more.

**Supported Platforms:**
- macOS (Homebrew)
- Debian/Ubuntu Linux (apt)

## How to install

### Prerequisites

**macOS:**
- Git
- Homebrew
- Xcode Command Line Tools

**Linux (Debian/Ubuntu):**
- Git
- sudo access
- build-essential

**Note:** The installation scripts automatically detect your operating system and install the appropriate packages.

### Installation Steps

1. Clone this repository:
```sh
git clone https://github.com/brunogsa/neovim.git ~/neovim
cd ~/neovim
```

2. Run the installation scripts:
```sh
./install.sh    # Installs language dependencies (Node, Python, Ruby, Rust, Lua)
./install2.sh   # Installs Neovim and related tools
```

The scripts will:
- Auto-detect your OS (macOS or Linux)
- Install packages using the appropriate package manager (brew or apt)
- Configure platform-specific settings as needed

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

## Testing

This configuration includes automated tests for auto-indentation across multiple file formats.

### Running Tests

```sh
cd tests

# Run full test suite (all formats)
./agentic-nvim-autoformat-test.sh

# Test a single file
./agentic-nvim-autoformat-test.sh test.md
```

### Supported Formats

The test suite validates indentation for:

**Markdown** (`.md`)
- Nested lists with Treesitter indentation

**XML** (`.xml`)
- Nested tags with Treesitter indentation

**Mermaid** (`.mmd`)
- **Sequence Diagrams**: `alt`, `else`, `opt`, `loop`, `par`, `and`, `critical`, `option`, `rect`, `break`
- **Flowcharts**: `subgraph` with nested subgraphs
- **State Diagrams**: Composite states with `{}` syntax

### Test Files

All test files are located in the `tests/` directory:
- `test.md` - Markdown with nested lists
- `test.xml` - XML with nested tags
- `test.mmd` - Basic sequence diagram
- `test_sequence_full.mmd` - All sequence diagram block types
- `test_flowchart.mmd` - Flowchart with subgraphs
- `test_state.mmd` - State diagram with composite states

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
