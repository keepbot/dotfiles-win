""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Saving
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Write after buffer leave
" set autowrite

" Backup
set backup
set backupdir=~/.vim/backups,.,~/

" Tmp directory
set directory=~/.vim/tmp,~/tmp,.,/tmp

" Ask before close
set noconfirm

" Viminfo
set viminfo='50,\"500
"            |    |
"            |    + Maximum number of files for each register
"            + Save max 50 files

" Persistend undo
set undodir=~/.vim/undo
set undofile
set undolevels=2048
set undoreload=65538

" Reload file, preserve history
command! Reload %d|r|1d

" HTML
let html_number_lines = 0
let use_xhtml = 1
let html_use_css = 1
