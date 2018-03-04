""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Menu
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enhance command-line completion
set wildmenu
set wildchar=<Tab>
set wildmode=longest:full,full
set wildignore=Ui_*,*.git,*.pyc

" Encoding menu
"set wildmenu
"set wcm=<Tab>
"menu Encoding.CP1251   :e ++enc=cp1251<CR>
"menu Encoding.CP866    :e ++enc=cp866<CR>
"menu Encoding.KOI8-U   :e ++enc=koi8-u<CR>
"menu Encoding.UTF-8    :e ++enc=utf-8<CR>
"map <F8> :emenu Encoding.<TAB>
