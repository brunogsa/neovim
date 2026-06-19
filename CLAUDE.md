# CLAUDE.md

This file provides context for Claude Code working with this Neovim configuration.

## What This Repo Is

Single-file Neovim configuration (`init.lua`) with a test suite. Part of a five-repo tooling stack (`unix-utils`, `oh-my-zsh`, `tmux`, `neovim`, `ghostty`).

Cross-platform (macOS + Debian/Ubuntu); `install.sh` handles platform branches.

## Editing Constraints

- **Keep it a single file.** Maintain `init.lua` as one giant file -- user preference.
- **Plugin manager is lazy.nvim.** Add new plugins as specs inside `require("lazy").setup({ ... })`.
- **Tree-sitter parsers via `romus204/tree-sitter-manager.nvim`** (replaces archived `nvim-treesitter/nvim-treesitter`).
  - Requires the `tree-sitter` CLI in PATH.
  - Parser list lives in the plugin's `ensure_installed` option.
  - Run `:TSManager` to install/update parsers interactively.
  - TS-based indent is not supported; built-in filetype indent is used instead.
- **Prefer modern lua plugins.** Avoid vimscript-only plugins unless no lua alternative exists.
- **Prefer native/plugin solutions.** Only use custom implementations when plugins don't work well (like `MermaidIndent`).

## Load-Bearing Custom Code

- **`MermaidIndent()` in `init.lua`** -- custom stack-based indenter for `.mmd` files.
  - Handles sequence diagrams, flowcharts, and state diagrams with proper nested-block tracking.
  - Kept despite `mermaid.vim` existing because that plugin doesn't handle nesting correctly.
  - If a better plugin emerges, re-evaluate.
- **Auto-reload via native `autoread` + `checktime`** -- works for all file types, not just `init.lua`. Keeps buffers in sync with files Claude Code edits externally.

## Testing

```bash
cd tests && ./agentic-nvim-autoformat-test.sh
```

Tests all supported formats (Markdown, XML, Mermaid variants). Run after any indent-related change.

## AI integration: `claudecode.nvim`

[coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) gives VS Code-parity editable diffs: edit Claude's proposed change in the diff, then `:w` accepts (your edited version is what gets applied) or `:q` rejects.

Configured with `terminal = { provider = "none" }` because claude runs in a separate tmux pane, never inside neovim; this also avoids the otherwise-required `snacks.nvim` dependency.

**Multi-instance:** safe across parallel tmux tabs.

- Each neovim's lock file is tagged with its workspace folders, so per-project / per-worktree pairs disambiguate in the `/ide` picker.
- Pair a pane's claude to its neovim with `/ide` (or `claude --ide`).

**Why an IDE-socket plugin over a hook-based one:** a fail-closed `PreToolUse` hook can wedge the whole session.

- It blocks the very edits that would remove it, and hook changes reload only on Claude restart.
- claudecode.nvim installs no hook, so it cannot lock the session out.
