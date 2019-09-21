" vim: fdm=marker
" Plugins {{{ 
" Auto install to vim plug
" :CocInstall coc-css
" :CocInstall coc-tsserver
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" To install plugs use :PlugInstall
call plug#begin()
  " Colorscheme
  Plug 'dracula/vim'
  " Plug 'tyrannicaltoucan/vim-quantum'
  Plug 'morhetz/gruvbox'
  " Plug 'fenetikm/falcon'
  " Plug 'nlknguyen/papercolor-theme'
  " Plug 'kristijanhusak/vim-hybrid-material'
  " Plug 'sainnhe/gruvbox-material'
  " Syntax
  Plug 'leafgarland/typescript-vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'briancollins/vim-jst' " ejs syntax
  Plug 'posva/vim-vue'
  Plug 'hdima/python-syntax'
  Plug 'mechatroner/rainbow_csv' " csv columns color
  Plug 'jwalton512/vim-blade' " Laravel blade template
  Plug 'Yggdroot/indentLine' " Show a ident line
  Plug 'pangloss/vim-javascript'
  " Plug 'mxw/vim-jsx'
  Plug 'maxmellon/vim-jsx-pretty'

  " Interface
  Plug 'majutsushi/tagbar' " Show function names
  Plug 'gregsexton/matchtag' " heighlight matching html tag
  Plug 'kshenoy/vim-signature' " Show marks
  Plug 'w0rp/ale' " Async linting engine
  Plug 'terryma/vim-multiple-cursors'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons' " icons for NERDTree
  Plug 'joeytwiddle/sexy_scroller.vim' " Smotth scrolling
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'junegunn/goyo.vim' " Zen mode
  " Plug 'jistr/vim-nerdtree-tabs' " Fix the nerd tree in the left of all tabs
  Plug 'tpope/vim-markdown'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " Helpers
  Plug 'tpope/vim-fugitive' " Git wrapper, it's illegal
  Plug 'tpope/vim-sleuth' " Auto set tabs or spaces based on file
  Plug 'godlygeek/tabular'
  Plug 'mattn/emmet-vim'
  Plug 'tpope/vim-commentary'
  Plug 'cohama/lexima.vim' " Auto close (){}[]
  Plug 'vim-scripts/ctags.vim'
  " Plug 'garbas/vim-snipmate'
  Plug 'honza/vim-snippets'
  Plug 'skywind3000/asyncrun.vim'
  " Deps
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  " Plug 'roxma/nvim-yarp' " ncm2 deps
  Plug 'djoshea/vim-autoread' " Reaload files automagically
  Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'} " intelisense
call plug#end()
" }}}
let mapleader = ","
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
  set tabstop=1
  set softtabstop=2
  set shiftwidth=2
  " set shiftround
  set expandtab
  set smarttab
  " }}}

  " Bind :find to ctrl + p
  nnoremap <c-p> <esc>:find
" }}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors, themes and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color scheme config {{{
" Enable syntax Highlight
" set background=dark
set termguicolors
syntax enable
colorscheme dracula

" makes background transparent
hi Normal guibg=NONE ctermbg=NONE
" Cool changes for js files
hi jsImport gui=bold,italic 
hi jsFrom gui=bold,italic guifg=lightgreen
hi jsImport gui=bold,italic guifg=lightgreen
hi jsAsyncKeyWord gui=bold,italic guifg=lightgreen
" 80 chars rules
set colorcolumn=80
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

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

" Equivalent to the above.
let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
" }}}
" Vim airline config {{{
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'bubblegum'
let g:airline#extensions#tagbar#enabled = 1


" set laststatus=2
let g:airline_powerline_fonts = 1
" let g:airline_theme='bubblegum'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1

" Indent Guides
let g:indentLine_enabled=1
let g:indentLine_color_term=235
" let g:indentLine_char='┆'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''

let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = 'ln'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.readonly = ''

" }}}

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
" {{{
let g:user_emmet_mode='a'
let g:user_emmet_install_global = 0
autocmd FileType html,php,css,javascript,javascript.jsx  EmmetInstall

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

map <C-f> :NERDTreeTabsToggle<CR>
" find file in tree view
map <C-b> :NERDTreeTabsOpen<CR>:NERDTreeTabsFind<CR>
map <leader>r :NERDTreeRefreshRoot<CR>

let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_autofind = 1

" let g:NERDTreeDirArrowExpandable = ' '
" let g:NERDTreeDirArrowCollapsible = ' '
let g:NERDTreeDirArrowExpandable = ' '
let g:NERDTreeDirArrowCollapsible = ' '

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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



" }}}

"
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
