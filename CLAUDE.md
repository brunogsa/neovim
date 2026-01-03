# Neovim Configuration - AI Context

This file provides context for AI assistants (Claude, Aider, etc.) working with this Neovim configuration.

## Configuration Overview

This is a single-file Neovim configuration (`init.lua`) with the following key features:

### Auto-Reload
- Files automatically reload when changed externally (e.g., by aider in --watch-files mode)
- Uses native Neovim `autoread` + `checktime` functionality
- Works for ALL file types, not just init.lua
- Triggers on cursor hold, focus gain, and buffer enter

### Auto-Indentation Support

**Markdown (`.md`)**
- Uses Treesitter indent (native)
- Handles nested lists automatically

**XML (`.xml`)**
- Uses Treesitter indent (native)
- Handles nested tags automatically

**Mermaid (`.mmd`)**
- Custom `MermaidIndent()` function (lines 89-139 in init.lua)
- Supports three diagram types you use most:
  - **Sequence Diagrams**: alt, else, opt, loop, par, and, critical, option, rect, break
  - **Flowcharts**: subgraph with nesting
  - **State Diagrams**: composite states with {} syntax
- Tracks block nesting using a stack-based approach
- More sophisticated than mermaid.vim plugin (which doesn't handle nested blocks properly)

## Important Constraints

When modifying this configuration:

1. **Keep it a single file** - User preference is to maintain init.lua as one giant file
2. **Prefer native/plugin solutions** - Only use custom implementations when plugins don't work well (like Mermaid indent)
3. **Preserve formatting** - NEVER modify indentation, whitespace, or formatting unless explicitly requested
4. **Test thoroughly** - Use the test suite in `tests/` directory

## File Structure

```
/Users/brunoagostini/neovim/
├── init.lua                           # Main configuration (single file)
├── README.md                          # User documentation
├── CLAUDE.md                          # This file (AI context)
├── tests/                             # Test suite
│   ├── agentic-nvim-autoformat-test.sh   # Main test script
│   ├── test.md                        # Markdown test
│   ├── test.xml                       # XML test
│   ├── test.mmd                       # Basic Mermaid sequence
│   ├── test_sequence_full.mmd         # Full Mermaid sequence
│   ├── test_flowchart.mmd             # Mermaid flowchart
│   └── test_state.mmd                 # Mermaid state diagram
```

## Key Code Locations in init.lua

- **Lines 201-218**: Auto-reload configuration (autoread + checktime)
- **Lines 89-139**: MermaidIndent() function (custom implementation)
- **Lines 123-127**: FileType autocmd for Mermaid files
- **Lines 743**: Treesitter allowed_languages (markdown, xml, etc.)

## Testing

Run the test suite to verify indentation works:

```bash
cd tests
./agentic-nvim-autoformat-test.sh
```

This tests all supported formats (Markdown, XML, and all Mermaid diagram types).

## Common Tasks

### Adding a new Mermaid keyword
1. Add to the appropriate section in `MermaidIndent()` function
2. Consider if it's an opening keyword (needs stack push) or closing (needs stack pop)
3. Add test case to `test_sequence_full.mmd` or create new test file
4. Run test suite to verify

### Modifying auto-reload behavior
1. Look at lines 201-218 in init.lua
2. Modify the autocmd triggers (CursorHold, FocusGained, etc.)
3. Test with aider in --watch-files mode

### Enabling Treesitter indent for new language
1. Add language to `allowed_languages` array (around line 743)
2. Ensure Treesitter parser is installed for that language
3. Test indentation behavior

## Plugin Management

Uses lazy.nvim for plugin management. Plugins are automatically installed on first launch.

Key plugins:
- nvim-treesitter: Syntax highlighting and indentation
- vim-tmux-focus-events: Focus event support in tmux
- vim-sleuth: Auto-detect indentation

## Notes for AI Assistants

- Always read init.lua before making changes
- Test changes with the test suite in tests/
- Follow the user's coding conventions (see ~/.claude/CLAUDE.md for global conventions)
- When in doubt, ask before implementing - user values correctness over speed
- The MermaidIndent() function is more sophisticated than available plugins - keep it unless a better plugin emerges
