-- =======================================
-- Auxiliar Functions and Values
-- =======================================

HOME = os.getenv('HOME')

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
        vim.cmd.normal('g`"')
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

vim.cmd('syntax on')
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  command = "syntax sync fromstart",
})

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Larger bottom command panel, better for seeing auxiliar messages
vim.opt.cmdheight = 2

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

-- Make sure you use single quotes. It's here the plugins are stored
local Plug = vim.fn['plug#']
vim.call('plug#begin', HOME .. '/.local/share/nvim/plugged')


-- ===================
-- Core
-- ===================

Plug('neovim/python-client')

Plug('liuchengxu/vim-which-key')
-- Configs
  vim.keymap.set('n', '<leader>', ":<c-u>WhichKey '<Space>'<CR>", {silent = true})
  vim.keymap.set('v', '<leader>', ":<c-u>WhichKeyVisual '<Space>'<CR>", {silent = true})
-- *******

Plug('itchyny/lightline.vim')
-- Configs
  vim.g['lightline#bufferline#enable_devicons'] = 1

  vim.g.lightline = {
    colorscheme = 'seoul256',
    active = {
      left = {
        { 'mode', 'paste' },
        { 'readonly', 'absolutepath', 'modified' }
      }
    },
    component = {
      readonly = '%{&readonly?"READ-ONLY":""}',
      modified = '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
    },
    component_visible_condition = {
      readonly = '(&filetype!="help"&& &readonly)',
      modified = '(&filetype!="help"&&(&modified||!&modifiable))'
    },
    separator = { left = '', right = '' },
    subseparator = { left = '|', right = '|' }
  }
-- *******

Plug('szw/vim-maximizer', { on = 'MaximizerToggle' })
--Configs
  vim.g.maximizer_set_default_mapping = 0

  vim.keymap.set('n', '<leader><F3>', ':MaximizerToggle<CR>', { silent = true })
  vim.keymap.set('n', '<C-w>z', ':MaximizerToggle<CR>', { silent = true })
-- *******

Plug('numToStr/Comment.nvim')

Plug('Valloric/ListToggle')
-- Configs
  vim.g.lt_location_list_toggle_map = '<leader>tl'
  vim.g.lt_quickfix_list_toggle_map = '<leader>tq'
-- *******

Plug('tpope/vim-surround')

Plug('alvan/vim-closetag')
-- Configs
  vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js'
-- *******

Plug('jiangmiao/auto-pairs')
-- Configs
  vim.g.AutoPairsMultilineClose = 0
-- *******

Plug('chrisbra/vim-diff-enhanced')
Plug('rickhowe/diffchar.vim')

Plug('AndrewRadev/linediff.vim', { on = { 'Linediff', 'LinediffReset' } })
-- Configs
  vim.keymap.set('v', '<leader>d', ':Linediff<cr>', { silent = true })
  vim.keymap.set('n', '<leader>D', ':LinediffReset<cr>', { silent = true })
-- *******

Plug('lfv89/vim-interestingwords')
-- Configs
  vim.keymap.set('n', '<leader>h', ':call InterestingWords("n")<cr>', { silent = true })
  vim.keymap.set('v', '<leader>h', ':call InterestingWords("v")<cr>', { silent = true })
  vim.keymap.set('n', '<leader>H', ':call UncolorAllWords()<cr>', { silent = true })

  vim.g.interestingWordsTermColors = {
    '1', '8', '15', '22', '29', '36', '43', '50', '57', '64',
    '71', '78', '85', '92', '99', '106', '113', '120', '127', '134',
    '141', '148', '155', '162', '169', '176', '183', '190', '197', '204',
    '211', '218'
  }
-- *******

Plug('RRethy/vim-illuminate')

Plug('kevinhwang91/nvim-hlslens')
-- Configs
  vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], { silent = true })
  vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], { silent = true })
  vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
  vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
  vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
  vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], { silent = true })
-- *******

Plug('tpope/vim-endwise')

Plug('tpope/vim-repeat')
Plug('nelstrom/vim-visual-star-search')

Plug('sickill/vim-pasta')
Plug('conradirwin/vim-bracketed-paste')

Plug('michaeljsmith/vim-indent-object')
Plug('kana/vim-textobj-user')
Plug('paradigm/TextObjectify')
Plug('Julian/vim-textobj-variable-segment')
Plug('rhysd/vim-textobj-anyblock')

Plug('vim-utils/vim-troll-stopper')

Plug('tpope/vim-sleuth')

Plug('iamcco/markdown-preview.nvim', { ['for'] = 'ghmarkdown,mermaid', ['do'] = 'cd app && npm install' })
-- Configs
  vim.g.mkdp_command_for_global = 1
  vim.g.mkdp_refresh_slow = 1

  vim.g.mkdp_preview_options = {
    sync_scroll_type = 'middle'
  }

  vim.keymap.set('n', '<leader>vm', '<Plug>MarkdownPreviewToggle', {silent = true})
-- *******

Plug('wellle/context.vim')
-- Configs
  vim.g.context_add_mappings = 0
  vim.g.context_add_autocmds = 0
  vim.g.context_filetype_blacklist = { 'nerdtree' }

  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      vim.cmd('ContextActivate')
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'BufWritePost' }, {
    callback = function()
      vim.cmd('ContextUpdate')
    end,
  })
-- *******

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate<CR>' })

Plug('f-person/git-blame.nvim', { on = 'GitBlameToggle' })
-- Configs
  vim.g.gitblame_enabled = 0
  vim.keymap.set('n', '<leader>tg', ':GitBlameToggle<CR>', {silent = true})
-- *******

Plug('akinsho/git-conflict.nvim')
-- Post configs below
-- Hotkeys, as a quick note:
-- co — choose ours
-- ct — choose theirs
-- cb — choose both
-- c0 — choose none
-- ]x — move to previous conflict
-- [x — move to next conflict

Plug('vim-scripts/LargeFile')

Plug('tmux-plugins/vim-tmux-focus-events')

Plug('maksimr/vim-jsbeautify', { ['for'] = { 'javascript', 'typescript', 'css', 'scss', 'sass', 'json', 'html' }, on = { 'RangeJsBeautify', 'RangeJsonBeautify', 'RangeJsxBeautify', 'RangeHtmlBeautify', 'RangeCSSBeautify' } })
-- Configs
  vim.keymap.set('v', '<leader>Fjs', ':call RangeJsBeautify()<cr>', {silent = true})
  vim.keymap.set('v', '<leader>Fjson', 'di<cr><esc>VpV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>', {silent = true})
  vim.keymap.set('v', '<leader>Fjsx', ':call RangeJsxBeautify()<cr>', {silent = true})
  vim.keymap.set('v', '<leader>Fhtml', ':call RangeHtmlBeautify()<cr>', {silent = true})
  vim.keymap.set('v', '<leader>Fcss', ':call RangeCSSBeautify()<cr>', {silent = true})

  -- For additional configs, see: https://github.com/beautify-web/js-beautify
  vim.g.config_Beautifier = {
    js = {
      indent_style = 'space',
      indent_size = '2'
    },
    json = {
      indent_style = 'space',
      indent_size = '2'
    },
    jsx = {
      indent_style = 'space',
      indent_size = '2'
    },
    html = {
      indent_style = 'space',
      indent_size = '2'
    },
    css = {
      indent_style = 'space',
      indent_size = '2'
    }
  }
-- *******

Plug('prettier/vim-prettier', { ['do'] = 'yarn install', branch = 'release/1.x', ['for'] = { 'javascript', 'typescript', 'css', 'scss', 'sass', 'json', 'html' }, on = '<Plug>(Prettier)' })
-- Configs
  vim.keymap.set('n', '<leader>Fjs', '<Plug>(Prettier)', {silent = true})
  vim.keymap.set('n', '<leader>Fjson', '<Plug>(Prettier)', {silent = true})
  vim.keymap.set('n', '<leader>Fjsx', '<Plug>(Prettier)', {silent = true})
  vim.keymap.set('n', '<leader>Fhtml', '<Plug>(Prettier)', {silent = true})
  vim.keymap.set('n', '<leader>Fcss', '<Plug>(Prettier)', {silent = true})
  vim.keymap.set('n', '<leader>Fscss', '<Plug>(Prettier)', {silent = true})
  vim.keymap.set('n', '<leader>Fsass', '<Plug>(Prettier)', {silent = true})

  vim.g['prettier#autoformat'] = 0

  -- max line length that prettier will wrap on
  -- Prettier default: 80
  vim.g['prettier#config#print_width'] = 80

  -- number of spaces per indentation level
  -- Prettier default: 2
  vim.g['prettier#config#tab_width'] = 2

  -- use tabs over spaces
  -- Prettier default: false
  vim.g['prettier#config#use_tabs'] = 'false'

  -- print semicolons
  -- Prettier default: true
  vim.g['prettier#config#semi'] = 'true'

  -- single quotes over double quotes
  -- Prettier default: false
  vim.g['prettier#config#single_quote'] = 'true'

  -- print spaces between brackets
  -- Prettier default: true
  vim.g['prettier#config#bracket_spacing'] = 'true'

  -- put > on the last line instead of new line
  -- Prettier default: false
  vim.g['prettier#config#jsx_bracket_same_line'] = 'false'

  -- avoid|always
  -- Prettier default: avoid
  vim.g['prettier#config#arrow_parens'] = 'avoid'

  -- none|es5|all
  -- Prettier default: none
  vim.g['prettier#config#trailing_comma'] = 'all'

  -- flow|babylon|typescript|css|less|scss|json|graphql|markdown
  -- Prettier default: babylon
  vim.g['prettier#config#parser'] = 'babylon'

  -- cli-override|file-override|prefer-file
  vim.g['prettier#config#config_precedence'] = 'prefer-file'

  -- always|never|preserve
  vim.g['prettier#config#prose_wrap'] = 'preserve'
-- *******

Plug('scrooloose/nerdtree', { on = 'NERDTreeToggle' })
-- Configs
  vim.keymap.set('n', '<leader>tp', ':NERDTreeToggle<CR>')
  vim.g.NERDTreeHijackNetrw = 1
-- *******

Plug('mg979/vim-visual-multi')
-- Configs
  vim.g.VM_default_mappings = 0
  vim.g.VM_mouse_mappings = 0
  vim.g.VM_silent_exit = 1
  vim.g.VM_show_warnings = 0
-- *******

Plug('yuttie/comfortable-motion.vim')

-- Plugin for joining / splitting
Plug('Wansmer/treesj', { on = { 'TSJToggle' } })
-- Additional configs down below
  vim.keymap.set('n', '<leader>lt', ':TSJToggle<CR>', {silent = true})
-- *******

Plug('godlygeek/tabular', { on = 'Tabularize' })

Plug('rhlobo/vim-super-retab', { on = { 'Space2Tab', 'Tab2Space' } })

-- All below are dependencies for ChatGPT plugin
Plug('MunifTanjim/nui.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('folke/trouble.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('jackMort/ChatGPT.nvim')
-- Additional configs down below
  vim.keymap.set({'n', 'v'}, '<leader>e', ':ChatGPTRun explain_code<CR>', { silent = false })
-- *******


-- ===================
-- Highlight
-- ===================

-- Colorscheme
Plug('sainnhe/sonokai')
vim.g.sonokai_style = 'espresso'
vim.g.sonokai_better_performance = 1
vim.g.sonokai_transparent_background = 1

Plug('martinda/Jenkinsfile-vim-syntax', { ['for'] = 'Jenkinsfile' })

Plug('posva/vim-vue', { ['for'] = 'vue' })

Plug('tpope/vim-git', { ['for'] = 'gitcommit' })


Plug('hashivim/vim-terraform', { ['for'] = 'terraform' })
-- Configs
  vim.g.terraform_align = 0
  vim.g.terraform_fold_sections = 0
  vim.g.terraform_fmt_on_save = 0
-- *******

Plug('cuducos/yaml.nvim', { ['for'] = 'yaml' })

-- typescript highlight for .ts and .d.ts files
Plug('leafgarland/typescript-vim', { ['for'] = 'typescript' })
-- Configs
  vim.g.typescript_compiler_binary = 'tsc'
  vim.g.typescript_compiler_options = ''
-- *******

-- extend typescript + DOM keywords
Plug('HerringtonDarkholme/yats.vim', { ['for'] = 'typescript' })

Plug('peitalin/vim-jsx-typescript', { ['for'] = 'typescript' })

Plug('styled-components/vim-styled-components', { branch = 'main' })

Plug('lukas-reineke/indent-blankline.nvim', { tag = 'v3.8.6' })

Plug('vim-scripts/CursorLineCurrentWindow')

-- javascript
Plug('pangloss/vim-javascript', { ['for'] = 'javascript' })
-- Configs
  vim.g.javascript_plugin_jsdoc = 1
  vim.g.javascript_plugin_flow = 0
-- *******

-- jsx
Plug('neoclide/vim-jsx-improve', { ['for'] = 'javascript' })

-- ejs
Plug('nikvdp/ejs-syntax', { ['for'] = 'ejs' })

-- GraphQL
Plug('jparise/vim-graphql', { ['for'] = 'graphql' })

-- html5
Plug('othree/html5.vim', { ['for'] = 'html' })

-- golang
-- XXX: Run :GoUpdateBinaries if you wanna update its binaries or after installing it
Plug('fatih/vim-go', { ['for'] = 'go' })
-- Configs
  vim.g.go_fmt_autosave = 0
  vim.g.go_mod_fmt_autosave = 0
  vim.g.go_def_mapping_enabled = 1
  vim.g.go_textobj_enabled = 0
  vim.g.go_textobj_include_function_doc = 0
  vim.g.go_textobj_include_variable = 0
  vim.g.go_fold_enable = {}
-- *******

-- css3
Plug('hail2u/vim-css3-syntax', { ['for'] = 'css' })

-- scss
Plug('cakebaker/scss-syntax.vim', { ['for'] = 'scss' })

-- markdown
Plug('ixru/nvim-markdown')

-- sql
Plug('exu/pgsql.vim', { ['for'] = 'sql' })
-- Configs
  vim.g.sql_type_default = 'pgsql'
-- *******

--- csv
Plug('mechatroner/rainbow_csv', { ['for'] = 'csv' })
-- Configs
  vim.g.disable_rainbow_key_mappings = 0
--- *******

-- ===================
-- Auto Completion
-- ===================

Plug('wellle/tmux-complete.vim')

Plug('myhere/vim-nodejs-complete', { ['for'] = 'javascript' })
Plug('othree/jspc.vim', { ['for'] = 'javascript' })

Plug('neoclide/coc.nvim', {branch = 'release'})
-- Configs
  vim.cmd([[

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

  ]])
  vim.cmd([[

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

  ]])


  -- Use tab for trigger completion with characters ahead and navigate.
  vim.cmd([[
    inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
  ]])
  vim.cmd([[
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  ]])

  vim.keymap.set('n', '<leader>vd', ':call ShowDocumentation()<CR>', {silent = true})

  -- GoTo code navigation.
  vim.keymap.set('n', 'gd', ':call CocAction("jumpDefinition", "drop")<CR>', {silent = true})
  vim.keymap.set('n', 'gt', '<Plug>(coc-type-definition)', {silent = true})
  vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
  vim.keymap.set('n', 'gr', '<Plug>(coc-references)', {silent = true})

  -- Use `[g` and `]g` to navigate diagnostics
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  vim.keymap.set('n', '[g', '<Plug>(coc-diagnostic-prev)', {silent = true})
  vim.keymap.set('n', ']g', '<Plug>(coc-diagnostic-next)', {silent = true})

  -- Symbol renaming.
  vim.keymap.set('n', '<leader>r', '<Plug>(coc-rename)', {silent = true})

  vim.g.coc_global_extensions = {
    'coc-json',
    'coc-browser',
    'coc-tsserver',
    'coc-html',
    'coc-css',
    'coc-html-css-support',
    'coc-swagger',
    'coc-pyright',
    'coc-docker',
    'coc-eslint',
    'coc-git',
    'coc-go',
    'coc-golines',
    'coc-prisma',
    'coc-sql',
    'coc-xml',
    'coc-yaml',
  }

  -- Hotkey for rendering Swagger
  vim.keymap.set('n', '<leader>vs', ':CocCommand swagger.render<CR>', {silent = true})

  -- Highlight the symbol and its references when holding the cursor.
  vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- *******


-- ===================
-- Lint
-- ===================

Plug('neomake/neomake', { ['for'] = { 'javascript', 'typescript', 'go', 'lua', 'typescript.tsx' } })
-- Configs
  -- vim.cmd('autocmd! BufWritePost,BufEnter *.js,*.jsx,*.ts,*.tsx,*.go,*.lua Neomake')

  vim.g.quickfixsigns_protect_sign_rx = '^neomake_'
  vim.g.neomake_ft_maker_remove_invalid_entries = 0

  -- XXX: Use it for debug, if necessary
  -- let g:neomake_logfile = '/home/brunogsa/neomake.debug'

  vim.g.neomake_place_signs = 1

  vim.g.neomake_open_list = 0

  vim.g.neomake_list_height = 2
  vim.g.neomake_echo_current_error = 1

  vim.g.neomake_highlight_columns = 0
  vim.g.neomake_highlight_lines = 0

  vim.g.neomake_error_sign = { text = '✖', texthl = 'NeomakeErrorSign' }
  vim.g.neomake_warning_sign = { text = '!', texthl = 'NeomakeMessageSign' }

  -- Helpers
  local localEslint = vim.fn.glob('node_modules') .. '/.bin/eslint'
  local globalEslint = vim.fn.system('which eslint')
  globalEslint = string.sub(globalEslint, 1, -2) -- Remove some last chars (garbage)
  local eslint = globalEslint
  if vim.fn.executable(localEslint) == 1 then
    eslint = localEslint
  end

  local localEslintConfig = vim.fn.glob('.eslintrc')

  -- JavaScript Checkers
  vim.g.neomake_javascript_eslint_maker = {
    exe = eslint,
    append_file = 0,
    args = {'--no-ignore', '-f', 'compact', '--ext', '.js,.jsx', '%:p'},
    errorformat = '%E%f: line %l\\, col %c\\, Error - %m, %W%f: line %l\\, col %c\\, Warning - %m'
  }
  if vim.fn.filereadable(localEslintConfig) == 1 then
    table.insert(vim.g.neomake_javascript_eslint_maker.args, 1, '-c')
    table.insert(vim.g.neomake_javascript_eslint_maker.args, 2, localEslintConfig)
  end

  vim.g.neomake_javascript_enabled_makers = { 'eslint' }

  -- TypeScript Checkers
  vim.g.neomake_typescript_eslint_maker = {
    exe = eslint,
    append_file = 0,
    args = {'--no-ignore', '-f', 'compact', '--ext', '.ts,.tsx', '%:p'},
    errorformat = '%E%f: line %l\\, col %c\\, Error - %m, %W%f: line %l\\, col %c\\, Warning - %m'
  }
  if vim.fn.filereadable(localEslintConfig) == 1 then
    table.insert(vim.g.neomake_typescript_eslint_maker.args, 1, '-c')
    table.insert(vim.g.neomake_typescript_eslint_maker.args, 2, localEslintConfig)
  end

  vim.g.neomake_typescript_enabled_makers = { 'eslint' }

  -- Lua Checkers
  local luacBin = vim.fn.system('which luac')
  luacBin = string.sub(luacBin, 1, -3) -- Remove last 2 chars (garbage)

  vim.g.neomake_lua_luac_maker = {
    exe = luacBin,
    append_file = 0,
    args = {'-p', '%:p'},
    errorformat = '%Eluac: %f:%l: %m'
  }
  vim.g.neomake_lua_enabled_makers = { 'luac' }

  -- Golang Checkers
  vim.g.neomake_go_enabled_makers = { 'go', 'golint' }
-- *******


-- Initialize plugin system
vim.call('plug#end')


-- =======================================
-- Post plugin load configs
-- =======================================
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = 'all',

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = false,
  },
  fold = {
    enable = true,
  },
})

-- Colorscheme
vim.cmd.colorscheme("sonokai")

local langs = {--[[ configuration for languages ]]}
require('treesj').setup({
  -- Use default keymaps
  -- (<space>m - toggle, <space>j - join, <space>s - split)
  use_default_keymaps = false,

  -- Node with syntax error will not be formatted
  check_syntax_error = true,

  -- If line after join will be longer than max value,
  -- node will not be formatted
  max_join_length = 2048,

  -- hold|start|end:
  -- hold - cursor follows the node/place on which it was called
  -- start - cursor jumps to the first symbol of the node being formatted
  -- end - cursor jumps to the last symbol of the node being formatted
  cursor_behavior = 'hold',

  -- Notify about possible problems or not
  notify = true,
  langs = langs,

  -- Use `dot` for repeat action
  dot_repeat = true,
})

require('git-conflict').setup({
  default_mappings = true,
  disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffAdd',
    current = 'DiffText',
  }
})

require("ibl").setup({
  indent = {
    char = '┆',
  },

  scope = {
    enabled = true,
    show_start = true,
    show_end = true,
    show_start = true
  }
})

require("chatgpt").setup()

-- Configs illuminate (it needs to be here at the end)
  vim.api.nvim_set_hl(0, "illuminatedWord",     { underline = true })
  vim.api.nvim_set_hl(0, "illuminatedCurWord",  { underline = true })
  vim.api.nvim_set_hl(0, "illuminatedWordText", { underline = true })
-- *******

require('Comment').setup()
-- Configs illuminate (it needs to be here at the end)
  -- Optional: Remap <leader><leader> to toggle comment
  vim.keymap.set('n', '<leader><leader>', function()
    require('Comment.api').toggle.linewise.current()
  end, { desc = 'Toggle comment line' })

  vim.keymap.set('v', '<leader><leader>', function()
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end, { desc = 'Toggle comment block' })
-- *******
