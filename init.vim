" ===============================================
" Core Settings
" ===============================================

set cmdheight=2

" Disable mouse
set mouse=

" Improve Performance
set ttyfast
set regexpengine=1

set synmaxcol=120
syntax sync minlines=512
syntax sync maxlines=1024

set timeoutlen=1000
set ttimeoutlen=20

" Avoid issues with UTF-8
set encoding=utf-8
scriptencoding utf-8

" Fold options. I prefer fold by identation
set foldmethod=indent
set foldlevelstart=2
set list lcs=tab:\┆\

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

" No annoying backup files
set nobackup
set nowritebackup
set noswapfile

" Efficient way to move through your code using the Arrow Keys
map <silent> <Left> h
map <silent> <Down> gj
map <silent> <Up> gk
map <silent> <Right> l

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
let mapleader = "\<Space>"

" 'b' goes to the beginning of a line. 'e' to the end of the line.
noremap b 0
noremap e $

" Easier to align
xnoremap > >gv
xnoremap < <gv

" Toggles the number lines
map <silent> <leader>n :set number!<Cr>:set relativenumber!<Cr>

" Search only in visual selection
vmap / <Esc>/\%V

" PrettyXML: Format a line of XML
vmap <silent> <Leader>fx :!xmllint --format --recover - 2>/dev/null<CR>

" PrettyJSON: Format a line of JSON
vmap <silent> <Leader>fj :!python -m json.tool<CR>

" PrettyPSQL: Format a line of PSQL
vmap <silent> <Leader>fp :!pg_format -f 0 -s 2 -u 0<CR>

" Selected last pasted text
nmap gp V']

" Test Mocha files on Javascript projects
map <silent> <F5> :terminal export CURRENT_GIT_ROOT=`git rev-parse --show-toplevel` && export CURRENT_TEST_DIR=`pwd` && export GETCONFIG_ROOT=$CURRENT_GIT_ROOT/config && cd $CURRENT_GIT_ROOT && mocha -g '<cword>' $CURRENT_TEST_DIR/% && unset CURRENT_GIT_ROOT CURRENT_TEST_DIR GETCONFIG_ROOT<CR>


" ===============================================
" Init plugins
" ===============================================

" Make sure you use single quotes
call plug#begin('~/.local/share/nvim/plugged')


" Basic
" =================

Plug 'neovim/python-client'

Plug 'itchyny/lightline.vim'
" Configs
  let g:lightline = {
    \ 'colorscheme': 'seoul256',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ]
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

Plug 'scrooloose/nerdcommenter'
" Configs
  nmap '' <Leader>c<Space>
  vmap '' <Leader>c<Space>

  " Add spaces after comment delimiters by default
  let g:NERDSpaceDelims = 1

  " Use compact syntax for prettified multi-line comments
  let g:NERDCompactSexyComs = 1

  " Allow commenting and inverting empty lines (useful when commenting a region)
  let g:NERDCommentEmptyLines = 0
" *******

Plug 'Valloric/ListToggle'
" Configs
  let g:lt_location_list_toggle_map = '<leader>l'
  let g:lt_quickfix_list_toggle_map = '<leader>q'
" *******

Plug 'Raimondi/delimitMate'
" Configs
  let delimitMate_matchpairs = "(:),[:],{:}"
  let delimitMate_expand_cr = 1
" *******

Plug 'tpope/vim-surround'
Plug 'Valloric/MatchTagAlways'
Plug 'vim-scripts/matchit.zip'
Plug 'alvan/vim-closetag'


Plug 'chrisbra/vim-diff-enhanced'
Plug 'rickhowe/diffchar.vim'
Plug 'AndrewRadev/linediff.vim'

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
  autocmd VimEnter * nnoremap <silent> n nzz:ShowSearchIndex<CR>
  autocmd VimEnter * nnoremap <silent> N Nzz:ShowSearchIndex<CR>

  autocmd VimEnter * nnoremap <silent> * *zz:ShowSearchIndex<CR>
  autocmd VimEnter * nnoremap <silent> # #zz:ShowSearchIndex<CR>
" *******

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-repeat'
Plug 'nelstrom/vim-visual-star-search'
Plug 'rhysd/clever-f.vim'
Plug 'sickill/vim-pasta'
Plug 'conradirwin/vim-bracketed-paste'

Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/argtextobj.vim'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-smartword'
Plug 'glts/vim-textobj-comment'
Plug 'paradigm/TextObjectify'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'vim-utils/vim-troll-stopper'

Plug 'ntpeters/vim-better-whitespace'
" Configs
  " Automatically remove trailling spaces on save
  autocmd BufWritePre <buffer> StripWhitespace
" *******

Plug 'tpope/vim-sleuth'

Plug 'Numkil/ag.nvim'
" Configs
  let g:ag_prg = "/usr/bin/ag"
  let g:ag_working_path_mode = "r"
" *******

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Configs
  " Find files using ProjectFiles
  nmap <silent> <C-t> :ProjectFiles<CR>

  function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
  endfunction

  command! ProjectFiles execute 'Files' s:find_git_root()

  " Better command history with q:
  command! CmdHist call fzf#vim#command_history({'right': '40'})
  nmap <silent> q: :CmdHist<CR>

  " Buffer Explorer
  function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction

  function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  endfunction

  nnoremap <silent> <Leader>b :call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink':    function('<sid>bufopen'),
  \   'options': '+m',
  \   'down':    len(<sid>buflist()) + 2
  \ })<CR>
" *******

Plug 'dietsche/vim-lastplace'
" Configs
  let g:lastplace_open_folds = 0
  let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
" *******


" Highlight
" =================

Plug 'leafgarland/typescript-vim'
" Configs
  let g:typescript_compiler_binary = 'tsc'
  let g:typescript_compiler_options = ''
" *******

Plug 'HerringtonDarkholme/yats.vim'

Plug 'Yggdroot/indentLine'
" Configs
  let g:indentLine_char = '┆'
  let g:indentLine_color_term = 32
  let g:indentLine_faster = 1
  let g:indentLine_maxLines = 512

  " Disable it on markdown files
  autocmd VimEnter *.md IndentLinesDisable
" *******

Plug 'vim-scripts/CursorLineCurrentWindow'

" javascript
Plug 'othree/yajs.vim'

" json
Plug 'elzr/vim-json'
" Configs
  let g:vim_json_syntax_conceal = 0
" *******

" jsdoc
Plug 'othree/jsdoc-syntax.vim'

" html5
Plug 'othree/html5.vim'

" css3
Plug 'hail2u/vim-css3-syntax'

" markdown
Plug 'tpope/vim-markdown'
" Configs
  let g:markdown_syntax_conceal = 0
  let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

  " Auto Disable indent lines on markdown files
  au BufReadPre,FileReadPre *.md,*.markdown :IndentLinesDisable
" *******

Plug 'jtratner/vim-flavored-markdown'
" Configs
  augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  augroup END
" *******

" sql
Plug 'exu/pgsql.vim'
" Configs
  let g:sql_type_default = 'pgsql'
" *******


" Auto Completion
" =================

" Default / Fast mechanism
Plug 'ajh17/vimcompletesme'

" Slower / Better mechanism
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Configs
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#enable_refresh_always = 1
  let g:deoplete#disable_auto_complete = 0
  let g:deoplete#max_list = 32
  let g:deoplete#max_menu_width = 16
  let g:deoplete#auto_complete_start_length = 1

  let g:deoplete#omni#functions = {}

  let g:deoplete#omni#functions.javascript = [
      \ 'tern#Complete',
      \ 'jspc#omni',
      \ 'syntaxcomplete#Complete'
  \]

  let g:deoplete#omni#functions.ruby = [
      \ 'syntaxcomplete#Complete'
  \]

  let g:deoplete#omni#functions.typescript = [
      \ 'tsuquyomi#complete',
      \ 'syntaxcomplete#Complete'
  \]

  " Close the documentation window when completion is done
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

  " Fix an conflict with vim-multiple-cursors
  function g:Multiple_cursors_before()
      let g:deoplete#disable_auto_complete = 1
  endfunction

  function g:Multiple_cursors_after()
      let g:deoplete#disable_auto_complete = 0
  endfunction
" *******

Plug 'wellle/tmux-complete.vim'

Plug 'carlitux/deoplete-ternjs'
" Configs
  let g:tern_request_timeout = 1
" *******

Plug 'myhere/vim-nodejs-complete'
Plug 'othree/jspc.vim'

" Pre-Reqs
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
" *******
Plug 'Quramy/tsuquyomi'
" Configs
  let g:tsuquyomi_completion_detail = 1
  let g:tsuquyomi_disable_quickfix = 1
  let g:tsuquyomi_disable_default_mappings = 1
" *******


" Lint
" =================

Plug 'vim-syntastic/syntastic'
" Configs
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_loc_list_height = 3
  let g:syntastic_check_on_wq = 1
  let g:syntastic_always_populate_loc_list = 1
  let g:statline_syntastic = 0

  let g:syntastic_mode_map = { "mode": "active" }
  let syntastic_aggregate_errors = 1

  " JavaScript Checkers
  let g:syntastic_javascript_checkers = ['eslint']
  let g:syntastic_javascript_eslint_exec = 'eslint_d'

  " TypeScript Checkers
  let g:syntastic_typescript_checkers = ['tsuquyomi']
" *******

Plug 'tpope/vim-git'


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

Plug 'shime/vim-livedown', { 'do': 'sudo npm install -g livedown', 'on': 'LivedownPreview' }
" Configs
  nmap <Leader>vp :LivedownPreview<CR>

  " should markdown preview get shown automatically upon opening markdown buffer
  let g:livedown_autorun = 0

  " should the browser window pop-up upon previewing
  let g:livedown_open = 1

  " the browser to use
  let g:livedown_browser = "google-chrome"
" *******

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Configs
  map <leader>t :NERDTreeToggle<CR>
  let NERDTreeHijackNetrw=1
" *******

Plug 'justinmk/vim-sneak'
" Configs
  let g:sneak#s_next = 1

  "'s', sneak with 2 chars
  nmap f <Plug>Sneak_s
  nmap F <Plug>Sneak_S
  xmap f <Plug>Sneak_s
  xmap F <Plug>Sneak_S
  omap f <Plug>Sneak_s
  omap F <Plug>Sneak_S

  "replace 'f' with 1-char Sneak
  nmap f <Plug>Sneak_f
  nmap F <Plug>Sneak_F
  xmap f <Plug>Sneak_f
  xmap F <Plug>Sneak_F
  omap f <Plug>Sneak_f
  omap F <Plug>Sneak_F

  "replace 't' with 1-char Sneak
  nmap t <Plug>Sneak_t
  nmap T <Plug>Sneak_T
  xmap t <Plug>Sneak_t
  xmap T <Plug>Sneak_T
  omap t <Plug>Sneak_t
  omap T <Plug>Sneak_T
" *******

Plug 'terryma/vim-multiple-cursors'
Plug 'kshenoy/vim-signature'
Plug 'yuttie/comfortable-motion.vim'

Plug 'andrewradev/splitjoin.vim'
" Configs
  nmap <Leader>ls :SplitjoinSplit<CR>
  nmap <Leader>lj :SplitjoinJoin<CR>
" *******

Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'rhlobo/vim-super-retab', { 'on': 'Tab2Space' }

Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
" Configs
  let g:limelight_conceal_ctermfg = 'gray'
  let g:limelight_conceal_ctermfg = 240
  let g:limelight_paragraph_span = 3
  let g:limelight_bop = '^\s'
  let g:limelight_eop = '\ze\n^\s'

  vmap <Leader>vl :Limelight<CR>
  nmap <Leader>vl :Limelight!!<CR>
" *******

Plug 'jkramer/vim-narrow', { 'on': 'Narrow' }
" Configs
  vmap <Leader>vn :Narrow<CR>
  nmap <Leader>vw :Widen<CR>
" *******

Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
" Configs
  nmap <Leader>vg :Goyo<CR>
" *******


" Initialize plugin system
call plug#end()


" ===============================================
" Interface
" ===============================================

syntax on

" Add a line above the cursor - Disable for better performance
set cursorline

" Line numbers - Disable for better performance
set number
set relativenumber

" No wrap
set wrap
set textwidth=256

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
