""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Auto complete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set completeopt=menuone,menu
"               |       |
"               |       + Display popup
"               + Display when single option

" Hide help when cursor moved
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Set cursor shape
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Complete shortcuts
imap <C-Space> <C-X><C-I>
imap <Nul> <C-X><C-I>
