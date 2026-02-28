# neovim

Cross-platform Neovim configuration and installer. Single-file `init.lua` with LSP, Treesitter, Telescope, Git integration, AI assistance, and custom Mermaid indentation.

## Setup

```bash
# Prerequisite: ~/oh-my-zsh/ must be set up first (provides detect-os.sh)
./install.sh && ./install2.sh
```

The scripts install language runtimes (Python, Ruby, Rust, Lua, Perl, Node.js), Neovim, LSP servers, fonts, and symlink the config to `~/.config/nvim/`. Plugins auto-install via lazy.nvim on first launch. All steps are idempotent.

## What It Can Configure

LSP servers, keymaps, plugins, color scheme, indentation rules, and more. See [init.lua](./init.lua) for current settings.

## Testing

Auto-indentation tests for Markdown, XML, and Mermaid diagrams:

```sh
cd tests && ./agentic-nvim-autoformat-test.sh
```

## Platforms

- **macOS**: Neovim and dependencies via Homebrew
- **Linux**: Neovim and dependencies via apt

## Part of

Five-repo tooling stack: [unix-utils](https://github.com/brunogsa/unix-utils) | [oh-my-zsh](https://github.com/brunogsa/oh-my-zsh) | [tmux](https://github.com/brunogsa/tmux) | **neovim** | [ghostty](https://github.com/brunogsa/ghostty)
