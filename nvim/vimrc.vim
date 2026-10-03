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

set foldmethod=indent
set foldnestmax=1

" Tabs are displayed (ie. not actually inserted) as 2 spaces
set tabstop=2
" indenting with `>>` and '<<' gives 2 spaces
set shiftwidth=2
" Pressing tab inserts spaces instead of tab characters
set expandtab

"set listchars=tab:→\,
"set list
"set listchars=tab:▸\ ,trail:·,precedes:←,extends:→
"
"note non-breakable space:
"set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
"
"set showbreak=↪\
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
"
"set showbreak=\\ " [bonus]
"set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
"
"note: below has bar for tab indents
"set listchars=tab:│·,trail:·,extends:→
"
" note: match is for trailing spaces
" match ErrorMsg '\s\+$'
" set listchars=eol:§,tab:¤›,extends:»,precedes:«,nbsp:‡
"
" set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
"
"set encoding=utf-8
"if has('gui_running')
""Display Hidden Characters
""http://en.wikipedia.org/wiki/Unicode_Geometric_Shapes
""http://www.joelonsoftware.com/articles/Unicode.html
"    set list
"    set listchars=tab:▶\ ,eol:★
"    set listchars+=trail:◥
"    set listchars+=extends:❯
"    set listchars+=precedes:❮
"
"    "vertical splits less gap between bars
"    set fillchars+=vert:│
"endif
"
"set listchars=tab:»■,trail:■
"
"

" Custom mappings:
let mapleader = ","

" netrw magic
" enable mouse usage. makes it easier to browse multiple tabs
set mouse=a
" hide netrw top message
let g:netrw_banner=0
" tree listing by default
let g:netrw_liststyle=3
" hide vim swap files
let g:netrw_list_hide='.*\.swp$'
" open files in left window by default
let g:netrw_chgwin=1

" remap shift-enter to fire up the sidebar
nnoremap <silent> <S-CR> :rightbelow 20vs<CR>:e .<CR>
" the same remap as above - may be necessary in some distros
nnoremap <silent> <C-M> :rightbelow 20vs<CR>:e .<CR>

" remap control-enter to open files in new tab
nmap <silent> <C-CR> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>
" the same remap as above - may be necessary in some distros
nmap <silent> <NL> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>



" Double click folds to open/close them
noremap <2-LeftMouse> za

" DEPRECATED Saving as sudo when you forget to start nvim as sudo
cmap w!! w !sudo tee > /dev/null %

" Toggle wrap
command! -nargs=* Wrap set wrap linebreak nolist
command! -nargs=* Nowrap set nowrap nolbr nolist


" Custom keybindings:
" Toggle vimfolds
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

"Tab navigation like Firefox
nnoremap <C-h>  :tabprevious<CR>
nnoremap <C-l>  :tabnext<CR>
nnoremap <A-h>  :tabprevious<CR>
nnoremap <A-l>  :tabnext<CR>
nnoremap <C-t>  :tabnew<CR>
nnoremap <C-q>  :tabclose<CR>
nnoremap <C-w><C-w>  :bd<CR>
"nnoremap <C-w>  :bd<CR>
inoremap <C-h>  <Esc>:tabprevious<CR>i
inoremap <C-l>  <Esc>:tabnext<CR>i
inoremap <C-t>  <Esc>:tabnew<CR>
inoremap <C-q>  <Esc>:tabclose<CR>

"Remove all search highlighting by redrawing the screen
nnoremap <silent> <leader>l :nohl<CR>

"Toggle the builtin Quickfix List
function! ToggleQuickfix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <leader>q :call ToggleQuickfix()<CR>
