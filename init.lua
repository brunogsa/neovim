-- =======================================
-- Auxiliar Functions and Values
-- =======================================

HOME = os.getenv('HOME')
local colorscheme = "kanagawa-wave"

-- Restore cursor position
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      local ft = vim.bo.filetype
      local ignore = {
        gitcommit = true,
        gitrebase = true,
      }

      if ignore[ft] then return end

      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)

      if mark[1] > 0 and mark[1] <= lcount then
        vim.cmd('normal! g`"')         -- move to last position
        vim.cmd('normal! zv')          -- open folds to make cursor visible
      end
    end, 1)
  end,
})

-- Only highlight current window's cursorline
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "BufEnter" }, {
  callback = function()
    vim.wo.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave", "BufLeave" }, {
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Save the current neovim file I'm at
-- Used in a tmux hotkey
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained"}, {
  callback = function()
    local file = vim.fn.expand("%:p")
    local last_file_path = vim.fn.expand("$HOME/.nvim_last_file")
    vim.fn.writefile({file}, last_file_path)
  end
})

-- Toggle foldmethod between "indent" and "syntax"
function _G.toggle_foldmethod()
  local current_foldmethod = vim.wo.foldmethod
  if current_foldmethod == 'indent' then
    vim.opt.foldmethod = 'syntax'
  else
    vim.opt.foldmethod = 'indent'
  end
end

-- Create an autocommand for CursorHold to show diagnostics
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = true,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = "",
    }
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local bufnr = vim.api.nvim_get_current_buf()
    local line = cursor_pos[1] - 1
    local col = cursor_pos[2]
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

    -- Check if there’s a diagnostic under the cursor (by comparing ranges)
    for _, diagnostic in ipairs(diagnostics) do
      if diagnostic.col <= col and col < (diagnostic.end_col or diagnostic.col + 1) then
        vim.diagnostic.open_float(nil, opts)
        return
      end
    end
  end,
})

-- Treesitter currently doesnot support mermaid files
-- So, this is an workaround until there
-- Define inline Mermaid indent logic
function _G.MermaidIndent()
  local lnum = vim.v.lnum
  if lnum == 1 then return 0 end

  local block_stack = {}
  for i = 1, lnum - 1 do
    local line = vim.fn.getline(i):match("^%s*(.*)")
    if line:match("^(alt)%s") or line:match("^(opt)%s") or
      line:match("^(loop)%s") or line:match("^(critical)%s") or
      line:match("^(par)%s") then
      table.insert(block_stack, line)
    elseif line == "end" and #block_stack > 0 then
      table.remove(block_stack)
    end
  end

  local current = vim.fn.getline(lnum):match("^%s*(.*)")

  if current == "sequenceDiagram" then
    return 0
  elseif current == "end" and #block_stack > 0 then
    return (#block_stack - 1) * 2
  elseif current:match("^(alt)%s") or current:match("^(opt)%s") or
    current:match("^(loop)%s") or current:match("^(critical)%s") or
    current:match("^(par)%s") then
    return (#block_stack) * 2
  else
    return (#block_stack) * 2
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "mermaid", "mmd" },
  callback = function()
    vim.opt_local.indentexpr = "v:lua.MermaidIndent()"
  end,
})

-- =======================================
-- Core Settings
-- =======================================

vim.opt.encoding='utf-8'

vim.opt.updatetime = 2000

-- PHP: slower updatetime for better LSP performance
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*.php',
  callback = function()
    vim.opt.updatetime = 8000
  end,
})

-- Toggle mouse scroll
vim.opt.mouse = 'a'
-- vim.opt.mouse = ''

-- Improve Performance
vim.opt.ttyfast = true
vim.opt.regexpengine = 1
vim.opt.modelines = 0

vim.opt.synmaxcol = 213
vim.cmd('syntax sync minlines=250')
vim.cmd('syntax sync maxlines=2000')

vim.opt.timeoutlen = 512
vim.opt.ttimeoutlen = 16

-- Fold options. I prefer fold by identation

vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 2
vim.opt.foldnestmax = 20 -- This is the max value, hard limited by neovim code
vim.opt.foldenable = true

vim.opt.listchars = {
  nbsp = '˽',
  trail = '˽',
  tab = '\\┆\\',
}
vim.opt.list = true

-- Search options
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Split options
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Completion options
vim.opt.wildmode = 'longest,list'
vim.opt.wildmenu = true
vim.opt.completeopt = 'longest,menu'

-- Set vim title automatically
vim.opt.title = true

-- Share clipboard with system
vim.opt.clipboard = 'unnamed,unnamedplus'

-- No annoying backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Indentation options
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.preserveindent = true
vim.opt.copyindent = true

-- Spaces for identation
vim.opt.expandtab = true
vim.opt.smarttab = true

-- The size of your indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.shiftround = true

-- Indentation for HTML
vim.g.html_indent_script1 = 'inc'
vim.g.html_indent_style1 = 'inc'
vim.g.html_indent_inctags = 'html,body,head'

-- Automatically set wrap when starting a vim diff
vim.api.nvim_create_autocmd('FilterWritePre', {
  pattern = '*',
  callback = function()
    if vim.wo.diff then
      vim.opt_local.wrap = true
    end
  end,
})

-- Virtual edit preferences: in block wise
vim.opt.virtualedit = 'block'

-- Colorscheme
vim.opt.background = 'dark'

-- =======================================
-- Interface
-- =======================================

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Height of bottom command panel
vim.opt.cmdheight = 1

-- Add a line above the cursor - Disable for better performance
vim.opt.cursorline = true

-- Line numbers - Disable for better performance
vim.opt.number = true
-- set relativenumber

vim.opt.wrap = true
vim.opt.whichwrap:append("<,>")
vim.opt.textwidth = 213

-- Transparency in some terminals
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none" })
vim.api.nvim_set_hl(0, "NonText", { ctermbg = "none" })

-- Colorscheme for vimdiff
-- if vim.opt.diff then
--   vim.cmd.colorscheme("jellybeans")
-- end

-- General vision
vim.opt.lbr = true
-- vim.opt.scrolloff = 999  -- Cursor is always in the middle of screen

-- Status Line
vim.opt.ruler = false
vim.opt.laststatus = 2

-- More visible search
vim.api.nvim_set_hl(0, "IncSearch", {
  bg = "red",
  underline = true,
})


-- =======================================
-- Hotkeys
-- =======================================

-- Map to <space>
vim.g.mapleader = ' '

-- Toggle foldmethod between "indent" and "syntax"
-- This is useful when dealing with files too nested, where the "indent" becomes limited
-- since neovim has a internal limit of "20" foldnestmax.
-- In those case, switching to "syntax" is the workaround
vim.keymap.set(
  'n',
  '<leader>tf',
  '<Cmd>lua _G.toggle_foldmethod()<CR>',
  { silent = false, desc = "Toggle fold method" }
)

-- Send deleted thing with 'x' and 'c' to black hole
vim.keymap.set('n', 'x', '"_x', { silent = true })
vim.keymap.set('n', 'X', '"_X', { silent = true })
vim.keymap.set('n', 'c', '"_c', { silent = true })
vim.keymap.set('n', 'C', '"_C', { silent = true })

-- Add ; or , in the end of the line
vim.keymap.set('n', ';;', 'mqA;<esc>`q', { silent = true })
vim.keymap.set('n', ',,', 'mqA,<esc>`q', { silent = true })

-- Efficient way to move through your code using the Arrow Keys
vim.keymap.set('n', '<left>', 'h', { silent = true })
vim.keymap.set('n', '<down>', 'gj', { silent = true })
vim.keymap.set('n', '<up>', 'gk', { silent = true })
vim.keymap.set('n', '<right>', 'l', { silent = true })

-- Move to the beginning of the indentation level
vim.keymap.set('', '<S-left>', '^', { silent = true })
vim.keymap.set('', '<home>', '^', { silent = true })

-- Move to the end of a line in a smarter way
vim.keymap.set('', '<S-right>', 'g_', { silent = true })
vim.keymap.set('', '<end>', 'g_', { silent = true })

-- Easier to align
vim.keymap.set('x', '>', '>gv', { silent = true })
vim.keymap.set('x', '<', '<gv', { silent = true })

-- Disable annoying auto-increment number feature
vim.keymap.set('', '<C-a>', '<Nop>', { noremap = false, silent = true })
vim.keymap.set('', 'g<C-a>', '<Nop>', { noremap = false, silent = true })
vim.keymap.set('', '<C-x>', '<Nop>', { noremap = false, silent = true })
vim.keymap.set('', 'g<C-x>', '<Nop>', { noremap = false, silent = true })

-- Resize windows
-- nnoremap <silent><leader><right> :vertical resize -5<cr>
-- nnoremap <silent><leader><left> :vertical resize +5<cr>
-- nnoremap <silent><leader><up> :resize +5<cr>
-- nnoremap <silent><leader><down> :resize -5<cr>

-- Toggles the number lines
vim.keymap.set(
  'n',
  '<leader>tn',
  ':set number!<cr>',
  { silent = true, desc = "Toggle line numbers" }
)

-- Search only in visual selection
vim.keymap.set('v', '/', '<esc>/\\%V', { silent = true, desc = "Search on selected block" })

-- PrettyXML: Format a line of XML
vim.keymap.set(
  'v',
  '<leader>Fxml',
  ':!xmllint --format --recover - 2>/dev/null<cr>',
  { silent = true, desc = "Pretty format XML" }
)

-- PrettyPSQL: Format a line of PSQL
vim.keymap.set(
  'v',
  '<leader>Fpsql',
  ':!pg_format -f 0 -s 2 -u 0<cr>',
  { silent = true, desc = "Pretty format SQL" }
)

-- Selected last pasted text
vim.keymap.set('n', 'gp', "V']", { silent = true })

-- Autoformat pasted text, and keep cursor in the best place
vim.keymap.set({ 'n', 'v' }, 'p', function()
  local win = 0
  local pos = vim.api.nvim_win_get_cursor(win)
  local originalConfig = vim.o.lazyredraw
  local count = vim.v.count
  vim.o.lazyredraw = true

  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    -- Visual paste and reindent
    if count > 1 then
      vim.cmd('normal! ' .. count .. 'p')
    else
      vim.cmd('normal! p')
    end
    vim.cmd('normal! gv=gv')    -- reselect and reindent
  else
    -- Normal paste and reindent
    if count > 1 then
      vim.cmd('normal! ' .. count .. "p=']")
    else
      vim.cmd("normal! p=']")
    end
  end

  -- Restore original cursor position
  vim.api.nvim_win_set_cursor(win, pos)
  vim.o.lazyredraw = originalConfig
end, { silent = true, expr = false })

vim.keymap.set('n', 'P', function()
  local count = vim.v.count
  return (count > 1 and (count .. "P=']") or "P=']")
end, { silent = true, expr = true })

-- Keep cursor position after yanking on visual selections
-- Has an optimization to avoid 2 vim redraws, which cause a flicker
vim.keymap.set('v', 'y', function()
  -- save cursor position (row, col) before the yank
  local win   = 0                              -- 0 = current window
  local pos   = vim.api.nvim_win_get_cursor(win)
  local originalConfig  = vim.o.lazyredraw               -- remember current setting
  vim.o.lazyredraw = true                      -- suppress interim screen updates

  vim.cmd('normal! y')                         -- real yank (no remaps)

  -- restore cursor to saved position
  vim.api.nvim_win_set_cursor(win, pos)
  vim.o.lazyredraw = originalConfig                      -- restore original option
end, { silent = true })

-- Keep cursor position after reindenting visually selected text
vim.keymap.set('v', '=', function()
  local win = 0
  local pos = vim.api.nvim_win_get_cursor(win)
  local originalConfig = vim.o.lazyredraw
  vim.o.lazyredraw = true

  vim.cmd('normal! =')   -- reindent selected region

  vim.api.nvim_win_set_cursor(win, pos)
  vim.o.lazyredraw = originalConfig
end, { silent = true })

-- Preview for HTML
vim.keymap.set(
  'n',
  '<leader>vh',
  ':!open % &<cr>',
  { noremap = false, silent = true, desc = "Preview HTML file" }
)

-- Preview for OpenAPI
vim.keymap.set(
  'n',
  '<leader>vo',
  ':!rm -fr /tmp/brunogsa-vim-openapi-preview.html && npx redocly build-docs % --output /tmp/brunogsa-vim-openapi-preview.html && open /tmp/brunogsa-vim-openapi-preview.html &<cr>',
  { noremap = false, silent = true, desc = "Preview OpenAPI spec" }
)

-- Preview for AsyncAPI
vim.keymap.set(
  'n',
  '<leader>va',
  ':!rm -fr /tmp/brunogsa-vim-asyncapi-preview && ag % @asyncapi/html-template -o /tmp/brunogsa-vim-asyncapi-preview && open /tmp/brunogsa-vim-asyncapi-preview/index.html &<cr>',
  { noremap = false, silent = true, desc = "Preview AsyncAPI spec" }
)

-- Jump to parent indentation: record current position, scan upward for first line with indent < current indent,
-- then open folds (zv) and center screen (zz)
local function jump_to_parent_indent()
  -- record current position for jumplist (<C-o> return)
  vim.cmd("normal! m'")

  local curr_lnum = vim.fn.line('.')
  local curr_indent = vim.fn.indent('.')
  for l = curr_lnum - 1, 1, -1 do
    local indd = vim.fn.indent(l)
    if indd < curr_indent and vim.fn.getline(l):match("%S") then
      -- move cursor to first non-blank in that line
      local col = vim.fn.match(vim.fn.getline(l), "\\S")
      vim.api.nvim_win_set_cursor(0, { l, col })
      -- open folds and center screen
      vim.cmd('normal! zv')
      vim.cmd('normal! zz')
      return
    end
  end
  -- fallback to first non-blank of file
  local firstcol = vim.fn.match(vim.fn.getline(1), "\\S")
  vim.api.nvim_win_set_cursor(0, { 1, firstcol })
  vim.cmd('normal! zv')
  vim.cmd('normal! zz')
end
vim.keymap.set(
  { "n", "v" },
  "<C-p>",
  jump_to_parent_indent,
  { desc = "Jump to parent indent, open fold, center" }
)

-- Jump to end of current indent block: record posição para jumplist, scan downward até encontrar indent < current
local function jump_to_block_end()
  -- registra posição atual para voltar com <C-o>
  vim.cmd("normal! m'")

  local curr_lnum = vim.fn.line('.')
  local curr_indent = vim.fn.indent('.')  -- indent da linha atual
  local last_lnum = vim.fn.line('$')
  local target = curr_lnum

  for l = curr_lnum + 1, last_lnum do
    local text = vim.fn.getline(l)
    if text:match("%S") then
      local indd = vim.fn.indent(l)
      if indd < curr_indent then
        -- início de indent menor: fim do bloco anterior em target
        break
      else
        -- ainda dentro do bloco (seja mesma indent ou indent maior)
        target = l
      end
    else
      -- linha em branco: ignorar (não interrompe o bloco)
      -- mas não atualizar target, para não pular para linha em branco
    end
  end

  -- mover cursor para primeira coluna não-branca da linha target
  local line_text = vim.fn.getline(target)
  local col = vim.fn.match(line_text, "\\S")
  vim.api.nvim_win_set_cursor(0, { target, col })

  -- abrir folds e centralizar
  vim.cmd('normal! zv')
  vim.cmd('normal! zz')
end

-- Mapear em normal e visual para <C-e>
vim.keymap.set(
  { "n", "v" },
  "<C-e>",
  jump_to_block_end,
  { desc = "Jump to end of indent block, open fold, center" }
)

-- Aider Yank
vim.keymap.set("n", "<leader>ay", function()
  local absolute_path = vim.fn.expand("%:p")
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

  if not git_root or git_root == "" then
    vim.notify("Not inside a git repository", vim.log.levels.ERROR)
    return
  end

  -- Use Python for reliable path relativization (works across OSes)
  local relpath_cmd = string.format(
    [[python3 -c "import os; print(os.path.relpath('%s', '%s'))"]],
    absolute_path, git_root
  )
  local relative_path = vim.fn.systemlist(relpath_cmd)[1]

  if not relative_path or relative_path == "" then
    vim.notify("Failed to compute relative path", vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg("+", relative_path)
  vim.notify("Copied: " .. relative_path)
end, { desc = "Aider Yank: Copy path from git root", silent = true })

-- AI Context Append
vim.keymap.set("v", "<leader>ag", function()
  -- Get the selected text
  vim.cmd('normal! "zy')
  local selected_text = vim.fn.getreg('z')
  
  if not selected_text or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.ERROR)
    return
  end

  -- Path to the global context file
  local context_file = vim.fn.expand("~/.ai-context")

  -- Get current buffer's file path
  local file_path = vim.fn.expand("%:p")

  -- Append the selected text to the file
  local file = io.open(context_file, "a")
  if not file then
    vim.notify("Failed to open context file: " .. context_file, vim.log.levels.ERROR)
    return
  end
  
  -- Add separation lines if the file is not empty
  local file_size = vim.fn.getfsize(context_file)
  if file_size > 0 then
    -- Add two empty lines for separation
    file:write("\n\n")
  end

  -- Write the file path comment and the selected text
  file:write("// " .. vim.fn.expand("%") .. "\n")
  file:write(selected_text)
  file:close()

  vim.notify("Text appended to " .. context_file, vim.log.levels.INFO)
end, { desc = "AI Grab Context: Append selected text to global context file", silent = true })

-- =======================================
-- Plugins
-- =======================================

-- Botstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  checker = {
    enabled = true,       -- automatically check for plugin updates
    frequency = 7 * 24 * 60 * 60, -- check every week
    notify = true,        -- notify when new updates are found
  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { colorscheme } },

  spec = {

    -- ===================
    -- Core / Essentials
    -- ===================

    -- Tmux focus event support
    {
      "tmux-plugins/vim-tmux-focus-events",
      event = "VeryLazy",
    },

    -- Handle large files efficiently
    {
      "vim-scripts/LargeFile",
      event = "BufReadPre",
    },

    -- Auto detect indentation (2, 4 spaces, or tabs)
    { "tpope/vim-sleuth" },

    -- Make f/F/t/T hotkeys work across lines
    {
      "rhysd/clever-f.vim",
      init = function()
        -- Recommended defaults
        vim.g.clever_f_across_no_line = 0
      end,
    },

    -- Helper to remember hotkeys
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        -- Ensure which-key triggers work as expected
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      config = function()
        local wk = require("which-key")
        wk.setup({
          plugins = {
            spelling = { enabled = true },
          },
          -- Fix deprecation: use `win` instead of `window`
          win = {
            border = "rounded",
          },
        })
      end,
    },

    -- Allow easily toggling quickfix and location lists
    {
      "Valloric/ListToggle",
      init = function()
        vim.g.lt_location_list_toggle_map = "<leader>tl"
        vim.g.lt_quickfix_list_toggle_map = "<leader>tq"
      end,
      cmd = { "LTLocationListToggle", "LTQuickfixListToggle" }, -- optional for lazy loading
    },

    -- Easier marks
    {
      "2KAbhishek/markit.nvim",
      dependencies = { "2KAbhishek/pickme.nvim" },
      config = function()
        require("markit").setup({
          -- any options if needed
        })
        -- Mappings now assume the plugin is already loaded
        vim.keymap.set("n", "<leader>md", require("markit").delete_line, { desc = "Delete marks on this line" })
        vim.keymap.set("n", "<leader>M",  require("markit").delete_buf,  { desc = "Delete all marks in buffer" })
        vim.keymap.set("n", "<leader>mt", require("markit").toggle,      { desc = "Toggle mark at this line" })
        vim.keymap.set("n", "]m",         require("markit").next,        { desc = "Next mark in buffer" })
        vim.keymap.set("n", "[m",         require("markit").prev,        { desc = "Prev mark in buffer" })
      end,
    },

    {
      "szw/vim-maximizer",
      cmd = "MaximizerToggle",
      init = function()
        vim.g.maximizer_set_default_mapping = 0

        vim.keymap.set('n', '<leader><F3>', ':MaximizerToggle<CR>', { silent = true, desc = ":MaximizerToggle" })
        vim.keymap.set('n', '<C-w>z', ':MaximizerToggle<CR>', { silent = true, desc = ":MaximizerToggle" })
      end,
    },

    -- Better paste behavior
    { "conradirwin/vim-bracketed-paste" },

    -- Smooth scrolling, for avoiding loosing where you are
    {
      "karb94/neoscroll.nvim",
      event = "VeryLazy",
      config = function()
        require("neoscroll").setup({
          mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zz', 'zt', 'zb' },
          hide_cursor = true,
          stop_eof = true,
          respect_scrolloff = true,
          cursor_scrolls_alone = true,
        })
      end,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = "all",
          sync_install = true,
          auto_install = true,
          highlight = {
            enable = true,
            disable = function(_, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              return ok and stats and stats.size > max_filesize
            end,
            additional_vim_regex_highlighting = false, -- Keep disable to avoid redraw exceeded time issues
          },
          indent = {
            enable = false, -- Disable Treesitter indentation for all filetypes
          },
          fold = { enable = false },
        })
      end,
    },

    -- Colorschemes
    {
      "sainnhe/sonokai",
      priority = 1000, -- load early so it's applied before other plugins
      lazy = false,
      init = function()
        vim.g.sonokai_style = "espresso"                   -- Options: default, atlantis, andromeda, shusia, maia, espresso
        vim.g.sonokai_better_performance = 1
        vim.g.sonokai_transparent_background = 1
      end,
    },
    {
      "rebelot/kanagawa.nvim",
      priority = 1000, -- load early so it's applied before other plugins
      lazy = false,
      config = function()
        -- Default options:
        require('kanagawa').setup({
          compile = false,             -- enable compiling the colorscheme
          undercurl = true,            -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true},
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = true,         -- do not set background color
          dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
          terminalColors = false,       -- define vim.g.terminal_color_{0,17}
          colors = {                   -- add/modify theme and palette colors
            palette = {},
            theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
          },
          overrides = function(_) -- add/modify highlights
            return {}
          end,
          theme = "wave",              -- Load "wave" theme
          background = {               -- map the value of 'background' option to a theme
            dark = "wave",           -- try "dragon" !
            light = "lotus"
          },
        })
      end,
    },

    -- Indentation guides
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("ibl").setup({
          indent = { char = "┆" },
          scope = { enabled = true, show_start = true, show_end = true },
        })
      end,
    },

    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup({
          options = {
            theme = "auto",
            icons_enabled = false,
            section_separators = "",
            component_separators = "|",
            disabled_filetypes = {},
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = {},
            lualine_c = { { "filename", path = 2 } }, -- full path
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { "filename", path = 2 } },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
          },
        })
      end,
    },

    -- Highlight current word under cursor
    {
      "RRethy/vim-illuminate",
      event = "VeryLazy",
      config = function()
        vim.api.nvim_set_hl(0, "illuminatedWord",     { underline = true })
        vim.api.nvim_set_hl(0, "illuminatedCurWord",  { underline = true })
        vim.api.nvim_set_hl(0, "illuminatedWordText", { underline = true })
      end,
    },

    -- Better CSV visualization
    {
      "mechatroner/rainbow_csv",
      ft = "csv",
      init = function()
        vim.g.disable_rainbow_key_mappings = 0
      end,
    },

    -- Highlight interesting words for debug/focus
    {
      "lfv89/vim-interestingwords",
      init = function()
        vim.keymap.set(
          "n",
          "<leader>h",
          ':call InterestingWords("n")<cr>',
          { silent = true, desc = "Highlight word" }
        )

        vim.keymap.set(
          "v",
          "<leader>h",
          ':call InterestingWords("v")<cr>',
          { silent = true, desc = "Highlight selected text" }
        )

        vim.keymap.set(
          "n",
          "<leader>H",
          ":call UncolorAllWords()<cr>",
          { silent = true, desc = ":call UncolorAllWords" }
        )

        vim.g.interestingWordsTermColors = {
          '1', '8', '15', '22', '29', '36', '43', '50', '57', '64',
          '71', '78', '85', '92', '99', '106', '113', '120', '127', '134',
          '141', '148', '155', '162', '169', '176', '183', '190', '197', '204',
          '211', '218'
        }

        vim.g.interestingWordsGUIColors = {
          "#e06c75", "#61afef", "#98c379", "#c678dd",
          "#e5c07b", "#56b6c2", "#d19a66", "#abb2bf",
          "#be5046", "#7ec7a2", "#d387c7", "#a3be8c",
          "#b48ead", "#88c0d0", "#f0a25e", "#5e81ac",
        }
      end,
    },

    -- Better repeaters via .
    { "tpope/vim-repeat", event = "VeryLazy" },

    -- Toggle support for comments on different languages
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
        local api = require('Comment.api')

        vim.keymap.set('n', '<leader><leader>', function()
          api.toggle.linewise.current()
        end, { desc = "Toggle line comment" })

        vim.keymap.set(
          'x',
          '<leader><leader>',
          "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
          { desc = "Toggle visual comment" }
        )
      end,
    },

    -- Text objects
    { "kana/vim-textobj-user" }, -- dependency for others

    -- selects a section of word
    -- pressing: div
    -- produces: produ|ctOwner -> |Owner
    {
      "Julian/vim-textobj-variable-segment",
      dependencies = { "kana/vim-textobj-user" },
    },

    -- selects the next block available
    -- pressing: dib
    -- produces: "use|r" -> ""
    -- produces: 'use|r' -> ''
    -- produces: ( use|r ) -> ()
    -- etc
    {
      "rhysd/vim-textobj-anyblock",
      dependencies = { "kana/vim-textobj-user" },
    },

    -- Auto Closes

    -- Auto-pairs brackets, quotes, etc
    -- Integrates with Treesitter for smarter pairing
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({
          check_ts = true, -- Treesitter integration
        })

        -- Integrate with nvim-cmp
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on(
          "confirm_done",
          cmp_autopairs.on_confirm_done()
        )
      end,
    },

    -- Quickly add/change/delete surrounding characters:
    -- quotes, parentheses, tags, etc
    {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end,
    },

    -- Auto-closes HTML/XML tags, using Treesitter
    {
      "windwp/nvim-ts-autotag",
      ft = {
        "html",
        "xhtml",
        "xml",
        "php",
        "javascript",
        "typescriptreact",
        "javascriptreact",
      },
      event = "InsertEnter",
      opts = {},
    },

    -- Auto-completes block-ending keywords:
    -- like end in Lua/Ruby
    {
      "tpope/vim-endwise",
      ft = {
        "lua",
        "ruby",
        "elixir",
        "sh",
        "bash",
        "zsh",
      },
      event = "InsertEnter",
    },

    -- Project / Folder tree
    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup({
          -- example setup, tweak to your preference
          view = {
            width = 30,
            side = "left",
          },
          renderer = {
            icons = {
              show = {
                file = false,
                folder = false,
                folder_arrow = false,
                git = false,
              },
            },
          },
          filters = {
            dotfiles = false,
          },
        })
        vim.keymap.set("n", "<leader>tp", ":NvimTreeToggle<CR>", { desc = ":NvimTreeToggle" })
      end,
    },

    -- Provide context to code being read
    {
      "wellle/context.vim",
      init = function()
        vim.g.context_add_mappings = 0
        vim.g.context_add_autocmds = 0
        vim.g.context_filetype_blacklist = { "nerdtree" }

        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            vim.cmd("ContextActivate")
          end,
        })
        vim.api.nvim_create_autocmd({ "CursorHold", "BufWritePost" }, {
          callback = function()
            vim.cmd("ContextUpdate")
          end,
        })

        vim.keymap.set(
          "n",
          "<leader>tc",
          function()
            vim.cmd("ContextToggle")
          end,
          { silent = true, desc = "Toggle Context plugin" }
        )
      end,
    },

    -- Symbols outline
    {
      "stevearc/aerial.nvim",
      config = function()
        require("aerial").setup({
          backends = { "lsp", "treesitter", "markdown" }, -- prioritize LSP, fallback to Treesitter
          layout = {
            min_width = 25,
            max_width = 40,
            default_direction = "prefer_right",
          },
          show_guides = true,
          highlight_on_hover = true,
        })

        -- Keymap to toggle the aerial sidebar (symbols)
        vim.keymap.set("n", "<leader>ts", ":AerialToggle!<CR>", { silent = true, desc = "Toggle Symbols outline" })
      end,
    },

    -- TreeSJ for join/split blocks
    {
      "Wansmer/treesj",
      keys = {
        { "<leader>lt", ":TSJToggle<CR>", desc = "Toggle Split/Join format" },
      },
      cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
      config = function()
        require("treesj").setup({
          use_default_keymaps = false,
          check_syntax_error = true,
          max_join_length = 2048,
          cursor_behavior = "hold",
          notify = true,
          dot_repeat = true,
        })
      end,
    },

    -- Multi-cursor
    {
      "mg979/vim-visual-multi",
      init = function()
        vim.g.VM_default_mappings = 0
        vim.g.VM_mouse_mappings = 0
        vim.g.VM_silent_exit = 1
        vim.g.VM_show_warnings = 0
      end,
      keys = {
        { "<C-n>", desc = "Multi Cursor: add cursor" },
        { "<C-x>", desc = "Multi Cursor: skip match" },
      },
    },

    -- Tabular alignment
    {
      "echasnovski/mini.nvim",
      version = false,   -- track HEAD
      event   = "VeryLazy",
      config  = function()
        -- Mini-Align defaults: hit ga, type delimiter, <Enter>
        require("mini.align").setup({
          -- example preset: align “key = value” on the = with one space padding
          mappings = {
            start = "ga",          -- normal/visual
          },
        })
      end,
    },

    -- ===================
    -- Search
    -- ===================

    -- Search by using *
    {
      "nelstrom/vim-visual-star-search",
      keys = { "*", "#", "g*", "g#" },
    },

    -- Better search indexes shown
    {
      "kevinhwang91/nvim-hlslens",
      keys = { "n", "N", "*", "#", "g*", "g#" },
      config = function()
        vim.keymap.set(
          "n",
          "n",
          [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
          { silent = true }
        )

        vim.keymap.set(
          "n",
          "N",
          [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
          { silent = true }
        )

        vim.keymap.set(
          "n",
          "*",
          [[*<Cmd>lua require('hlslens').start()<CR>]],
          { silent = true }
        )

        vim.keymap.set(
          "n",
          "#",
          [[#<Cmd>lua require('hlslens').start()<CR>]],
          { silent = true }
        )

        vim.keymap.set(
          "n",
          "g*",
          [[g*<Cmd>lua require('hlslens').start()<CR>]],
          { silent = true }
        )

        vim.keymap.set(
          "n",
          "g#",
          [[g#<Cmd>lua require('hlslens').start()<CR>]],
          { silent = true }
        )
      end,
    },

    -- Fuzzy search
    { "nvim-lua/plenary.nvim" }, -- dependency

    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "gf", mode = { "n", "v" }, desc = "Fuzzy search for word/selection" },
        { "gs", mode = { "n", "v" }, desc = "Exact search for word/selection" },
      },
      config = function()
        local telescope = require("telescope")

        telescope.setup({
          defaults = {
            color_devicons = false,

            -- Use relative paths
            path_display = { "relative" },

            -- Layout: use 95% of window width and height
            layout_config = {
              width = 0.95,
              height = 0.95,
              preview_cutoff = 1,
            },

            -- Remove icons
            prompt_prefix = " ",
            selection_caret = " ",
            entry_prefix = " ",
            multi_icon = " ",

            -- Disable folds in preview for performance
            preview = {
              win_config = {
                winhl = "Normal:Normal",
              },
            },
          },
        })

        -- Save and restore fold settings around Telescope invocation
        local function telescope_no_folds_search(search_fn, opts)
          -- Save current fold settings
          local foldenable = vim.wo.foldenable
          local foldmethod = vim.wo.foldmethod
          local foldlevel = vim.wo.foldlevel

          -- Disable folds for maximum performance
          vim.wo.foldenable = false

          -- Run Telescope
          search_fn(opts)

          -- Restore fold settings after closing Telescope
          vim.api.nvim_create_autocmd("WinLeave", {
            once = true,
            callback = function()
              vim.wo.foldenable = foldenable
              vim.wo.foldmethod = foldmethod
              vim.wo.foldlevel = foldlevel
            end,
          })
        end

        -- Fuzzy search (fuzzy matching)
        vim.keymap.set("n", "gf", function()
          local word = vim.fn.expand("<cword>")
          telescope_no_folds_search(require("telescope.builtin").live_grep, {
            default_text = word,
          })
        end, { desc = "Fuzzy search for word under cursor (folds disabled)" })

        vim.keymap.set("v", "gf", function()
          local text = vim.fn.getreg("v")
          telescope_no_folds_search(require("telescope.builtin").live_grep, {
            default_text = text,
          })
        end, { desc = "Fuzzy search for selected text (folds disabled)" })

        -- Exact search (literal)
        vim.keymap.set("n", "gs", function()
          local word = vim.fn.expand("<cword>")
          telescope_no_folds_search(require("telescope.builtin").live_grep, {
            default_text = word,
            additional_args = function(args)
              table.insert(args, "--fixed-strings")
              return args
            end,
          })
        end, { desc = "Exact search for word under cursor (folds disabled)" })

        vim.keymap.set("v", "gs", function()
          local text = vim.fn.getreg("v")
          telescope_no_folds_search(require("telescope.builtin").live_grep, {
            default_text = text,
            additional_args = function(args)
              table.insert(args, "--fixed-strings")
              return args
            end,
          })
        end, { desc = "Exact search for selected text (folds disabled)" })
      end,
    },

    -- ===================
    -- Diff
    -- ===================

    -- Improves vim-diff
    { "chrisbra/vim-diff-enhanced" },

    -- On diff, shows it at character level
    { "rickhowe/diffchar.vim" },

    -- Allow comparing 2 pieces of text in the buffer
    {
      "AndrewRadev/linediff.vim",
      cmd = { "Linediff", "LinediffReset" },
      init = function()
        vim.keymap.set("v", "<leader>d", ":Linediff<cr>", { silent = true, desc = ":Linediff" })
        vim.keymap.set("n", "<leader>D", ":LinediffReset<cr>", { silent = true, desc = ":LinediffReset" })
      end,
    },

    -- ===================
    -- Git
    -- ===================

    -- Git hunks navigation and Git signs
    {
      "mhinz/vim-signify",
      event = { "BufReadPre", "BufNewFile" },
      init = function()
        -- Only use Git as VCS
        vim.g.signify_vcs_list = { "git" }

        -- Enable showing number of deleted lines
        vim.g.signify_number_highlight = 1
        vim.g.signify_sign_show_count = 0
        vim.g.signify_line_highlight = 0 -- avoid background color highlight if you want minimalism

        -- Change the sign symbols
        vim.g.signify_sign_add    = '+'
        vim.g.signify_sign_change = '~'
        vim.g.signify_sign_delete = '-'

        -- Keymaps for navigating between hunks
        vim.keymap.set("n", "]g", "<Plug>(signify-next-hunk)", { desc = "Next Git hunk" })
        vim.keymap.set("n", "[g", "<Plug>(signify-prev-hunk)", { desc = "Previous Git hunk" })
      end,
    },

    -- Good git diff preview on neovim
    {
      "sindrets/diffview.nvim",
      lazy = false, -- disable lazy-loading so bash vimreview works
      config = function()
        require("diffview").setup({
          use_icons = false,
        })

        -- Automatically refresh diffview on focus regain
        vim.api.nvim_create_autocmd("FocusGained", {
          callback = function()
            -- Check if diffview is open
            local view = require("diffview.lib").get_current_view()
            if view then
              -- Refresh the diffview
              vim.cmd("DiffviewRefresh")
            end
          end,
        })

        -- Auto disable context plugin in diffview buffers
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "DiffviewFiles,DiffviewFileHistory",
          callback = function()
            vim.cmd("ContextDisable")
          end,
        })
        vim.api.nvim_create_autocmd("BufEnter", {
          callback = function()
            local bufname = vim.api.nvim_buf_get_name(0)
            if bufname:match("DiffviewFilePanel") or 
               bufname:match("DiffviewFiles") or 
               bufname:match("DiffviewFileHistory") then
              vim.cmd("ContextDisable")
            end
          end,
        })

        -- Toggle Diffview (open/close) CustomDiffviewOpen
        vim.keymap.set({ "n", "v" }, "<leader>td", function()
          local view = require("diffview.lib").get_current_view()
          if view then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end, { desc = "Toggle git diff" })

        -- Toggle the file panel inside Diffview
        vim.keymap.set("n", "<leader>tm", "<Cmd>DiffviewToggleFiles<CR>", {
          desc = "Toggle git diff menu",
        })
      end,
    },

    -- Git conflict navigation and resolution
    {
      'akinsho/git-conflict.nvim',
      version = "*",
      config = true,
    },

    -- Git blame
    {
      "f-person/git-blame.nvim",
      cmd = "GitBlameToggle",
      init = function()
        vim.g.gitblame_enabled = 0

        vim.keymap.set(
          "n",
          "<leader>tb",
          ":GitBlameToggle<CR>",
          { silent = true, desc = ":GitBlameToggle" }
        )
      end,
    },

    -- ===================
    -- Snippets
    -- ===================

    -- Inside nvm-cmp completion engine, since I trigger snippet in completion, after : is typed

    -- ===================
    -- Auto Completion
    -- ===================

    -- Main completion plugin
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "ray-x/cmp-treesitter",
        "petertriho/cmp-git", -- git completions
        "f3fora/cmp-spell", -- spelling suggestions
        "kristijanhusak/vim-dadbod-completion", -- SQL DB completions
        "uga-rosa/cmp-dictionary", -- dictionary completions
        "tamago324/cmp-zsh", -- Zsh completions
        "delphinus/cmp-ctags", -- tags completions
        "hrsh7th/cmp-omni", -- Omni completions
        "andersevenrud/cmp-tmux", -- Tmux completions
        -- TODO: completion from browser
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local fmt     = require("luasnip.extras.fmt").fmt

        -- Snippet helpers
        local s = luasnip.snippet
        local i = luasnip.insert_node

        luasnip.add_snippets("javascript", {
          s(
            ";if_solo",
            fmt([[
              if ({}) {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";if_else", fmt([[
              if ({}) {{
              }} else {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";if_else_if",
            fmt([[
              if ({}) {{
              }} else if () {{
              }} else {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";switch",
            fmt([[
              switch ({}) {{
                case '': {{
                }}
                default: {{
                }}
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";for_i", fmt([[
              for (let i = 0; i < {}; i++) {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";for_let", fmt([[
              for (let {} of []) {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";while",
            fmt([[
              while ({}) {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";func_decl",
            fmt([[
              function ({}) {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";func_named", fmt([[
              const {} = function () {{
              }};
            ]], { i(1, " ") })
          ),

          s(
            ";func_arr_decl",
            fmt([[
              ({}) => {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";func_arr_named",
            fmt([[
              const {} = () => {{
              }};
            ]], { i(1, " ") })
          ),

          s(
            ";class_decl",
            fmt([[
              class {} {{
                constructor() {{
                }}
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";class_meth",
            fmt([[
              {}() {{
              }}
            ]], { i(1, " ") })
          ),

          s(
            ";export",
            fmt([[
              export default {{
                {}
              }};
            ]], { i(1, " ") })
          ),

          s(
            ";import",
            fmt([[
              import {} from '';
            ]], { i(1, " ") })
          ),

          s(
            ";required",
            fmt([[
              const {} = require('');
            ]], { i(1, " ") })
          ),
        })

        -- Also apply the same set for TypeScript
        luasnip.add_snippets("typescript", luasnip.get_snippets("javascript"))

        -- Python
        -- TODO: same of javascript, but ported to Python

        -- Shell
        -- TODO: same of javascript, but ported to Shell

        -- Go
        -- TODO: same of javascript, but ported to Go

        vim.api.nvim_create_autocmd("User", {
          pattern = "LuasnipInsertNodeEnter",
          callback = function()
            vim.cmd("normal! `[=']")  -- re-indent just the snippet range
          end,
        })

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end
          },
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort()
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "luasnip" },
            { name = "nvim_lua" },
            { name = "buffer" },
            { name = "path" },
            { name = "cmp_zsh" },
            { name = "treesitter" },
            { name = "omni" },
            { name = "tmux" }
          }),
          formatting = {
            format = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lsp_signature_help = "[Sign]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                cmp_zsh = "[Zsh]",
                treesitter = "[TS]",
                omni = "[Omni]",
                tmux = "[Tmux]"
              })[entry.source.name] or ""
              return vim_item
            end
          }
        })
      end
    },

    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Disable tsserver formatting to let null-ls handle it
        local on_attach = function(client, _)
          if client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end

        -- List of LSP servers to enable
        local servers = {
          "ts_ls",        -- JavaScript / TypeScript
          "pyright",      -- Python
          "gopls",        -- Go
          "dockerls",     -- Docker
          "html",         -- HTML
          "cssls",        -- CSS
          "jsonls",       -- JSON
          "yamlls",       -- YAML
          "prismals",     -- Prisma
          "sqlls",        -- SQL
          "terraformls",  -- Terraform
          "lua_ls",       -- Lua
          "bashls",       -- Shell scripts
        }

        for _, server in ipairs(servers) do
          local opts = {
            capabilities = capabilities,
            on_attach = on_attach,
          }

          -- If configuring lua_ls, set the "vim" global
          if server == "lua_ls" then
            opts.settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            }
          end

          lspconfig[server].setup(opts)
        end

        -- Keymaps
        vim.keymap.set(
          "n",
          "gd",
          vim.lsp.buf.definition,
          { desc = "Go to definition" }
        )

        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          { desc = "Go to implementation" }
        )

        vim.keymap.set(
          "n",
          "gr",
          vim.lsp.buf.references,
          { desc = "Show references" }
        )

        vim.keymap.set(
          "n",
          "<leader>vs",
          vim.lsp.buf.hover,
          { desc = "Show signature/doc" }
        )

        vim.keymap.set(
          "n",
          "<leader>r",
          vim.lsp.buf.rename,
          { desc = "Rename symbol" }
        )

        vim.keymap.set("n", "<leader>f", function()
          -- Auto fix imports first
          local params = {
            textDocument = vim.lsp.util.make_text_document_params(),
            context = { only = { "source.addMissingImports.ts" } },
            range = {
              start = { line = 0, character = 0 },
              ["end"] = { line = vim.fn.line("$") - 1, character = 0 },
            },
          }

          vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, actions)
            if err then
              vim.notify("LSP error: " .. err.message, vim.log.levels.ERROR)
              return
            end

            if not actions or vim.tbl_isempty(actions) then
              vim.notify("No import fixes available", vim.log.levels.INFO)
              -- Still format even if no imports found
              vim.lsp.buf.format({ async = true })
              return
            end

            local action = actions[1]

            local function after_imports()
              -- Delay formatting slightly to ensure edits are applied after
              vim.defer_fn(function()
                vim.lsp.buf.format({ async = true })
              end, 10)
            end

            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
            end

            if action.command then
              vim.lsp.buf.execute_command(action.command)
              after_imports()
            else
              after_imports()
            end
          end)
        end, { desc = "Auto Fix Lint/Formatting/Imports" })

        vim.keymap.set("n", "<leader>vd", function()
          local opts = {
            focusable = true,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = "",
            scope = "line", -- show all diagnostics on the current line
          }
          vim.diagnostic.open_float(nil, opts)
        end, { noremap = true, silent = true , desc = "Show diagnostic for current line" })
      end,
    },

    -- ===================
    -- Lint
    -- ===================

    {
      "nvimtools/none-ls-extras.nvim",
    },

    {
      "nvimtools/none-ls.nvim",
      dependencies = { "nvimtools/none-ls-extras.nvim" },
      config = function()
        local null_ls = require("null-ls")
        local diagnostics = null_ls.builtins.diagnostics

        -- Use eslint_d from none-ls-extras
        local eslint_d = require("none-ls.diagnostics.eslint_d")
        local eslint_d_format = require("none-ls.formatting.eslint_d")

        null_ls.setup({
          debug = false,
          sources = {
            -- ESLint diagnostics (from none-ls-extras)
            eslint_d.with({
              condition = function(utils)
                return utils.root_has_file({
                  ".eslintrc",
                  ".eslintrc.js",
                  ".eslintrc.json",
                  "package.json",
                })
              end,
            }),

            -- ESLint formatting (also from none-ls-extras)
            eslint_d_format.with({
              condition = function(utils)
                return utils.root_has_file({
                  ".eslintrc",
                  ".eslintrc.js",
                  ".eslintrc.json",
                  "package.json",
                })
              end,
            }),

            -- Lua
            -- Done via LSP

            -- Python
            -- Done via LSP

            -- Shell
            -- Done via LSP

            -- Markdown
            diagnostics.markdownlint,

            -- YAML
            diagnostics.yamllint,
          },
        })
      end,
    },

    -- ===================
    -- AI
    -- ===================

    {
      "olimorris/codecompanion.nvim",
      version = false,
      event = "VeryLazy",

      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },

      config = function()
        -- Choose which model to use here
        -- They are defined on the "adapters" section below
        local model = "openai_4o"

        require("codecompanion").setup({
          adapters = {
            opts = {
              show_model_choices = true,
              show_defaults = true,
            },

            -- OpenAI GPT-4o adapter
            openai_4o = function()
              return require("codecompanion.adapters").extend("openai", {
                schema = {
                  model = {
                    default = "gpt-4o",
                  },
                },
              })
            end,

            -- OpenAI GPT-o4-mini adapter (can be useful if throttling is happening)
            openai_o4_mini = function()
              return require("codecompanion.adapters").extend("openai", {
                schema = {
                  model = {
                    default = "gpt-4o-mini",
                  },
                },
              })
            end,

            -- Anthropic Sonnet 3.7 adapter (just in case)
            anthropic_sonnet = function()
              return require("codecompanion.adapters").extend("anthropic", {
                schema = {
                  model = {
                    default = "claude-3-7-sonnet-20250219",
                  },
                },
              })
            end,
          },

          strategies = {
            chat   = {
              adapter = model,
            },

            inline = {
              adapter = model,
            },
          },

          display = {
            inline = {
              layout = "vertical", -- vertical, horizontal, buffer
            },
            chat   = {
              window = {
                layout = "float", -- float, vertical, horizontal, buffer
              },
            },
            diff = {
              enabled = false,
            },
          },
        })

        local opts = { noremap = true, silent = true }

        -- AI Abort: Just press 'q' inside the response buffer

        -- AI Ask —------------------------------------------------------
        vim.keymap.set("n", "<leader>aa", function()
          vim.ui.input({ prompt = "Ask AI: " }, function(q)
            if not q or q == "" then return end
            vim.cmd("CodeCompanionChat #buffer " .. vim.fn.shellescape(q))
          end)
        end, vim.tbl_extend("force", opts, { desc = "AI Ask buffer" }))

        vim.keymap.set("x", "<leader>aa", function()
          local s = vim.fn.line("'<")
          local e = vim.fn.line("'>")
          vim.ui.input({ prompt = "Ask AI: " }, function(q)
            if not q or q == "" then return end
            vim.cmd(string.format("%d,%dCodeCompanionChat %s", s, e, vim.fn.shellescape(q)))
          end)
        end, vim.tbl_extend("force", opts, { desc = "AI Ask selection" }))

        -- AI Explain -----------------------------------------------------
        vim.keymap.set(
          "n",
          "<leader>ae",
          "<cmd>%CodeCompanion /explain<CR>",
          vim.tbl_extend("force", opts, { desc = "AI Explain buffer" })
        )

        vim.keymap.set(
          "x",
          "<leader>ae",
          ":'<,'>CodeCompanion /explain<CR>",
          vim.tbl_extend("force", opts, { desc = "AI Explain selection" })
        )

        -- AI Code Edit --------------------------------------------------
        vim.keymap.set(
          "n",
          "<leader>ac",
          "<cmd>%CodeCompanion<CR>",
          vim.tbl_extend("force", opts, { desc = "AI Edit buffer" })
        )

        vim.keymap.set(
          "x",
          "<leader>ac",
          ":'<,'>CodeCompanion<CR>",
          vim.tbl_extend("force", opts, { desc = "AI Edit selection" })
        )

        -- AI Diagnose Explain -------------------------------------------
        vim.keymap.set("n", "<leader>ad", function()
          local prompt = [[What are the issues in this code? Start with TL;DR H3 containing a bullet list, then explain each issue in detail below.]]
          vim.cmd("CodeCompanionChat #buffer #lsp /quickfix " .. vim.fn.shellescape(prompt))
        end, vim.tbl_extend("force", opts, { desc = "AI Diagnostic Explain (buffer + LSP + Quickfix)" }))
      end,
    },

    -- ===================
    -- Previewers
    -- ===================

    -- Markdown preview
    {
      "iamcco/markdown-preview.nvim",
      build = "cd app && npm install",
      ft = { "markdown", "mermaid", "ghmarkdown" },
      init = function()
        vim.g.mkdp_command_for_global = 1
        vim.g.mkdp_refresh_slow = 1
        vim.g.mkdp_preview_options = {
          sync_scroll_type = "middle",
        }

        vim.keymap.set(
          "n",
          "<leader>vm",
          "<Plug>MarkdownPreviewToggle",
          { silent = true, desc = ":MarkdownPreviewToggle" }
        )
      end,
    },
  },
})

-- Custom indentation conversion commands
-- Convert spaces to tabs
vim.api.nvim_create_user_command("ToTabs", function()
  -- Save current position
  local view = vim.fn.winsaveview()

  -- Execute the conversion
  vim.cmd([[set noexpandtab]])
  vim.cmd([[retab!]])

  -- Restore position
  vim.fn.winrestview(view)

  vim.notify("Converted spaces to tabs", vim.log.levels.INFO)
end, {})

-- Convert to 2 spaces
vim.api.nvim_create_user_command("To2Spaces", function()
  -- Save current position
  local view = vim.fn.winsaveview()

  -- Set values for 2-space indentation
  vim.bo.tabstop = 2
  vim.bo.shiftwidth = 2
  vim.bo.softtabstop = 2
  vim.bo.expandtab = true

  -- Execute the conversion
  vim.cmd([[retab]])
  
  -- Reindent the entire file
  vim.cmd([[normal! gg=G]])

  -- Restore position
  vim.fn.winrestview(view)

  vim.notify("Converted to 2-space indentation", vim.log.levels.INFO)
end, {})

-- Convert to 4 spaces
vim.api.nvim_create_user_command("To4Spaces", function()
  -- Save current position
  local view = vim.fn.winsaveview()

  -- Set values for 4-space indentation
  vim.bo.tabstop = 4
  vim.bo.shiftwidth = 4
  vim.bo.softtabstop = 4
  vim.bo.expandtab = true

  -- Execute the conversion
  vim.cmd([[retab]])
  
  -- Reindent the entire file
  vim.cmd([[normal! gg=G]])

  -- Restore position
  vim.fn.winrestview(view)

  vim.notify("Converted to 4-space indentation", vim.log.levels.INFO)
end, {})

vim.cmd.colorscheme(colorscheme)
