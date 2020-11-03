" ===============================================
" Auxiliar Functions
" ===============================================

" Private
function! GlobPathList(path, pattern, suf) abort
  if v:version >= 705 || (v:version == 704 && has('patch279'))
    return globpath(a:path, a:pattern, a:suf, 1)
  endif
  return split(globpath(a:path, a:pattern, a:suf), '\n')
endfunction

" Public
function! FindGlobFile(glob, ...) abort
  let curDir = a:0 ? a:1 : expand('%:p:h')
  let fileFound = []
  while 1
    let fileFound = GlobPathList(curDir, a:glob, 1)
    if !empty(fileFound)
      return fileFound[0]
    endif
    let lastFolder = curDir
    let curDir = fnamemodify(curDir, ':h')
    if curDir ==# lastFolder
      break
    endif
  endwhile
  return ''
endfunction

" ===============================================
" Core Settings
" ===============================================

" Disable mouse
set mouse=

" Improve Performance
set ttyfast
set regexpengine=1
set modelines=0

set synmaxcol=213
syntax sync minlines=256
syntax sync maxlines=2048

set timeoutlen=512
set ttimeoutlen=16

" Avoid issues with UTF-8
set encoding=utf-8
scriptencoding utf-8

" Fold options. I prefer fold by identation
set foldmethod=indent
set foldlevelstart=2
set foldnestmax=8
set listchars=nbsp:˽,trail:˽,tab:\┆\ 
set list

" Search options
set incsearch
set smartcase
set nohlsearch

" Split options
set splitbelow
set splitright

" Completion options
set wildmode=longest,list
set wildmenu
set completeopt=longest,menu

" Set vim title automatically
set title

" Share clipboard with system
set clipboard=unnamed,unnamedplus

" Send deleted thing with 'x' and 'c' to black hole
nnoremap x "_x
vnoremap X "_X
nnoremap c "_c
vnoremap C "_C

" Add ; or , in the end of the line
nnoremap <silent> ;; mqA;<esc>`q
nnoremap <silent> ,, mqA,<esc>`q

" No annoying backup files
set nobackup
set nowritebackup
set noswapfile

" Efficient way to move through your code using the Arrow Keys
nnoremap <silent> <left> h
nnoremap <silent> <down> gj
nnoremap <silent> <up> gk
nnoremap <silent> <right> l

" Indentation options
set autoindent
set smartindent
set cindent
set preserveindent
set copyindent

" Spaces for identation
set expandtab
set smarttab

" The size of your indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround

" Indentation for HTML
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head"

" Automatically set wrap when starting a vim diff
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" Virtual edit preferences: in block wise
set virtualedit=block


" ===============================================
" Hotkeys
" ===============================================
" Leader is SPACE
let mapleader = "\<space>"

" Move to the beginning of the indentation level
noremap <S-left> ^
noremap <home> ^

" Move to the end of a line in a smarter way
noremap <S-right> g_
noremap <end> g_

" Easier to align
xnoremap > >gv
xnoremap < <gv

" Resize windows
" nnoremap <silent><leader><right> :vertical resize -5<cr>
" nnoremap <silent><leader><left> :vertical resize +5<cr>
" nnoremap <silent><leader><up> :resize +5<cr>
" nnoremap <silent><leader><down> :resize -5<cr>

" Toggles the number lines
nnoremap <silent> <leader>tn :set number!<cr>

" Search only in visual selection
vnoremap / <esc>/\%V

" PrettyXML: Format a line of XML
vnoremap <silent> <leader>Fxml :!xmllint --format --recover - 2>/dev/null<cr>

" PrettyPSQL: Format a line of PSQL
vnoremap <silent> <leader>Fpsql :!pg_format -f 0 -s 2 -u 0<cr>

" Selected last pasted text
nnoremap gp V']

" View a formatted JSON is a new buffer
vnoremap <buffer> <leader>vj y:vnew<cr>pV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>


" ===============================================
" Init plugins
" ===============================================

" Make sure you use single quotes. It's here the plugins are stored
call plug#begin('~/.local/share/nvim/plugged')


" Basic
" =================

Plug 'neovim/python-client'

Plug 'liuchengxu/vim-which-key'
" Configs
  set timeoutlen=500

  nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
" *******

Plug 'itchyny/lightline.vim'
" Configs
  let g:lightline#bufferline#enable_devicons = 1

  let g:lightline = {
    \ 'colorscheme': 'seoul256',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'absolutepath', 'modified' ] ]
    \ },
    \ 'component': {
    \   'readonly': '%{&readonly?"READ-ONLY":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' }
  \}
" *******

Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }
"Configs
  let g:maximizer_set_default_mapping = 0
  nnoremap <silent><leader><F3> :MaximizerToggle<CR>
" *******

Plug 'tpope/vim-commentary'
" Configs
  nmap <leader><leader> gcc
  vmap <leader><leader> gcc
" *******

Plug 'Valloric/ListToggle'
" Configs
  let g:lt_location_list_toggle_map = '<leader>tl'
  let g:lt_quickfix_list_toggle_map = '<leader>tq'
" *******

Plug 'tpope/vim-surround'

Plug 'alvan/vim-closetag'
" Configs
  let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"
" *******

Plug 'Raimondi/delimitMate'
" Configs
  let delimitMate_matchpairs = "(:),[:],{:}"
  let delimitMate_expand_cr = 1
" *******

Plug 'chrisbra/vim-diff-enhanced'
Plug 'rickhowe/diffchar.vim'

Plug 'AndrewRadev/linediff.vim', { 'on': ['Linediff', 'LinediffReset'] }
" Configs
  vnoremap <silent> <leader>d :Linediff<cr>
  nnoremap <silent> <leader>D :LinediffReset<cr>
" *******

Plug 'junegunn/limelight.vim', { 'on': ['Limelight', 'Limelight!!'] }
" Configs
  vnoremap <silent> <leader>V :Limelight<cr>
  nnoremap <silent> <leader>V :Limelight!!<cr>

  let g:limelight_conceal_ctermfg = 'gray'
  let g:limelight_conceal_ctermfg = 240

  let g:limelight_priority = -1
" *******

Plug 'lfv89/vim-interestingwords'
" Configs
  nnoremap <silent> <leader>h :call InterestingWords('n')<cr>
  vnoremap <silent> <leader>h :call InterestingWords('v')<cr>
  nnoremap <silent> <leader>H :call UncolorAllWords()<cr>

  " [Ligh] green, yellow, blue, orange, purple, teal, red, gray - [Dark] same
  let g:interestingWordsTermColors = ['115', '190', '27', '202', '165', '87', '196', '250',
    \ '22', '11', '19', '94', '89', '147', '52', '234']
" *******

Plug 'henrik/vim-indexed-search'
" Configs
  let g:indexed_search_mappings = 0

  " Requires a lot of integrations...
  autocmd VimEnter * nnoremap <silent> n nzz:ShowSearchIndex<cr>
  autocmd VimEnter * nnoremap <silent> N Nzz:ShowSearchIndex<cr>

  autocmd VimEnter * nnoremap <silent> * *zz:ShowSearchIndex<cr>
  autocmd VimEnter * nnoremap <silent> # #zz:ShowSearchIndex<cr>
" *******

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-repeat'
Plug 'nelstrom/vim-visual-star-search'
Plug 'rhysd/clever-f.vim'

Plug 'sickill/vim-pasta'
Plug 'conradirwin/vim-bracketed-paste'

Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'paradigm/TextObjectify'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'rhysd/vim-textobj-anyblock'

Plug 'vim-utils/vim-troll-stopper'

Plug 'tpope/vim-sleuth'

Plug 'dietsche/vim-lastplace'
" Configs
  let g:lastplace_open_folds = 0
  let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
" *******

Plug 'iamcco/markdown-preview.nvim', { 'for': 'ghmarkdown', 'do': 'cd app && yarn install' }
" Configs
  let g:mkdp_command_for_global = 1
  let g:mkdp_refresh_slow = 1
  nmap <silent> <leader>vm <Plug>MarkdownPreviewToggle
" *******

Plug 'wellle/context.vim', { 'for': ['json', 'yaml','javascript', 'typescript', 'go', 'lua', 'php'] }
" Configs
  let g:context_add_mappings = 0
  let g:context_add_autocmds = 0
  autocmd VimEnter *.json,*.yaml,*.yml,*.js,*.jsx,*.ts,*.tsx,*.go*.lua,*.php ContextActivate
  autocmd CursorHold,BufWritePost *.json,*.yaml,*.yml,*.js,*.jsx,*.ts,*.tsx,*.go,*.lua,*.php ContextUpdate
" *******


" Highlight
" =================

" csv
autocmd VimEnter *.csv setlocal filetype=csv
Plug 'mechatroner/rainbow_csv', { 'for': 'csv' }
" Configs
  let g:disable_rainbow_key_mappings = 0
" *******

Plug 'martinda/Jenkinsfile-vim-syntax', { 'for': 'Jenkinsfile' }

Plug 'posva/vim-vue', { 'for': 'vue' }


Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
" Configs
  let g:terraform_align = 0
  let g:terraform_fold_sections = 0
  let g:terraform_fmt_on_save = 0
" *******

" typescript highlight for .ts and .d.ts files
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
" Configs
  let g:typescript_compiler_binary = 'tsc'
  let g:typescript_compiler_options = ''
" *******

" extend typescript + DOM keywords
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }

Plug 'Yggdroot/indentLine'
" Configs
  let g:indentLine_char = '┆'
  let g:indentLine_color_term = 32
  let g:indentLine_faster = 1
  let g:indentLine_maxLines = 512
" *******

Plug 'vim-scripts/CursorLineCurrentWindow'

" javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" Configs
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 0
" *******

" jsx
Plug 'neoclide/vim-jsx-improve', { 'for': 'javascript' }

" ejs
Plug 'nikvdp/ejs-syntax', { 'for': 'ejs' }

" json
Plug 'elzr/vim-json', { 'for': 'json' }
" Configs
  let g:vim_json_syntax_conceal = 0
" *******

" GraphQL
Plug 'jparise/vim-graphql', { 'for': 'graphql' }

" html5
Plug 'othree/html5.vim', { 'for': 'html' }

" golang
" XXX: Run :GoUpdateBinaries if you wanna update its binaries or after installing it
Plug 'fatih/vim-go', { 'for': 'go' }
" Configs
  let g:go_fmt_autosave = 0
  let g:go_mod_fmt_autosave = 0
  let g:go_def_mapping_enabled = 1
  let g:go_textobj_enabled = 0
  let g:go_textobj_include_function_doc = 0
  let g:go_textobj_include_variable = 0
  let g:go_fold_enable = []
" *******

" css3
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }

" scss
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }

" markdown
Plug 'tpope/vim-markdown', { 'for': 'ghmarkdown' }
" Configs
  let g:markdown_syntax_conceal = 0

  " Auto Disable indent lines on markdown files
  autocmd VimEnter *.md,*.markdown IndentLinesDisable
" *******

Plug 'jtratner/vim-flavored-markdown', { 'for': 'ghmarkdown' }
" Configs
  augroup markdown
    au!
    au VimEnter *.md,*.markdown setlocal filetype=ghmarkdown
  augroup END
" *******

" sql
Plug 'exu/pgsql.vim', { 'for': 'sql' }
" Configs
  let g:sql_type_default = 'pgsql'
" *******

" log files
autocmd VimEnter *.log IndentLinesDisable


" Auto Completion
" =================

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Configs
  set runtimepath+=~/.local/share/nvim/plugged/deoplete.nvim/
  let g:deoplete#enable_at_startup = 1
  let deoplete#tag#cache_limit_size = 5000000

  inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
  inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

  " Close the documentation window when completion is done
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

  call deoplete#custom#option({
    \ 'auto_complete': v:true,
    \ 'complete_suffix': v:true,
    \ 'camel_case': v:false,
    \ 'ignore_case': v:false,
    \ 'smart_case': v:false,
    \ 'max_list': 32,
    \ 'min_pattern_length': 1,
    \ 'num_processes': 1
  \ })

  call deoplete#custom#source('omni', 'functions', {
    \ '_': ['syntaxcomplete#Complete', 'tmuxcomplete#complete'],
    \ 'javascript': ['syntaxcomplete#Complete', 'tmuxcomplete#complete', 'tern#Complete', 'jspc#omni'],
    \ 'go': ['gocode#Complete', 'syntaxcomplete#Complete', 'tmuxcomplete#complete']
  \ })
" *******

Plug 'deoplete-plugins/deoplete-tag', { 'for': 'php' }
Plug 'wellle/tmux-complete.vim'
Plug 'deoplete-plugins/deoplete-docker', { 'for': 'dockerfile' }

Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
" Configs
  let g:tern_request_timeout = 2
" *******

Plug 'myhere/vim-nodejs-complete', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }

" WARN: If you got errors, try running :UpdateRemotePlugins inside a .ts file
" WARN: Requires a tsconfig.json file, so you'll may have to create a symbolic link for it
Plug 'mhartington/nvim-typescript', { 'for': 'typescript', 'do': './install.sh' }
" Configs
  set updatetime=1024
  let g:nvim_typescript#quiet_startup = 0
  let g:nvim_typescript#type_info_on_hold = 1
  let g:nvim_typescript#signature_complete = 1
  let g:nvim_typescript#default_mappings = 0
  let g:nvim_typescript#completion_mark = '[TS]'
" *******

" Lint
" =================

Plug 'neomake/neomake', { 'for': ['javascript', 'typescript', 'go', 'lua'] }
" Configs
  autocmd! BufWritePost,BufEnter *.js,*.jsx,*.ts,*.tsx,*.go,*.lua Neomake
  let g:quickfixsigns_protect_sign_rx = '^neomake_'
  let g:neomake_ft_maker_remove_invalid_entries = 0

  " XXX: Use it for debug, if necessary
  " let g:neomake_logfile = '/home/brunogsa/neomake.debug'

  let g:neomake_place_signs = 1

  let g:neomake_open_list = 0

  let g:neomake_list_height = 2
  let g:neomake_echo_current_error = 1

  let g:neomake_highlight_columns = 0
  let g:neomake_highlight_lines = 0

  let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
  let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeMessageSign'}

  " Helpers
  let localEslint = FindGlobFile('node_modules') . '/.bin/eslint'

  " JavaScript Checkers
  let g:neomake_javascript_eslint_maker = {
    \ 'exe': localEslint,
    \ 'append_file': 0,
    \ 'args': ['--no-ignore', '-f', 'compact', '--ext', '.js,.jsx', '%:p'],
    \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m, %W%f: line %l\, col %c\, Warning - %m'
  \}

  let g:neomake_javascript_enabled_makers = ['eslint']

  " TypeScript Checkers
  let g:neomake_typescript_eslint_maker = {
    \ 'exe': localEslint,
    \ 'append_file': 0,
    \ 'args': ['--no-ignore', '-f', 'compact', '--ext', '.ts', '%:p'],
    \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m, %W%f: line %l\, col %c\, Warning - %m'
  \}

  let g:neomake_typescript_enabled_makers = ['eslint']

  " Lua Checkers
  let g:neomake_lua_luac_maker = {
    \ 'exe': '/usr/bin/luac',
    \ 'append_file': 0,
    \ 'args': ['-p', '%:p'],
    \ 'errorformat': '%E/usr/bin/luac: %f:%l: %m'
  \}
  let g:neomake_lua_enabled_makers = ['luac']

  " Golang Checkers
  let g:neomake_go_enabled_makers = ['go', 'golint']
" *******

Plug 'tpope/vim-git', { 'for': 'gitcommit' }


" Performance
" =================

Plug 'vim-scripts/LargeFile'
" Configs
  let g:LargeFile = 0.5
" *******
"
Plug 'tmux-plugins/vim-tmux-focus-events'


" Luxury
" =================

Plug 'maksimr/vim-jsbeautify', {
\ 'for': [
  \ 'javascript',
  \ 'typescript',
  \ 'css',
  \ 'scss',
  \ 'sass',
  \ 'json',
  \ 'html'
  \ ],
\ 'on': ['RangeJsBeautify', 'RangeJsonBeautify', 'RangeJsxBeautify', 'RangeHtmlBeautify', 'RangeCSSBeautify']
\ }
" Configs

  vnoremap <buffer> <leader>Fjs :call RangeJsBeautify()<cr>
  vnoremap <buffer> <leader>Fjson di<cr><esc>VpV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>
  vnoremap <buffer> <leader>Fjsx :call RangeJsxBeautify()<cr>
  vnoremap <buffer> <leader>Fhtml :call RangeHtmlBeautify()<cr>
  vnoremap <buffer> <leader>Fcss :call RangeCSSBeautify()<cr>

  " For additional configs, see: https://github.com/beautify-web/js-beautify
  let g:config_Beautifier = {
    \ 'js': {
      \ 'indent_style': 'space',
      \ 'indent_size': '2'
    \},
    \ 'json': {
      \ 'indent_style': 'space',
      \ 'indent_size': '2'
    \},
    \ 'jsx': {
      \ 'indent_style': 'space',
      \ 'indent_size': '2'
    \},
    \ 'html': {
      \ 'indent_style': 'space',
      \ 'indent_size': '2'
    \},
    \ 'css': {
      \ 'indent_style': 'space',
      \ 'indent_size': '2'
    \}
  \}
" *******

Plug 'prettier/vim-prettier', {
\ 'do': 'yarn install',
\ 'branch': 'release/1.x',
\ 'for': [
  \ 'javascript',
  \ 'typescript',
  \ 'css',
  \ 'scss',
  \ 'sass',
  \ 'json',
  \ 'html'
  \ ],
\ 'on': '<Plug>(Prettier)'
\ }
" Configs
  nnoremap <leader>Fjs <Plug>(Prettier)
  nnoremap <leader>Fjson <Plug>(Prettier)
  nnoremap <leader>Fjsx <Plug>(Prettier)
  nnoremap <leader>Fhtml <Plug>(Prettier)
  nnoremap <leader>Fcss <Plug>(Prettier)
  nnoremap <leader>Fscss <Plug>(Prettier)
  nnoremap <leader>Fsass <Plug>(Prettier)

  let g:prettier#autoformat = 0

  " max line length that prettier will wrap on
  " Prettier default: 80
  let g:prettier#config#print_width = 80

  " number of spaces per indentation level
  " Prettier default: 2
  let g:prettier#config#tab_width = 2

  " use tabs over spaces
  " Prettier default: false
  let g:prettier#config#use_tabs = 'false'

  " print semicolons
  " Prettier default: true
  let g:prettier#config#semi = 'true'

  " single quotes over double quotes
  " Prettier default: false
  let g:prettier#config#single_quote = 'true'

  " print spaces between brackets
  " Prettier default: true
  let g:prettier#config#bracket_spacing = 'true'

  " put > on the last line instead of new line
  " Prettier default: false
  let g:prettier#config#jsx_bracket_same_line = 'false'

  " avoid|always
  " Prettier default: avoid
  let g:prettier#config#arrow_parens = 'avoid'

  " none|es5|all
  " Prettier default: none
  let g:prettier#config#trailing_comma = 'all'

  " flow|babylon|typescript|css|less|scss|json|graphql|markdown
  " Prettier default: babylon
  let g:prettier#config#parser = 'babylon'

  " cli-override|file-override|prefer-file
  let g:prettier#config#config_precedence = 'prefer-file'

  " always|never|preserve
  let g:prettier#config#prose_wrap = 'preserve'
" *******

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Configs
  nnoremap <leader>tp :NERDTreeToggle<cr>
  let NERDTreeHijackNetrw=1
" *******

Plug 'justinmk/vim-sneak'
" Configs
  let g:sneak#s_next = 1

  "replace 'f' with 1-char Sneak
  nnoremap f <Plug>Sneak_f
  nnoremap F <Plug>Sneak_F
  xnoremap f <Plug>Sneak_f
  xnoremap F <Plug>Sneak_F
  onoremap f <Plug>Sneak_f
  onoremap F <Plug>Sneak_F

  "replace 't' with 1-char Sneak
  nnoremap t <Plug>Sneak_t
  nnoremap T <Plug>Sneak_T
  xnoremap t <Plug>Sneak_t
  xnoremap T <Plug>Sneak_T
  onoremap t <Plug>Sneak_t
  onoremap T <Plug>Sneak_T
" *******

Plug 'mg979/vim-visual-multi'

Plug 'yuttie/comfortable-motion.vim'

Plug 'andrewradev/splitjoin.vim', { 'on': ['SplitjoinJoin', 'SplitjoinJoin'] }
" Configs
  nnoremap <leader>ls :SplitjoinSplit<cr>
  nnoremap <leader>lj :SplitjoinJoin<cr>
" *******

Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'rhlobo/vim-super-retab', { 'on': ['Space2Tab', 'Tab2Space'] }

" Initialize plugin system
call plug#end()


" ===============================================
" Interface
" ===============================================

syntax on
autocmd BufWinEnter * :syntax sync fromstart

" Larger bottom command panel, better for seeing auxiliar messages
set cmdheight=2

" Add a line above the cursor - Disable for better performance
set cursorline

" Line numbers - Disable for better performance
" set number
" set relativenumber

set wrap
set textwidth=213

" Colorscheme
colorscheme wasabi256

" Transparency in some terminals
hi Normal ctermbg=none
highlight NonText ctermbg=none

" Colorscheme for vimdiff
if &diff
  colorscheme jellybeans
endif

" General vision
set lbr
set scrolloff=999       " Cursor is always in the middle of screen

" Status Line
set noruler
set laststatus=2

" More visible search
highlight IncSearch guibg=red ctermbg=red term=underline
