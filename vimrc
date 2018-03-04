""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       ______
"                      __   ____(_)______ ___
"                     __ | / /_  /__  __ `__ \
"                     __ |/ /_  / _  / / / / /
"                     _____/ /_/  /_/ /_/ /_/
"
" ------------------------------------------------------------------------------

source ./vim/include/basic.vim
source ./vim/include/keys.vim
source ./vim/include/display.vim

source ./vim/include/status.vim
source ./vim/include/menu.vim
source ./vim/include/build.vim
source ./vim/include/saving.vim
source ./vim/include/formatting.vim
source ./vim/include/language.vim
source ./vim/include/filetypes.vim
source ./vim/include/plugins.vim
source ./vim/include/snippets.vim
source ./vim/include/autocomplete.vim
source ./vim/include/functions.vim

if (has('win32') || has('win64'))
  source ./vim/include/windows.vim
endif
