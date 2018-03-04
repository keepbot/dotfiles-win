""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status Line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set laststatus=2
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}\
"set statusline+=%{StatuslineGit()}
" set statusline+=%#LineNr#
set statusline+=%#CursorColumn#
set statusline+=\ %F%m%r%h%w
set statusline+=%=
set statusline+=%y\ \|\ \[%{&ff}]\ \|\ \[%{&enc}]\ \|\ %{&fenc}%=(ch:%3b\ hex:%2B)\ \|\ Col:%2c\ \|\ Line:%2l/%L\ \|\ [%2p%%]
