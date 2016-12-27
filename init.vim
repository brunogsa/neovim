" ===============================================
" Init plugins
" ===============================================


" Make sure you use single quotes
call plug#begin('~/.local/share/nvim/plugged')


" Basic
" =================
Plug 'neovim/python-client'

Plug 'itchyny/lightline.vim'

Plug 'henrik/vim-indexed-search'
Plug 'scrooloose/nerdcommenter'

Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'Valloric/MatchTagAlways'
Plug 'vim-scripts/matchit.zip'
Plug 'alvan/vim-closetag'

Plug 'chrisbra/vim-diff-enhanced'
Plug 'rickhowe/diffchar.vim'
Plug 'AndrewRadev/linediff.vim'

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
Plug 'raimondi/yaifa'

" Highlight
" =================
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/CursorLineCurrentWindow'
Plug 'itchyny/vim-cursorword'

Plug 'othree/yajs.vim'
Plug 'elzr/vim-json'
Plug 'othree/jsdoc-syntax.vim'

Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'

" Auto Completion
" =================
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'vim-scripts/SyntaxComplete'
Plug 'wellle/tmux-complete.vim'

Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'myhere/vim-nodejs-complete'
Plug 'othree/jspc.vim'

" Lint
" =================
Plug 'neomake/neomake'

" Performance
" =================
Plug 'vim-scripts/LargeFile'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Luxury
" =================
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'justinmk/vim-sneak'
Plug 'terryma/vim-multiple-cursors'
Plug 'kshenoy/vim-signature'

Plug 'AndrewRadev/switch.vim'
Plug 'andrewradev/splitjoin.vim', { 'on': 'SplitjoinSplit' }
Plug 'andrewradev/splitjoin.vim', { 'on': 'SplitjoinJoin' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

Plug 'rhlobo/vim-super-retab', { 'on': 'Space2Tab' }
Plug 'rhlobo/vim-super-retab', { 'on': 'Tab2Space' }

Plug 'junegunn/limelight.vim', { 'on': 'Limelight!' }
Plug 'jkramer/vim-narrow', { 'on': 'Narrow' }
Plug 'jkramer/vim-narrow', { 'on': 'Widen' }


" Initialize plugin system
call plug#end()


" ===============================================
" Plugin Configs
" ===============================================


" NERDTree
" ===============
map <F8> :NERDTreeToggle<CR>


" vim-mark
" ===============
map <Leader>h \m
vmap <Leader>h \m
map <2-LeftMouse> \m

" Maximum colors available
let g:mwDefaultHighlightingPalette = 'maximum'


" nerdcommenter
" ===============
map '' <Leader>c<Space>
vmap '' <Leader>c<Space>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1


" delimitMate
" ===============
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_expand_cr = 1


" LargeFile
" ===============
let g:LargeFile = 0.5


" lightline.vim
" ===============
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
        \ }


" yaifa
" ===============
let g:yafa_tab_width = 4
let g:yafa_indentation = 1


" splitjoin.vim
" ===============
nmap <Leader>ls :SplitjoinSplit<CR>
nmap <Leader>lj :SplitjoinJoin<CR>


" indentlines
" ===============
let g:indentLine_char = '┆'
let g:indentLine_color_term = 32


" limelight.vim
" ===============
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_paragraph_span = 3
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'


" vim-sneak
" ===============
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


" vim-better-whitespace
" ===============
" Automatically remove trailling spaces on save
autocmd BufWritePre <buffer> StripWhitespace


" switch.vim
" ===============
let g:switch_mapping = "çç"


" deoplete
" ===============
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#auto_complete_delay = 50
let g:deoplete#disable_auto_complete = 1

let g:deoplete#omni#functions = {}

let g:deoplete#omni#functions.javascript = [
    \ 'tern#Complete',
    \ 'jspc#omni',
    \ 'syntaxcomplete#Complete',
    \ 'webcomplete#complete'
\]

" Let <Tab> do the completion
inoremap <silent><expr> <Tab>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#mappings#manual_complete()

" Close the documentation window when completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


" neomake
" ===============
autocmd! BufEnter,BufWritePost * Neomake
let g:neomake_open_list = 2
let g:neomake_verbose = 1

let neomake_javascript_enabled_makers = ['eslint']

let g:neomake_warning_sign = {
    \ 'text': 'W',
    \ 'texthl': 'WarningMsg',
\}

let g:neomake_error_sign = {
    \ 'text': 'E',
    \ 'texthl': 'ErrorMsg',
\}

" ESLint
let g:neomake_javascript_eslint_maker = {
    \ 'args': ['--no-color'],
    \ 'errorformat': '%f: line %l\, col %c\, %m',
\}

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe='/usr/local/bin/eslint_d'


" ===============================================
" Core Settings
" ===============================================


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

" No annoying backup files
set nobackup
set nowritebackup
set noswapfile

" Efficient way to move through your code using the Arrow Keys
map <silent> <Left> h
map <silent> <Down> gj
map <silent> <Up> gk
map <silent> <Right> l

" ===============================================
" Interface
" ===============================================

syntax on

" Add a line above the cursor
set cursorline

" Indentation options
set autoindent
set smartindent
set cindent
set preserveindent
set copyindent
set shiftround
set smarttab
set wrap

" Uncomment it for Spaces, instead of Tabs
set expandtab

" The size of your indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Indentation for HTML
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head"

" Automatically set wrap when starting a vim diff
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" True Colors
set t_Co=256

" Colorscheme
autocmd BufReadPost * colorscheme wasabi256
set background=dark

" Transparency in some terminals
autocmd BufReadPost * hi Normal ctermbg=none
autocmd BufReadPost * highlight NonText ctermbg=none

" Colorscheme for vimdiff
if &diff
  colorscheme jellybeans
endif

" General vision
set lbr
set tw=250
set scrolloff=5

" Status Line
set noruler
set laststatus=2

" Hybrid numbers column, active by default
set relativenumber
set number


" ===============================================
" Hotkeys
" ===============================================


" 'b' goes to the beginning of a line. 'e' to the end of the line.
map b 0
map e $

" F2 toggles the number lines
map <silent> <F2> :set number!<Cr>:set relativenumber!<Cr>

" Search only in visual selection
vnoremap / <Esc>/\%V

" PrettyXML: Format a line of XML
vmap <Leader>fx :!xmllint --format --recover - 2>/dev/null<CR>

" PrettyJSON: Format a line of JSON
vmap <Leader>fj :!python -m json.tool<CR>
