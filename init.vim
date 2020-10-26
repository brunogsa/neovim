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

" Public
function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Public
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" ===============================================
" Core Settings
" ===============================================

" Disable mouse
set mouse=

" Improve Performance
set ttyfast
set regexpengine=1
set modelines=0

set synmaxcol=150
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
vnoremap <buffer> <leader>Vjson y:vnew<cr>pV:s/\\//g<cr>V:call RangeJsonBeautify()<cr>


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

Plug 'ryanoasis/vim-devicons'
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
    \ 'component_function': {
    \   'filetype': 'MyFiletype',
    \   'fileformat': 'MyFileformat',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' }
  \}

  function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction
" *******

Plug 'szw/vim-maximizer'
"Configs
  let g:maximizer_set_default_mapping = 0
  nnoremap <silent><leader><F3> :MaximizerToggle<CR>
" *******

Plug 'scrooloose/nerdcommenter'
" Configs
  " Add spaces after comment delimiters by default
  let g:NERDSpaceDelims = 1

  " Use compact syntax for prettified multi-line comments
  let g:NERDCompactSexyComs = 1

  " Allow commenting and inverting empty lines (useful when commenting a region)
  let g:NERDCommentEmptyLines = 0

  nmap <leader><leader> <leader>c<space>
  vmap <leader><leader> <leader>c<space>
" *******

Plug 'Valloric/ListToggle'
" Configs
  let g:lt_location_list_toggle_map = '<leader>tl'
  let g:lt_quickfix_list_toggle_map = '<leader>tq'
" *******

Plug 'tpope/vim-surround'
Plug 'andymass/vim-matchup'

Plug 'alvan/vim-closetag'
" Configs
  let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js"
" *******

Plug 'jiangmiao/auto-pairs'
" Configs
  let g:AutoPairsFlyMode = 0
  let g:AutoPairsShortcutBackInsert = '<C-S-b>'
" *******

Plug 'chrisbra/vim-diff-enhanced'
Plug 'rickhowe/diffchar.vim'

Plug 'AndrewRadev/linediff.vim'
" Configs
  vnoremap <silent> <leader>d :Linediff<cr>
  nnoremap <silent> <leader>D :LinediffReset<cr>
" *******

Plug 'junegunn/limelight.vim'
" Configs
  vnoremap <silent> <leader>v :Limelight<cr>
  nnoremap <silent> <leader>v :Limelight!!<cr>

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
Plug 'vim-scripts/argtextobj.vim'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'paradigm/TextObjectify'
Plug 'rhysd/vim-textobj-anyblock'

Plug 'vim-utils/vim-troll-stopper'

Plug 'tpope/vim-sleuth'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Configs
  " Find files using ProjectFiles
  nnoremap <silent> <leader>f :ProjectFiles<cr>

  function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
  endfunction

  command! ProjectFiles execute 'Files' s:find_git_root()

  " Better command history with q:
  command! CmdHist call fzf#vim#command_history({'right': '40'})
  nnoremap <silent> <leader>r :CmdHist<cr>

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

  nnoremap <silent> <leader>b :call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink':    function('<sid>bufopen'),
  \   'options': '+m',
  \   'down':    len(<sid>buflist()) + 2
  \ })<cr>
" *******

Plug 'dietsche/vim-lastplace'
" Configs
  let g:lastplace_open_folds = 0
  let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
" *******

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': 'ghmarkdown'  }
" Configs
  let g:mkdp_command_for_global = 1
  nmap <silent> <leader>tm <Plug>MarkdownPreviewToggle
" *******


" Highlight
" =================

Plug 'martinda/Jenkinsfile-vim-syntax', { 'for': 'Jenkinsfile' }
Plug 'vim-scripts/groovy.vim', { 'for': 'Jenkinsfile' }

Plug 'ap/vim-css-color'

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

  " Disable it on markdown files
  autocmd VimEnter *.md IndentLinesDisable
" *******

Plug 'vim-scripts/CursorLineCurrentWindow'

" javascript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
" Configs
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 0
" *******

" ejs
Plug 'nikvdp/ejs-syntax', { 'for': ['ejs'] }

" jsx
Plug 'neoclide/vim-jsx-improve', { 'for': ['javascript', 'javascript.jsx'] }

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
" Updates are too heavy: enable me when needed
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
" Configs
  " let g:go_fmt_autosave = 0
  " let g:go_mod_fmt_autosave = 0
  " let g:go_def_mapping_enabled = 1
  " let g:go_textobj_enabled = 0
  " let g:go_textobj_include_function_doc = 0
  " let g:go_textobj_include_variable = 0
  " let g:go_fold_enable = []
" *******

" css3
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }

" scss
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }

" markdown
Plug 'tpope/vim-markdown', { 'for': 'ghmarkdown' }
" Configs
  let g:markdown_syntax_conceal = 0
  let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

  " Auto Disable indent lines on markdown files
  au BufReadPre,FileReadPre *.md,*.markdown :IndentLinesDisable
" *******

Plug 'jtratner/vim-flavored-markdown', { 'for': 'ghmarkdown' }
" Configs
  augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  augroup END
" *******

" sql
Plug 'exu/pgsql.vim', { 'for': 'sql' }
" Configs
  let g:sql_type_default = 'pgsql'
" *******


" Auto Completion
" =================

" Slower / Better mechanism
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
    \ 'num_processes': 4,
    \ 'min_pattern_length': 1
  \ })

  call deoplete#custom#source('omni', 'functions', {
    \ '_': ['syntaxcomplete#Complete', 'tmuxcomplete#complete'],
    \ 'javascript': ['syntaxcomplete#Complete', 'tmuxcomplete#complete', 'tern#Complete', 'jspc#omni'],
    \ 'go': ['gocode#Complete', 'syntaxcomplete#Complete', 'tmuxcomplete#complete']
  \ })

  " Fix an conflict with vim-multiple-cursors
  function g:Multiple_cursors_before()
    let g:deoplete#disable_auto_complete = 1
  endfunction

  function g:Multiple_cursors_after()
    let g:deoplete#disable_auto_complete = 0
  endfunction
" *******

Plug 'deoplete-plugins/deoplete-tag'
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
Plug 'mhartington/nvim-typescript', { 'do': './install.sh', 'for': 'typescript' }
" Configs
  set updatetime=1000
  let g:nvim_typescript#quiet_startup = 0
  let g:nvim_typescript#type_info_on_hold = 1
  let g:nvim_typescript#signature_complete = 1
  let g:nvim_typescript#default_mappings = 0
  let g:nvim_typescript#completion_mark = '[TS]'
" *******

" Lint
" =================

Plug 'neomake/neomake'
" Configs
  autocmd! BufWritePost,BufEnter * Neomake
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

  " JavaScript Checkers
  let g:neomake_javascript_eslint_maker = {
    \ 'exe': '/usr/local/bin/eslint',
    \ 'append_file': 0,
    \ 'args': ['--no-ignore', '-f', 'compact', '--ext', '.js,.jsx', '%:p'],
    \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m, %W%f: line %l\, col %c\, Warning - %m'
  \}

  let g:neomake_javascript_enabled_makers = ['eslint']

  " TypeScript Checkers
  let g:neomake_typescript_tsc_maker = {
    \ 'exe': '/usr/local/bin/tsc',
    \ 'append_file': 0,
    \ 'args': [
      \ '--allowJs',
      \ '--forceConsistentCasingInFileNames',
      \ '--esModuleInterop',
      \ '--jsx',
      \ 'preserve',
      \ '--lib',
      \ 'es2017,dom',
      \ '--moduleResolution',
      \ 'node',
      \ '--noEmit',
      \ '--noImplicitAny',
      \ '--noImplicitThis',
      \ '--noUnusedLocals',
      \ '--noUnusedParameters',
      \ '--skipLibCheck',
      \ '--strictNullChecks',
      \ '%:p'
    \],
    \ 'errorformat': '%E%f(%l\,%c): error %m'
  \}

  let tslintConfig = FindGlobFile('tslint.json')

  let g:neomake_typescript_tslint_maker = {
    \ 'exe': '/usr/local/bin/tslint',
    \ 'append_file': 0,
    \ 'args': ['--config', tslintConfig, '%:p'],
    \ 'errorformat': '%E%f[%l\, %c]: %m'
  \}

  let g:neomake_typescript_eslint_maker = {
    \ 'exe': '/usr/local/bin/eslint',
    \ 'append_file': 0,
    \ 'args': ['--no-ignore', '-f', 'compact', '--ext', '.ts', '%:p'],
    \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m, %W%f: line %l\, col %c\, Warning - %m'
  \}

  let g:neomake_typescript_enabled_makers = ['eslint', 'tslint']

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

Plug 'maksimr/vim-jsbeautify'
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
  \ 'javascript.jsx',
  \ 'typescript',
  \ 'css',
  \ 'scss',
  \ 'sass',
  \ 'json',
  \ 'html'
  \ ]
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

Plug 'terryma/vim-multiple-cursors'
Plug 'yuttie/comfortable-motion.vim'

Plug 'andrewradev/splitjoin.vim'
" Configs
  nnoremap <leader>ls :SplitjoinSplit<cr>
  nnoremap <leader>lj :SplitjoinJoin<cr>
" *******

Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'rhlobo/vim-super-retab'

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
set textwidth=150

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
