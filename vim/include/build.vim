""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Build
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Run make
map <F9> :make -j 2<CR>

" Auto jump to first error
set cf

"let errormarker_erroricon = "/usr/share/icons/oxygen/16x16/status/dialog-error.png"
"let errormarker_warningicon = "/usr/share/icons/oxygen/16x16/status/dialog-warning.png"
let &errorformat="%-GIn file included from %f:%l:%c\\,,%-GIn file included from %f:%l:%c:,%-Gfrom %f:%l\\,,-Gfrom %f:%l:%c\\,," . &errorformat
set errorformat+=%D%*\\a[%*\\d]:\ Entering\ directory\ `%f'
