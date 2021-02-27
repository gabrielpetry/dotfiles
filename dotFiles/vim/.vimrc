" vim: fdm=marker
" Plugins {{{ 
" Auto install to vim plug
" :CocInstall coc-css
" :CocInstall coc-tsserver
" :CocInstall coc-phpls
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" To install plugs use :PlugInstall
call plug#begin()
  " Colorscheme
  Plug 'tyrannicaltoucan/vim-deep-space'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'arcticicestudio/nord-vim'
  Plug 'haishanh/night-owl.vim'
  Plug 'morhetz/gruvbox'
  " Syntax
  Plug 'severin-lemaignan/vim-minimap'
  Plug 'leafgarland/typescript-vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'briancollins/vim-jst' " ejs syntax
  Plug 'posva/vim-vue'
  Plug 'hdima/python-syntax'
  Plug 'mechatroner/rainbow_csv' " csv columns color
  Plug 'jwalton512/vim-blade' " Laravel blade template
  " Plug 'nathanaelkane/vim-indent-guides'
  Plug 'pangloss/vim-javascript'
  Plug 'saltstack/salt-vim'
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'vim-volt/volt'
  " Interface
  Plug 'majutsushi/tagbar' " Show function names
  Plug 'gregsexton/matchtag' " heighlight matching html tag
  Plug 'kshenoy/vim-signature' " Show marks
  Plug 'w0rp/ale' " Async linting engine
  Plug 'terryma/vim-multiple-cursors'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons' " icons for NERDTree
  Plug 'justinmk/vim-sneak'
  " Plug 'joeytwiddle/sexy_scroller.vim' " Smotth scrolling
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'junegunn/goyo.vim' " Zen mode
  Plug 'tpope/vim-markdown'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'voldikss/vim-floaterm'
  " Helpers
  Plug 'tpope/vim-fugitive' " Git wrapper, it's illegal
  Plug 'tpope/vim-sleuth' " Auto set tabs or spaces based on file
  Plug 'godlygeek/tabular'
  Plug 'mattn/emmet-vim'
  Plug 'tpope/vim-commentary'
  Plug 'cohama/lexima.vim' " Auto close (){}[]
  Plug 'vim-scripts/ctags.vim'
  Plug 'sumpygump/php-documentor-vim'
  "Plug 'codota/tabnine-vim'
  Plug 'ctrlpvim/ctrlp.vim'
  " Plug 'garbas/vim-snipmate'
  Plug 'honza/vim-snippets'
  Plug 'skywind3000/asyncrun.vim'
  " Deps
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  " Plug 'roxma/nvim-yarp' " ncm2 deps
  Plug 'djoshea/vim-autoread' " Reaload files automagically
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  " Plug 'neovim/go-client'
  " Plug 'zchee/nvim-go', { 'do': 'make'}
  Plug 'rbgrouleff/bclose.vim'
  Plug 'ptzz/lf.vim'
  Plug 'Yggdroot/indentLine'
  Plug 'NLKNguyen/papercolor-theme'
call plug#end()
" }}}
let mapleader = " "
" => VIM user interface {{{ 
  set so=7 " Minimium lines in the bot and top of cursors,
" Wildmenu {{{
  " enable wildmenu
  set wildmenu

  autocmd! bufwritepost .vimrc source % " Reload the .vimrc on write
  " autocmd BufEnter * call ncm2#enable_for_buffer() " auto start ncm2
  " set completeopt=noinsert,menuone,noselect " set to no autocomplete with only one match
  " set shortmess+=c
  "     inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
  "     inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  "     inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Better copy and paste
  set pastetoggle=<F2>
  set clipboard=unnamed

  " enable mouse and backspace
  set mouse=a
  map <F3> <ESC>:set mouse=<CR>
  map <F4> <ESC>:set mouse=<CR>
  set bs=2

  " enable filetype plugin
  filetype plugin on
  filetype plugin indent on

  " quick save
  nmap <leader>w :w!<cr>
  noremap <silent> <C-S> :update<CR>
  vnoremap <silent> <C-S> <C-C>:update<CR>
  inoremap <silent> <C-S>  <C-O>:update<CR>
  nmap <leader>wq :wq!<cr>
  map <leader>qq :q!<cr>
  map <leader>e <esc>:w!<cr>:Bclose<cr>

  " Wildmenu ignores compiled files
  set wildignore=*.o,*~,*.pyc
  if has("win16") || has("win32")
      set wildignore+=.git\*,.hg\*,.svn\*
  else
      set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
  endif
  

  autocmd FileType apache setlocal commentstring=#\ %s
  nmap <C-Bslash> <Plug>CommentaryLine
  vmap <C-Bslash> <Plug>Commentary

" }}}

  " command line hight
  set cmdheight=1

  " A buffer becomes hidden when it is abandoned
  set hid

  "floaterm
  let g:floaterm_position='bottom'
  let g:floaterm_wintype="split"
  nnoremap <C-q> :FloatermToggle<CR>
  nnoremap <C-e> :FloatermToggle<CR> !! <CR>
  tnoremap <C-q> <C-\><C-n>:FloatermToggle<CR>

" fix backspace
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search config {{{
  " Ignora case sensitive quando esta no modo de busca
  set ignorecase

  " Improve searching by using case senstive only if informed
  set smartcase

  " Highlight search results
  set hlsearch

  " Improve search
  set incsearch

  " Better performance
  set ttyfast
  set lazyredraw

  set magic
  " }}}

  " No error sounds {{{
  set noerrorbells
  set novisualbell
  set t_vb=
  set tm=500
  " }}}

  set history=700
  set undolevels=700
  " Tabs and spaces config {{{
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  " set shiftround
  set expandtab
  set smarttab
  " }}}

  " Bind :find to ctrl + p
  " nnoremap <c-p> <esc>:find 
" }}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors, themes and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color scheme config {{{
" Enable syntax Highlight
" set background=dark
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
let g:sneak#label = 1
let g:sneak#s_next = 1
" colorscheme deep-space
" colorscheme dracula
" let g:deepspace_italics=1
" let g:airline_theme='deep_space'
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" colorscheme night-owl
" colorscheme gruvbox
colorscheme dracula
set showtabline=2
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline = {
      \ 'colorscheme': 'nightowl',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'

let g:lightline                  = {}
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

" makes background transparent
hi Normal guibg=NONE ctermbg=NONE
" Cool changes for js files
hi jsImport gui=bold,italic 
hi jsFrom gui=bold,italic guifg=lightgreen
hi jsImport gui=bold,italic guifg=lightgreen
hi jsAsyncKeyWord gui=bold,italic guifg=lightgreen
hi jsGlobalNodeObjects gui=bold,italic guifg=lightgreen
hi jsStorageClass gui=bold,italic guifg=lightgreen
" 80 chars rules
set colorcolumn=120
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

set cursorline
let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:hybrid_transparent_background = 1
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Make background transparent
" qautocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE
" force dark background
" set background=dark
set encoding=utf8
" Somecolor scheme have weird colors for the fold ;(
" hi Folded ctermfg=2
" Better contrast for comments
hi Comment ctermfg=12
" Define unix with current filesystem
set ffs=unix,dos,mac

set ruler
let g:indentLine_enabled=1
let g:indentLine_char='┆'

" Equivalent to the above.
let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
" }}}
" Vim airline config {{{
" let g:airline#extensions#tabline#enabled=1
" let g:airline#extensions#tabline#show_buffers = 1
" let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" let g:airline#extensions#tabline#show_close_button = 0
" let g:airline#extensions#tabline#fnamemod = ':t'
" " let g:airline_theme = 'bubblegum'
" let g:airline_theme = 'deep_space'
" let g:airline#extensions#tagbar#enabled = 1
" 
" 
" set laststatus=2
" let g:airline_powerline_fonts = 1
" " let g:airline_theme='bubblegum'
" let g:airline_powerline_fonts=1
" let g:airline#extensions#branch#enabled=1
" 
" " Indent Guides
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" 
" " unicode symbols
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_alt_sep = ''
" 
" let g:airline_symbols.crypt = '🔒'
" let g:airline_symbols.linenr = '☰'
" " let g:airline_symbols.linenr = '␊'
" " let g:airline_symbols.linenr = '␤'
" " let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.maxlinenr = 'ln'
" let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.spell = 'Ꞩ'
" let g:airline_symbols.notexists = 'Ɇ'
" let g:airline_symbols.whitespace = 'Ξ'
" let g:airline_symbols.readonly = ''

" }}}
" Script to change color schemes
" Change the color scheme from a list of color scheme names.
" Version 2010-09-12 from http://vim.wikia.com/wiki/VimTip341
" Press key:
"   F8                next scheme
"   Shift-F8          previous scheme
"   Alt-F8            random scheme
" Set the list of color schemes used by the above (default is 'all'):
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors my               (names built into script)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)
" Set the current color scheme based on time of day:
"   :SetColors now
if v:version < 700 || exists('loaded_setcolors') || &cp
  finish
endif

let loaded_setcolors = 1
let s:mycolors = ['slate', 'torte', 'darkblue', 'delek', 'murphy', 'elflord', 'pablo', 'koehler']  " colorscheme names that we use to set color

" Set list of color scheme names that we will use, except
" argument 'now' actually changes the current color scheme.
function! s:SetColors(args)
  if len(a:args) == 0
    echo 'Current color scheme names:'
    let i = 0
    while i < len(s:mycolors)
      echo '  '.join(map(s:mycolors[i : i+4], 'printf("%-14s", v:val)'))
      let i += 5
    endwhile
  elseif a:args == 'all'
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let s:mycolors = uniq(sort(map(paths, 'fnamemodify(v:val, ":t:r")')))
    echo 'List of colors set from all installed color schemes'
  elseif a:args == 'my'
    let c1 = 'default elflord peachpuff desert256 breeze morning'
    let c2 = 'darkblue gothic aqua earth black_angus relaxedgreen'
    let c3 = 'darkblack freya motus impact less chocolateliquor'
    let s:mycolors = split(c1.' '.c2.' '.c3)
    echo 'List of colors set from built-in names'
  elseif a:args == 'now'
    call s:HourColor()
  else
    let s:mycolors = split(a:args)
    echo 'List of colors set from argument (space-separated names)'
  endif
endfunction

command! -nargs=* SetColors call s:SetColors('<args>')

" Set next/previous/random (how = 1/-1/0) color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor(how)
  call s:NextColor(a:how, 1)
endfunction

" Helper function for NextColor(), allows echoing of the color name to be
" disabled.
function! s:NextColor(how, echo_color)
  if len(s:mycolors) == 0
    call s:SetColors('all')
  endif
  if exists('g:colors_name')
    let current = index(s:mycolors, g:colors_name)
  else
    let current = -1
  endif
  let missing = []
  let how = a:how
  for i in range(len(s:mycolors))
    if how == 0
      let current = localtime() % len(s:mycolors)
      let how = 1  " in case random color does not exist
    else
      let current += how
      if !(0 <= current && current < len(s:mycolors))
        let current = (how>0 ? 0 : len(s:mycolors)-1)
      endif
    endif
    try
      execute 'colorscheme '.s:mycolors[current]
      break
    catch /E185:/
      call add(missing, s:mycolors[current])
    endtry
  endfor
  redraw
  if len(missing) > 0
    echo 'Error: colorscheme not found:' join(missing)
  endif
  if (a:echo_color)
    echo g:colors_name
  endif
endfunction

nnoremap <F8> :call NextColor(1)<CR>
nnoremap <S-F8> :call NextColor(-1)<CR>
nnoremap <A-F8> :call NextColor(0)<CR>

" Set color scheme according to current time of day.
function! s:HourColor()
  let hr = str2nr(strftime('%H'))
  if hr <= 3
    let i = 0
  elseif hr <= 7
    let i = 1
  elseif hr <= 14
    let i = 2
  elseif hr <= 18
    let i = 3
  else
    let i = 4
  endif
  let nowcolors = 'elflord morning desert evening pablo'
  execute 'colorscheme '.split(nowcolors)[i]
  redraw
  echo g:colors_name
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable backup and swap {{{
set nobackup
set nowb
set noswapfile
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{
set number
" Line limiting config {{{
" set tw=79
set wrap
set fo-=t
" }}}

" Sort
vnoremap <leader>s :sort<CR>

" Better ident
set ts=2 sw=2 et
vnoremap < <gv
vnoremap > >gv

" Add conceal to files
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{
" remove highligh
map <silent> <leader><cr> :noh<cr>

" Better navigation beetween panes {{{
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nmap H <esc>:tabprevious<CR>
nmap L <esc>:tabnext<CR>
nmap J <esc>:bprevious<CR>
nmap K <esc>:bnext<CR>

" }}}

" remap 0 to first non blank char
map 0 ^
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ emmet
let g:user_emmet_mode='a'
let g:user_emmet_install_global = 0
autocmd FileType html,php,css,javascript,javascript.jsx,volt,vue  EmmetInstall

let g:user_emmet_leader_key='<C-y>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}
autocmd BufWritePost *.js AsyncRun -post=checktime ./node_modules/.bin/eslint --fix %

autocmd BufNewFile,BufRead *.styl set ft=sass
autocmd BufNewFile,BufRead *.styl set syntax=sass


" Goyo - zenmode
nmap <leader>f :Goyo<cr>


"  }}}

" NERDTree {{{

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" map <C-f> :NERDTreeToggle<CR>
function MyNerdToggle()
    if &filetype == 'nerdtree'
        :NERDTreeToggle
    else
        :NERDTreeFind
    endif
endfunction

nnoremap <C-f> :call MyNerdToggle()<CR>

" find file in tree view
" map <C-b> :NERDTreeFind<CR>
map <leader>r :NERDTreeRefreshRoot<CR>

let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_autofind = 1

" let g:NERDTreeDirArrowExpandable = ' '
" let g:NERDTreeDirArrowCollapsible = ' '
let g:NERDTreeDirArrowExpandable = ' '
let g:NERDTreeDirArrowCollapsible = ' '

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" LF
map <C-b> :Lf<CR>
let g:lf_map_keys = 0

" }}}

" Folding config {{{
" let s:middot='·' " u+00b7
" let s:raquo='»' " u+00bb
" let s:small_l='ℓ' " u+2113

let s:middot='' " u+00b7
let s:raquo='' " u+00bb
let s:small_l='ℓ' " u+2113

set fillchars=vert:»
set fillchars+=fold:\ "

function! BetterFold() abort
    let l:start = "  " . s:raquo . " "
    let l:lines = '[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
    let l:first = substitute(getline(v:foldstart), '\v *', '', '')
    " Remove inital comments from the fold title
    let l:first = substitute(l:first, '"', '', 'g' )
    let l:first = substitute(l:first, '#', '', 'g' )
    let l:first = substitute(l:first, '//', '', 'g' )
    let l:first = substitute(l:first, "\{\{\{", '', 'g' )
    let l:dashes = substitute(v:folddashes, '-', s:middot, 'g')
    " Return formatted
    return l:start . l:lines . l:dashes . ' ' . l:first
endfunction

set foldtext=BetterFold()
nnoremap <space> za

autocmd FileType js UltiSnipsAddFiletypes javascript-es6

" }}}
"
" CoC {{{

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')


autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>

" let g:go_def_mode='gopls'
" let g:go_info_mode='gopls'

let g:ale_linters = {
	\ 'go': ['gopls'],
	\}


" Go stuff
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_term_enabled = 1
let g:go_list_type = "quickfix"
let g:go_addtags_transform = "camelcase"

let g:go_auto_type_info = 0
let g:go_updatetime = 2000
let g:go_info_mode = 'gocode'
let g:go_auto_sameids = 1 

let g:go_template_autocreate = 1

" remove gd mappings
let g:go_def_mapping_enabled = 0
"let g:go_def_mode='gopls'

let g:ale_go_langserver_executable = 'gopls'

" vim-go
augroup vg
"au FileType go nmap <LocalLeader>b :GoBuild<CR>
" au FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
" au FileType go nmap <LocalLeader>c :GoCallers<CR>
" au FileType go nmap <LocalLeader>ce :GoCallees<CR>
" au FileType go nmap <LocalLeader>? :GoCoverageToggle<CR>
" au FileType go nmap <LocalLeader>D :GoDefPop<CR>
" au FileType go nmap <LocalLeader>v :GoImplements<CR>
" au FileType go nmap <LocalLeader>I :GoImports<CR>
" au FileType go nmap <LocalLeader>i :GoInstall<CR>
" au FileType go nmap <LocalLeader>y :GoPlay<CR>
" au FileType go nmap <LocalLeader>' :GoDocBrowser<CR>
" au FileType go nmap <LocalLeader>b :GoToggleBreakpoint<CR>
" au FileType go nmap <LocalLeader>db :GoDebug<CR>
" au FileType go nmap <LocalLeader>re :Refactor extract
" au FileType go nmap <LocalLeader>st <Plug>(go-run-tab)
" au FileType go nmap <LocalLeader>sp <Plug>(go-run-split)
" au FileType go nmap <LocalLeader>vs <Plug>(go-run-vertical)
" au FileType go nmap <LocalLeader>. :GoAlternate<CR>
" au FileType go nmap <LocalLeader>T :GoTestFunc
" au FileType go nmap <LocalLeader>t :GoTest
" au FileType go nmap <LocalLeader>r :GoReferrers<CR>
" " au FileType go  nmap gr :GoReferrers<CR>
" au FileType go nmap <LocalLeader>p :GoChannelPeers<CR>
" au FileType go nmap <LocalLeader>d :GoDef<CR>
" au FileType go nmap <LocalLeader>k :GoInfo<CR>
" au FileType go nnoremap <LocalLeader>e :GoIfErr<CR>

" }}}

" PHP Documentor {{{
" au BufRead,BufNewFile *.php inoremap <buffer> <C-P> :call PhpDoc()<CR>
" au BufRead,BufNewFile *.php nnoremap <buffer> <C-P> :call PhpDoc()<CR>
" au BufRead,BufNewFile *.php vnoremap <buffer> <C-P> :call PhpDocRange()<CR>
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom functions

function! HasPaste() " {{{
    if &paste
        return 'PASTE MODE  ' '
    endif
    return ''
endfunction
"  }}}

" Don't close window, when deleting a buffer " {{{
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction
" }}}

function! CmdLine(str) " {{{
    call feedkeys(":" . a:str)
endfunction
" }}}

function! VisualSelection(direction, extra_filter) range " {{{
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
"   }}}
