set nocompatible
set noshowmode
set hidden
syntax enable

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

" remap control-enter to open files in new tab
nmap <silent> <C-CR> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>

" DEPRECATED Saving as sudo when you forget to start nvim as sudo
cmap w!! w !sudo tee > /dev/null %

" Toggle wrap
command! -nargs=* Wrap set wrap linebreak nolist
command! -nargs=* Nowrap set nowrap nolbr nolist

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
