""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Change mapleader
let mapleader=","

" Disable help
noremap <F1> ""

" Navigation with C-up / C-down
map <C-down> gj
map <C-up> gk

" Switch between the last two files
nnoremap <Leader><Leader> <c-^>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Get off my lawn
" nnoremap <Left>   :echoe "Use h"<CR>
" nnoremap <Right>  :echoe "Use l"<CR>
" nnoremap <Up>     :echoe "Use k"<CR>
" nnoremap <Down>   :echoe "Use j"<CR>

" Create a split on the given side.
" From http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/ via joakimk.
nmap <leader><C-H>    :leftabove  vsp<CR>
nmap <leader><left>   :leftabove  vsp<CR>
nmap <leader><C-L>    :rightbelow vsp<CR>
nmap <leader><right>  :rightbelow vsp<CR>
nmap <leader><C-J>    :leftabove  sp<CR>
nmap <leader><up>     :leftabove  sp<CR>
nmap <leader><C-K>    :rightbelow sp<CR>
nmap <leader><down>   :rightbelow sp<CR>

"split navigations
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>

" Working with tabs
"map <S-t> :tabprevious<cr>
"nmap <S-t> :tabprevious<cr>
"imap <S-t> <ESC>:tabprevious<cr>i
map <S-Tab> :tabnext<cr>
nmap <S-Tab> :tabnext<cr>
imap <S-Tab> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr>

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Paste
noremap <leader>ii :set paste<CR>

" Turn off search highligting until the next search
nnoremap <leader>3 :nohl<CR>

