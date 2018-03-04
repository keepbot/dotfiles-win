""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Snippets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:snips_author = "Dmitriy Ivanov"
let g:snips_company = "Aligh Technology"

" imap \... …

" Better completion for {
inoremap {<CR>  {<CR>}<Esc>O

" Disable delimitmate for file types
let delimitMate_excluded_ft = "mail,txt,htmldjango"

" Wrap
vmap ( <ESC>`>a)<ESC>`<i((<ESC>gv
vmap [ <ESC>`>a]<ESC>`<i[[<ESC>gv
vmap { <ESC>`>a}<ESC>`<i{{<ESC>gv
vmap \' <ESC>`>a''<ESC>`<i''<ESC>gv
vmap \" <ESC>`>a""<ESC>`<i""<ESC>gv
vmap ; <ESC>`>a“<ESC>`<i„<ESC>gv

" Reverse chars
vmap \rv c<C-O>:set revins<CR><C-R>"<Esc>:set norevins<CR>
