# CLAUDE.md

This file provides context for Claude Code working with this Neovim configuration.

## What This Repo Is

Single-file Neovim configuration (`init.lua`) with a test suite. Part of a five-repo tooling stack (`unix-utils`, `oh-my-zsh`, `tmux`, `neovim`, `ghostty`).

Cross-platform (macOS + Debian/Ubuntu); `install.sh` handles platform branches.

## Editing Constraints

- **Keep it a single file.** Maintain `init.lua` as one giant file -- user preference.
- **Plugin manager is lazy.nvim.** Add new plugins as specs inside `require("lazy").setup({ ... })`.
- **Prefer modern lua plugins.** Avoid vimscript-only plugins unless no lua alternative exists.
- **Prefer native/plugin solutions.** Only use custom implementations when plugins don't work well (like `MermaidIndent`).

## Load-Bearing Custom Code

- **`MermaidIndent()` in `init.lua`** -- custom stack-based indenter for `.mmd` files. Handles sequence diagrams, flowcharts, and state diagrams with proper nested-block tracking. Kept despite `mermaid.vim` existing because that plugin doesn't handle nesting correctly. If a better plugin emerges, re-evaluate.
- **Auto-reload via native `autoread` + `checktime`** -- works for all file types, not just `init.lua`. Keeps buffers in sync with files Claude Code edits externally.

## Testing

```bash
cd tests && ./agentic-nvim-autoformat-test.sh
```

Tests all supported formats (Markdown, XML, Mermaid variants). Run after any indent-related change.

## Rejected: `claudecode.nvim`

[coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) provides native WebSocket-based bidirectional neovim ↔ Claude Code communication -- architecturally superior to the current file-bridge pattern (`~/.nvim_last_file`, `~/.ai-context.txt`). But it assumes a 1:1 relationship between neovim and Claude Code instances, and the user runs multiple of each in parallel. If multi-instance support is added upstream, re-evaluate.
