syntax enable

"install plug-vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
" Appearence {{{ "
"Plug 'itchyny/lightline.vim'		" UI
"Plug 'ap/vim-buftabline'		" buffers to tabline
"Plug 'connorholyday/vim-snazzy'
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'
Plug 'dylanaraps/wal.vim'
Plug 'mhinz/vim-startify'

" }}} Appearence "
" Side bars{{{
Plug 'scrooloose/nerdtree'		" NERD Tree
Plug 'Xuyuanp/nerdtree-git-plugin' 	" show git status in Nerd tree
Plug 'mbbill/undotree'
Plug  'preservim/tagbar'
" }}}
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} " Completion as in vscode
Plug 'preservim/nerdcommenter' " comments code
Plug 'junegunn/goyo.vim' " zen mode
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'vim-utils/vim-man'
Plug 'sheerun/vim-polyglot' "all lang packs :)
Plug 'qpkorr/vim-bufkill'
"JS {{{
Plug 'https://github.com/pangloss/vim-javascript.git'
Plug 'posva/vim-vue'
Plug 'prettier/vim-prettier'
Plug 'dense-analysis/ale' "ES-Lint
Plug 'pangloss/vim-javascript'
Plug 'heavenshell/vim-jsdoc', { 'for': ['javascript', 'javascript.jsx','typescript'],  'do': 'make install' }
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'SirVer/ultisnips'
Plug 'albanm/vuetify-vim'
"}}}
": Latex{{{
Plug 'lervag/vimtex'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"}}}
"Rust {{{
Plug 'rust-lang/rust.vim'

"}}}
"V {{{
Plug 'ollykel/v-vim'
"}}}
" Markdown {{{
Plug 'godlygeek/tabular'
"Plug 'plasticboy/vim-markdown'
"}}}
" GIT {{{
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" }}}

Plug 'ryanoasis/vim-devicons' " icons
Plug 'ap/vim-css-color'

call plug#end()

" Globals
let mapleader = " "
let g:filetype = 'on'
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
set guifont=FiraCode:h11
" auto folds
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-html', 
  \ 'coc-css', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-emoji',
  \ ]

"===================================================
" config 
" =================================================
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set hidden
set nu
set wrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set autoread
set backspace=indent,eol,start
set textwidth=80
set relativenumber
"set mouse=a " use mouse to place cursor




" Windows {{{
nnoremap <leader>qq :qall <CR> " quit all
nnoremap <leader>qQ :qall! <CR> " quit all force
nnoremap <leader>QQ :qall! <CR> " quit all force
nnoremap <leader>Qq :qall! <CR> " quit all force

nnoremap <leader>wh :wincmd h<CR> " focus left  window 
nnoremap <leader>wj :wincmd j<CR> " focus down  window 
nnoremap <leader>wk :wincmd k<CR> " focus up    window 
nnoremap <leader>wl :wincmd l<CR> " focus right window 
nnoremap <leader>ws :split<CR>    " split horizontally
nnoremap <leader>wv :vsplit<CR>   " split Vertically
nnoremap <leader>wd :hide<CR>     " hide window
" }}}
"
"Buffers {{{
nnoremap <leader>bs :w<CR>        " save buffer
nnoremap <leader>bk :BD!<CR>      " kill buffer, forcefully
nnoremap <leader>bd :BD<CR>       " kill buffer, prompt save
nnoremap <leader>bh :bp<CR>       " switch  to left buffer
nnoremap <leader>bl :bn<CR>       " switch  to right buffer
nnoremap <leader>br! :e<CR>       " refresh buffer
"}}}

"Tabs {{{
nnoremap <leader><tab>j :tabprevious<CR> " prev  tab
nnoremap <leader><tab>k :tabnext<CR>     " next  tab
nnoremap <leader><tab>l :tablast<CR>     " last  tab
nnoremap <leader><tab>d :tabclose<CR>    " close tab
nnoremap <leader><tab>n :tabnew<CR>      " new   tab
"}}}

" Files{{{
nnoremap <leader>op :NERDTreeToggle .<CR> " Nerd tree
nnoremap <leader>fp :e ~/.vimrc<CR>       " open this file
" }}

"Open {{{
nnoremap <leader>ot :split <CR> :wincmd j <CR>  :term <CR> :res 15 <CR> " open terminal in a split buffer
nnoremap <leader>oT :term<CR>                                           " open terminal in this buffer
" }}}
"
"Function keys {{{
autocmd filetype tex nnoremap <F5> :LLPStartPreview<CR>  "compile
nnoremap <F8> :TagbarToggle<CR>
" }}}

" Other {{{
nnoremap <leader>u :UndotreeShow<CR>  " show undotree
nnoremap <leader>. :Ranger<CR>        " show ranger

 "extras
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-g> <C-\><C-n>
" }}}

" key bindings {{{
" }}}

" coc config
" ======
" use tab
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"use enter to confirm completion
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Prettier {{{
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
" }}}

autocmd FileType vue syntax sync fromstart	" fix sync in vue files

""auto complete for omnifunction
filetype plugin on
set omnifunc=youcompleteme#CompleteFunc

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

"set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
set termguicolors     " enable true colors support
"let g:lightline = {  'colorscheme': 'snazzy'  }
set background=dark
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE " trasnperant!

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:v_autofmt_bufwritepre = 0
" {{{ UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-tab>'
let g:ltiSnipsJumpBackwardTrigger="<s-tab>"
" }}}

" Latex{{{
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmgs'
let g:livepreview_previewer = "zathura"
let g:livepreview_cursorhold_recompile = 1
" }}}
" Rust {{{
let g:rustfmt_autosave = 1
" }}}
