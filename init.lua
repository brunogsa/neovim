-- =======================================
-- Auxiliar Functions and Values
-- =======================================

HOME = os.getenv('HOME')

function _G.toggle_foldmethod()
  local current_foldmethod = vim.opt.foldmethod:get()
  if current_foldmethod == 'indent' then
    vim.opt.foldmethod = 'syntax'
  else
    vim.opt.foldmethod = 'indent'
  end
end

-- =======================================
-- Core Settings
-- =======================================

vim.opt.encoding='utf-8'

vim.opt.updatetime = 500
vim.cmd('autocmd VimEnter *.php set updatetime=8000')

-- Enable mouse scroll
-- vim.opt.mouse = 'a'
vim.opt.mouse = ''

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
vim.cmd('autocmd FilterWritePre * if &diff | setlocal wrap< | endif')

-- Virtual edit preferences: in block wise
vim.opt.virtualedit = 'block'

-- Colorscheme
vim.opt.background = 'dark'

-- Set file type to CSV files
vim.cmd('autocmd VimEnter *.csv setlocal filetype=csv')

-- =======================================
-- Interface
-- =======================================

vim.cmd('syntax on')
vim.cmd('autocmd BufWinEnter * :syntax sync fromstart')

-- Don't pass messages to |ins-completion-menu|.
vim.cmd('set shortmess+=c');

-- Larger bottom command panel, better for seeing auxiliar messages
vim.opt.cmdheight = 2

-- Add a line above the cursor - Disable for better performance
vim.opt.cursorline = true

-- Line numbers - Disable for better performance
vim.opt.number = true
-- set relativenumber

vim.opt.wrap = true
vim.cmd('set whichwrap+=<,>')
vim.opt.textwidth = 213

-- Transparency in some terminals
vim.cmd('hi Normal ctermbg=none')
vim.cmd('highlight NonText ctermbg=none')

-- Colorscheme for vimdiff
if vim.opt.diff then
  vim.cmd('colorscheme jellybeans')
end

-- General vision
vim.opt.lbr = true
vim.opt.scrolloff = 999  -- Cursor is always in the middle of screen

-- Status Line
vim.opt.ruler = false
vim.opt.laststatus = 2

-- More visible search
vim.cmd('highlight IncSearch guibg=red ctermbg=red term=underline')


-- =======================================
-- Hotkeys
-- =======================================

-- Map to <space>
vim.g.mapleader = ' '

-- Toggle foldmethod between "indent" and "syntax"
-- This is useful when dealing with files too nested, where the "indent" becomes limited
-- since neovim has a internal limit of "20" foldnestmax.
-- In those case, switching to "syntax" is the workaround
vim.api.nvim_set_keymap('n', '<leader>tf', [[<Cmd>lua _G.toggle_foldmethod()<CR>]], { noremap = true, silent = false })

-- Send deleted thing with 'x' and 'c' to black hole
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'X', '"_X', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'c', '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'C', '"_C', { noremap = true, silent = true })

-- Add ; or , in the end of the line
vim.api.nvim_set_keymap('n', ';;', 'mqA;<esc>`q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',,', 'mqA,<esc>`q', { noremap = true, silent = true })

-- Efficient way to move through your code using the Arrow Keys
vim.api.nvim_set_keymap('n', '<left>', 'h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<down>', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<up>', 'gk', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<right>', 'l', { noremap = true, silent = true })

-- Move to the beginning of the indentation level
vim.api.nvim_set_keymap('', '<S-left>', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<home>', '^', { noremap = true, silent = true })

-- Move to the end of a line in a smarter way
vim.api.nvim_set_keymap('', '<S-right>', 'g_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<end>', 'g_', { noremap = true, silent = true })

-- Easier to align
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true, silent = true })

-- Disable annoying auto-increment number feature
vim.api.nvim_set_keymap('', '<C-a>', '<Nop>', { noremap = false, silent = true })
vim.api.nvim_set_keymap('', 'g<C-a>', '<Nop>', { noremap = false, silent = true })
vim.api.nvim_set_keymap('', '<C-x>', '<Nop>', { noremap = false, silent = true })
vim.api.nvim_set_keymap('', 'g<C-x>', '<Nop>', { noremap = false, silent = true })

-- Resize windows
-- nnoremap <silent><leader><right> :vertical resize -5<cr>
-- nnoremap <silent><leader><left> :vertical resize +5<cr>
-- nnoremap <silent><leader><up> :resize +5<cr>
-- nnoremap <silent><leader><down> :resize -5<cr>

-- Toggles the number lines
vim.api.nvim_set_keymap('n', '<leader>tn', ':set number!<cr>', { noremap = true, silent = true })

-- Search only in visual selection
vim.api.nvim_set_keymap('v', '/', '<esc>/\\%V', { noremap = true, silent = true })

-- PrettyXML: Format a line of XML
vim.api.nvim_set_keymap('v', '<leader>Fxml', ':!xmllint --format --recover - 2>/dev/null<cr>', { noremap = true, silent = true })

-- PrettyPSQL: Format a line of PSQL
vim.api.nvim_set_keymap('v', '<leader>Fpsql', ':!pg_format -f 0 -s 2 -u 0<cr>', { noremap = true, silent = true })

-- Selected last pasted text
vim.api.nvim_set_keymap('n', 'gp', "V']", { noremap = true, silent = true })

-- View a formatted JSON is a new buffer
vim.api.nvim_set_keymap('v', '<leader>vj', 'y:vnew<cr>pV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>', { noremap = true, silent = true })

-- Preview for HTML
vim.api.nvim_set_keymap('n', '<leader>vh', ':!google-chrome % &<cr>', { noremap = false, silent = true })

-- Preview for AsyncAPI
vim.api.nvim_set_keymap('n', '<leader>va', ':!rm -fr /tmp/brunogsa-vim-asyncapi-preview && ag % @asyncapi/html-template -o /tmp/brunogsa-vim-asyncapi-preview && google-chrome /tmp/brunogsa-vim-asyncapi-preview/index.html &<cr>', { noremap = false, silent = true })

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
  vim.api.nvim_set_keymap('n', '<leader>', ":<c-u>WhichKey '<Space>'<CR>", {silent = true, noremap = true})
  vim.api.nvim_set_keymap('v', '<leader>', ":<c-u>WhichKeyVisual '<Space>'<CR>", {silent = true, noremap = true})
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

  vim.api.nvim_set_keymap('n', '<leader><F3>', ':MaximizerToggle<CR>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<C-w>z', ':MaximizerToggle<CR>', { silent = true, noremap = true })
-- *******

Plug('tpope/vim-commentary')
-- Configs
  vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', { silent = true })
  vim.api.nvim_set_keymap('v', '<leader><leader>', 'gcc', { silent = true })
-- *******

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
  vim.api.nvim_set_keymap('v', '<leader>d', ':Linediff<cr>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>D', ':LinediffReset<cr>', { silent = true, noremap = true })
-- *******

Plug('junegunn/limelight.vim', { on = { 'Limelight', 'Limelight!!' } })
-- Configs
  vim.api.nvim_set_keymap('v', '<leader>V', ':Limelight<cr>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>V', ':Limelight!!<cr>', { silent = true, noremap = true })

  vim.g.limelight_conceal_ctermfg = 'gray'
  vim.g.limelight_conceal_ctermfg = 240

  vim.g.limelight_priority = -1
-- *******

Plug('lfv89/vim-interestingwords')
-- Configs
  vim.api.nvim_set_keymap('n', '<leader>h', ':call InterestingWords("n")<cr>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('v', '<leader>h', ':call InterestingWords("v")<cr>', { silent = true, noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>H', ':call UncolorAllWords()<cr>', { silent = true, noremap = true })

  vim.g.interestingWordsTermColors = {
    '1', '8', '15', '22', '29', '36', '43', '50', '57', '64',
    '71', '78', '85', '92', '99', '106', '113', '120', '127', '134',
    '141', '148', '155', '162', '169', '176', '183', '190', '197', '204',
    '211', '218'
  }
-- *******

Plug('henrik/vim-indexed-search')
-- Configs
  vim.g.indexed_search_mappings = 0

  -- Requires a lot of integrations...
  vim.cmd('autocmd VimEnter * nnoremap <silent> n nzz:ShowSearchIndex<cr>')
  vim.cmd('autocmd VimEnter * nnoremap <silent> N Nzz:ShowSearchIndex<cr>')

  vim.cmd('autocmd VimEnter * nnoremap <silent> * *zz:ShowSearchIndex<cr>')
  vim.cmd('autocmd VimEnter * nnoremap <silent> # #zz:ShowSearchIndex<cr>')
-- *******

Plug('tpope/vim-endwise')

Plug('tpope/vim-repeat')
Plug('nelstrom/vim-visual-star-search')
Plug('rhysd/clever-f.vim')

Plug('sickill/vim-pasta')
Plug('conradirwin/vim-bracketed-paste')

Plug('michaeljsmith/vim-indent-object')
Plug('kana/vim-textobj-user')
Plug('paradigm/TextObjectify')
Plug('Julian/vim-textobj-variable-segment')
Plug('rhysd/vim-textobj-anyblock')

Plug('vim-utils/vim-troll-stopper')

Plug('tpope/vim-sleuth')

Plug('dietsche/vim-lastplace')
-- Configs
  vim.g.lastplace_open_folds = 0
  vim.g.lastplace_ignore = 'gitcommit,gitrebase,svn,hgcommit'
-- *******

Plug('iamcco/markdown-preview.nvim', { ['for'] = 'ghmarkdown,mermaid', ['do'] = 'cd app && npm install' })
-- Configs
  vim.g.mkdp_command_for_global = 1
  vim.g.mkdp_refresh_slow = 1

  vim.g.mkdp_preview_options = {
    sync_scroll_type = 'middle'
  }

  vim.api.nvim_set_keymap('n', '<leader>vm', '<Plug>MarkdownPreviewToggle', {noremap = true, silent = true})
-- *******

Plug('mzlogin/vim-markdown-toc', { ['for'] = 'ghmarkdown' })

Plug('wellle/context.vim')
-- Configs
  vim.g.context_add_mappings = 0
  vim.g.context_add_autocmds = 0
  vim.g.context_filetype_blacklist = { 'nerdtree' }

  vim.cmd('autocmd VimEnter * ContextActivate')
  vim.cmd('autocmd CursorHold,BufWritePost * ContextUpdate')
-- *******

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate<CR>' })

Plug('f-person/git-blame.nvim', { on = 'GitBlameToggle' })
-- Configs
  vim.g.gitblame_enabled = 0
  vim.api.nvim_set_keymap('n', '<leader>tg', ':GitBlameToggle<CR>', {noremap = true, silent = true})
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
  vim.api.nvim_set_keymap('v', '<leader>Fjs', ':call RangeJsBeautify()<cr>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<leader>Fjson', 'di<cr><esc>VpV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<leader>Fjsx', ':call RangeJsxBeautify()<cr>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<leader>Fhtml', ':call RangeHtmlBeautify()<cr>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<leader>Fcss', ':call RangeCSSBeautify()<cr>', {noremap = true, silent = true})

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
  vim.api.nvim_set_keymap('n', '<leader>Fjs', '<Plug>(Prettier)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Fjson', '<Plug>(Prettier)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Fjsx', '<Plug>(Prettier)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Fhtml', '<Plug>(Prettier)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Fcss', '<Plug>(Prettier)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Fscss', '<Plug>(Prettier)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Fsass', '<Plug>(Prettier)', {noremap = true, silent = true})

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
  vim.api.nvim_set_keymap('n', '<leader>tp', ':NERDTreeToggle<CR>', { noremap = true })
  vim.g.NERDTreeHijackNetrw = 1
-- *******

Plug('chentoast/marks.nvim')

Plug('ggandor/leap.nvim')

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
  vim.api.nvim_set_keymap('n', '<leader>lt', ':TSJToggle<CR>', {noremap = true, silent = true})
-- *******

Plug('godlygeek/tabular', { on = 'Tabularize' })
Plug('rhlobo/vim-super-retab', { on = { 'Space2Tab', 'Tab2Space' } })


-- ===================
-- Highlight
-- ===================

-- Colorscheme
Plug('sainnhe/sonokai')
vim.g.sonokai_style = 'espresso'
vim.g.sonokai_better_performance = 1
vim.g.sonokai_transparent_background = 1

-- csv
Plug('mechatroner/rainbow_csv', { ['for'] = 'csv' })
-- Configs
  vim.g.disable_rainbow_key_mappings = 0
-- *******

Plug('martinda/Jenkinsfile-vim-syntax', { ['for'] = 'Jenkinsfile' })

Plug('posva/vim-vue', { ['for'] = 'vue' })

Plug('tpope/vim-git', { ['for'] = 'gitcommit' })


Plug('hashivim/vim-terraform', { ['for'] = 'terraform' })
-- Configs
  vim.g.terraform_align = 0
  vim.g.terraform_fold_sections = 0
  vim.g.terraform_fmt_on_save = 0
-- *******

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

Plug('lukas-reineke/indent-blankline.nvim')

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
Plug('tpope/vim-markdown', { ['for'] = 'ghmarkdown' })
-- Configs
  vim.g.markdown_syntax_conceal = 0
-- *******

Plug('jtratner/vim-flavored-markdown', { ['for'] = 'ghmarkdown' })
-- Configs
  vim.cmd([[
    augroup markdown
      au!
      au VimEnter *.md,*.markdown setlocal filetype=ghmarkdown
    augroup END
  ]])
-- *******

-- sql
Plug('exu/pgsql.vim', { ['for'] = 'sql' })
-- Configs
  vim.g.sql_type_default = 'pgsql'
-- *******


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

  vim.api.nvim_set_keymap('n', '<leader>vd', ':call ShowDocumentation()<CR>', {noremap = true, silent = true})

  -- GoTo code navigation.
  vim.api.nvim_set_keymap('n', 'gd', ':call CocAction("jumpDefinition", "drop")<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', 'gt', '<Plug>(coc-type-definition)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', {noremap = true, silent = true})

  -- Use `[g` and `]g` to navigate diagnostics
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', {noremap = true, silent = true})

  -- Symbol renaming.
  vim.api.nvim_set_keymap('n', '<leader>r', '<Plug>(coc-rename)', {noremap = true, silent = true})

  vim.g.coc_global_extensions = {
    'coc-json',
    'coc-browser',
    'coc-tsserver',
    'coc-html',
    'coc-css',
    'coc-swagger',
    'coc-pyright',
  }

  -- Hotkey for rendering Swagger
  vim.api.nvim_set_keymap('n', '<leader>vs', ':CocCommand swagger.render<CR>', {noremap = true, silent = true})

  -- Highlight the symbol and its references when holding the cursor.
  vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- *******


-- ===================
-- Lint
-- ===================

Plug('neomake/neomake', { ['for'] = { 'javascript', 'typescript', 'go', 'lua', 'typescript.tsx' } })
-- Configs
  vim.cmd('autocmd! BufWritePost,BufEnter *.js,*.jsx,*.ts,*.tsx,*.go,*.lua Neomake')

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
    enable = true,
  },
  fold = {
    enable = true,
  },
})

-- Colorscheme
vim.cmd('colorscheme sonokai')

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

require('leap').add_default_mappings()

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

require('marks').setup({
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  default_mappings = false,
  -- pass false to disable only this default mapping
  mappings = {
    set_next = "mz",
    set = "ma",
    toggle = "mT",
    next = "m]",
    prev = "m[",
    -- 'x  Jumps to mark x. Default on neovim
    delete_line = "md",
    delete_buf = "mD",
    preview = false,
    delete = false,
    set_bookmark0 = false,
    delete_bookmark = false,
    next_bookmark = false,
    prev_bookmark = false,
    annotate = false,
  },
})
