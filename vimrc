set laststatus=2
set showtabline=2
set nocompatible
set noshowmode
set cursorline
set termguicolors 
set hidden
set nowrap
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set number
syntax enable

call plug#begin()
    Plug 'mtdl9/vim-log-highlighting'
    Plug 'itchyny/lightline.vim'
    Plug 'morhetz/gruvbox'
    Plug 'chrisbra/unicode.vim'
    Plug 'altercation/vim-colors-solarized'
    Plug 'wfxr/minimap.vim'
call plug#end()

let g:lightline = {'colorscheme': 'molokai', }

filetype plugin indent on

let g:netrw_list_hide = '^\..*'
let g:netrw_hide = 1

let g:gruvbox_termcolors = 256
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
colorscheme gruvbox

if !has('gui_running')
    set ttimeout
	augroup NoInsertKeycodes
		autocmd!
		autocmd InsertEnter * set timeoutlen=100
		autocmd InsertLeave * set timeoutlen=1001
	augroup END
endif
nnoremap <C-c> <Esc>

set pastetoggle=<F2>
"nnoremap <C-m> :MinimapToggle<CR>
"nnoremap <C-a> <C-w>>
"nnoremap <C-s> <C-w>+
"nnoremap <C-W>= <C-W>=

vnoremap <Leader>s :sort<CR>

"inoremap <silent> <c-g>u <esc>guawea
"inoremap <silent> <c-g>U <esc>gUawea
"
"nnoremap <silent> <C-j> :m .+1<CR>==
"nnoremap <silent> <C-k> :m .-2<CR>==
"vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
"vnoremap <silent> <C-k> :m '<-2<CR>gv=gv
