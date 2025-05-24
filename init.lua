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

function _G.toggle_foldmethod()
  local current_foldmethod = vim.opt.foldmethod:get()
  if current_foldmethod == 'indent' then
    vim.opt.foldmethod = 'syntax'
  else
    vim.opt.foldmethod = 'indent'
  end
end

vim.api.nvim_create_user_command('Msglog', function()
  -- Get message history
  local output = vim.api.nvim_exec('messages', true)
  local lines = vim.split(output, '\n')

  -- Open a new split buffer
  vim.cmd.new()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.bo.filetype = 'messages'
end, {})

-- =======================================
-- Core Settings
-- =======================================

vim.opt.encoding='utf-8'

vim.opt.updatetime = 500

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
if vim.opt.diff then
  vim.cmd.colorscheme("jellybeans")
end

-- General vision
vim.opt.lbr = true
vim.opt.scrolloff = 999  -- Cursor is always in the middle of screen

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
vim.keymap.set('n', '<leader>tf', '<Cmd>lua _G.toggle_foldmethod()<CR>', { silent = false })

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
vim.keymap.set('n', '<leader>tn', ':set number!<cr>', { silent = true })

-- Search only in visual selection
vim.keymap.set('v', '/', '<esc>/\\%V', { silent = true })

-- PrettyXML: Format a line of XML
vim.keymap.set('v', '<leader>Fxml', ':!xmllint --format --recover - 2>/dev/null<cr>', { silent = true })

-- PrettyPSQL: Format a line of PSQL
vim.keymap.set('v', '<leader>Fpsql', ':!pg_format -f 0 -s 2 -u 0<cr>', { silent = true })

-- Selected last pasted text
vim.keymap.set('n', 'gp', "V']", { silent = true })

-- Autoformat pasted text
vim.keymap.set('n', 'p', 'p=`]', { silent = true })
vim.keymap.set('n', 'P', 'P=`]', { silent = true })

-- View a formatted JSON is a new buffer
vim.keymap.set('v', '<leader>vj', 'y:vnew<cr>pV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>', { silent = true })

-- Preview for HTML
vim.keymap.set('n', '<leader>vh', ':!open % &<cr>', { noremap = false, silent = true })

-- Preview for OpenAPI
vim.keymap.set('n', '<leader>vo', ':!rm -fr /tmp/brunogsa-vim-openapi-preview.html && npx redocly build-docs % --output /tmp/brunogsa-vim-openapi-preview.html && open /tmp/brunogsa-vim-openapi-preview.html &<cr>', { noremap = false, silent = true })

-- Preview for AsyncAPI
vim.keymap.set('n', '<leader>va', ':!rm -fr /tmp/brunogsa-vim-asyncapi-preview && ag % @asyncapi/html-template -o /tmp/brunogsa-vim-asyncapi-preview && open /tmp/brunogsa-vim-asyncapi-preview/index.html &<cr>', { noremap = false, silent = true })

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
  spec = {
    -- ===================
    -- Highlight
    -- ===================

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
          overrides = function(colors) -- add/modify highlights
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
      tag = "v3.8.6",
      config = function()
        require("ibl").setup({
          indent = { char = "┆" },
          scope = { enabled = true, show_start = true, show_end = true },
        })
      end,
    },

    -- Only highlight current window's cursorline
    { "vim-scripts/CursorLineCurrentWindow" },

    -- CSV
    {
      "mechatroner/rainbow_csv",
      ft = "csv",
      init = function()
        vim.g.disable_rainbow_key_mappings = 0
      end,
    },

    -- ===================
    -- Core
    -- ===================
    {
      "liuchengxu/vim-which-key",
      init = function()
        vim.keymap.set('n', '<leader>', ":<c-u>WhichKey '<Space>'<CR>", { silent = true })
        vim.keymap.set('v', '<leader>', ":<c-u>WhichKeyVisual '<Space>'<CR>", { silent = true })
      end,
      event = "VeryLazy",
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
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
    {
      "szw/vim-maximizer",
      cmd = "MaximizerToggle",
      init = function()
        vim.g.maximizer_set_default_mapping = 0

        vim.keymap.set('n', '<leader><F3>', ':MaximizerToggle<CR>', { silent = true })
        vim.keymap.set('n', '<C-w>z', ':MaximizerToggle<CR>', { silent = true })
      end,
    },
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
        local api = require('Comment.api')

        vim.keymap.set('n', '<leader><leader>', function()
          api.toggle.linewise.current()
        end, { desc = "Toggle line comment" })

        vim.keymap.set('x', '<leader><leader>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle visual comment" })
      end,
    },
    {
      "Valloric/ListToggle",
      init = function()
        vim.g.lt_location_list_toggle_map = "<leader>tl"
        vim.g.lt_quickfix_list_toggle_map = "<leader>tq"
      end,
      cmd = { "LTLocationListToggle", "LTQuickfixListToggle" }, -- optional for lazy loading
    },
    {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end,
    },
    {
      "alvan/vim-closetag",
      ft = { "html", "xhtml", "phtml", "php", "jsx", "javascript" },
      event = "InsertEnter",
      init = function()
        vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"
      end,
    },
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

    { "chrisbra/vim-diff-enhanced" },
    { "rickhowe/diffchar.vim" },

    {
      "AndrewRadev/linediff.vim",
      cmd = { "Linediff", "LinediffReset" },
      init = function()
        vim.keymap.set("v", "<leader>d", ":Linediff<cr>", { silent = true })
        vim.keymap.set("n", "<leader>D", ":LinediffReset<cr>", { silent = true })
      end,
    },

    {
      "lfv89/vim-interestingwords",
      init = function()
        vim.keymap.set("n", "<leader>h", ':call InterestingWords("n")<cr>', { silent = true })
        vim.keymap.set("v", "<leader>h", ':call InterestingWords("v")<cr>', { silent = true })
        vim.keymap.set("n", "<leader>H", ":call UncolorAllWords()<cr>", { silent = true })

        vim.g.interestingWordsTermColors = {
          '1', '8', '15', '22', '29', '36', '43', '50', '57', '64',
          '71', '78', '85', '92', '99', '106', '113', '120', '127', '134',
          '141', '148', '155', '162', '169', '176', '183', '190', '197', '204',
          '211', '218'
        }
      end,
    },

    {
      "RRethy/vim-illuminate",
      event = "VeryLazy",
      config = function()
        vim.api.nvim_set_hl(0, "illuminatedWord",     { underline = true })
        vim.api.nvim_set_hl(0, "illuminatedCurWord",  { underline = true })
        vim.api.nvim_set_hl(0, "illuminatedWordText", { underline = true })
      end,
    },

    {
      "kevinhwang91/nvim-hlslens",
      config = function()
        vim.keymap.set("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], { silent = true })
        vim.keymap.set("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], { silent = true })
        vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
        vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
        vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
        vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
      end,
      event = "VeryLazy",
    },

    { "tpope/vim-endwise", event = "InsertEnter" },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "nelstrom/vim-visual-star-search", event = "VeryLazy" },
    { "sickill/vim-pasta" },
    { "conradirwin/vim-bracketed-paste" },

    -- Text objects
    { "michaeljsmith/vim-indent-object" },
    { "kana/vim-textobj-user" },
    {
      "paradigm/TextObjectify",
      dependencies = { "kana/vim-textobj-user" },
    },
    {
      "Julian/vim-textobj-variable-segment",
      dependencies = { "kana/vim-textobj-user" },
    },
    {
      "rhysd/vim-textobj-anyblock",
      dependencies = { "kana/vim-textobj-user" },
    },

    -- Troll stopper
    { "vim-utils/vim-troll-stopper", event = "VeryLazy" },

    -- Auto detect indentation
    { "tpope/vim-sleuth" },

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
        vim.keymap.set("n", "<leader>vm", "<Plug>MarkdownPreviewToggle", { silent = true })
      end,
    },

    -- Context.vim
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
            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              return ok and stats and stats.size > max_filesize
            end,
            additional_vim_regex_highlighting = false, -- Keep disable to avoid redraw exceeded time issues
          },
          indent = { enable = false },
          fold = { enable = true },
        })
      end,
    },

    -- Git blame
    {
      "f-person/git-blame.nvim",
      cmd = "GitBlameToggle",
      init = function()
        vim.g.gitblame_enabled = 0
        vim.keymap.set("n", "<leader>tg", ":GitBlameToggle<CR>", { silent = true })
      end,
    },

    -- Handle large files efficiently
    {
      "vim-scripts/LargeFile",
      event = "BufReadPre",
    },

    -- Tmux focus event support
    {
      "tmux-plugins/vim-tmux-focus-events",
      event = "VeryLazy",
    },

    -- NERDTree
    {
      "scrooloose/nerdtree",
      cmd = "NERDTreeToggle",
      init = function()
        vim.keymap.set("n", "<leader>tp", ":NERDTreeToggle<CR>")
        vim.g.NERDTreeHijackNetrw = 1
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
      event = "VeryLazy",
    },

    -- Smooth scrolling
    {
      "yuttie/comfortable-motion.vim",
      event = "VeryLazy",
    },

    -- TreeSJ for join/split blocks
    {
      "Wansmer/treesj",
      config = function()
        require("treesj").setup({
          use_default_keymaps = false,
          check_syntax_error = true,
          max_join_length = 2048,
          cursor_behavior = "hold",
          notify = true,
          dot_repeat = true,
        })

        vim.keymap.set("n", "<leader>lt", ":TSJToggle<CR>", { silent = true })
      end,
    },

    -- Tabular alignment
    {
      "godlygeek/tabular",
      cmd = "Tabularize",
    },

    -- Space/tab converter
    {
      "rhlobo/vim-super-retab",
      cmd = { "Space2Tab", "Tab2Space" },
    },

    -- ChatGPT + dependencies
    { "MunifTanjim/nui.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "folke/trouble.nvim" },
    { "nvim-telescope/telescope.nvim" },

    {
      "jackMort/ChatGPT.nvim",
      config = function()
        require("chatgpt").setup()
        vim.keymap.set({ "n", "v" }, "<leader>e", ":ChatGPTRun explain_code<CR>", { silent = false })
      end,
      cmd = { "ChatGPT", "ChatGPTRun" },
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim",
      },
    },

    -- ===================
    -- Snippets
    -- ===================

    -- TODO: Using LuaSnipets

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

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),        -- close the completion menu
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
            { name = "tmux" },
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
                tmux = "[Tmux]",
              })[entry.source.name] or ""
              return vim_item
            end,
          },
        })
      end,
    },

    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Example LSP servers (add more if needed!)
        local servers = {
          "ts_ls",
          "pyright",
          "gopls",
          "dockerls",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "prismals",
          "sqlls",
          "terraformls",
        }
        for _, server in ipairs(servers) do
          lspconfig[server].setup({
            capabilities = capabilities,
          })
        end

        -- Keymaps
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Show diagnostics" })
        vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      end,
    },

    -- ===================
    -- Lint
    -- ===================

    -- TODO: Add linter for node, typescript, shell, terraform, python, golang, markdown, json, csv, lua
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { colorscheme } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd.colorscheme(colorscheme)
