""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings for file types
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Automatic commands
" if has("autocmd")
" 	" Enable file type detection
" 	filetype on
" 	" Treat .json files as .js
" 	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
" 	" Treat .md files as Markdown
" 	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
"   " Jump to the last position
"   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" endif

" New files:
au BufNewFile,BufRead *.py
      \set tabstop=4
      \set softtabstop=4
      \set shiftwidth=4
      \set textwidth=79
      \set colorcolumn=+1
      \set expandtab
      \set autoindent
      \set fileformat=unix

" YAML file type
" au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

augroup Shebang
  autocmd BufNewFile *.awk 0put =\"#!/usr/bin/awk -f\<nl>\"|$
  autocmd BufNewFile *.bash 0put =\"#!/usr/bin/env bash \<nl>\"|$
  " autocmd BufNewFile *.\(c\|h\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
  " autocmd BufNewFile *.\(cc\|hh\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
  " autocmd BufNewFile *.\(cpp\|hpp\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
  autocmd BufNewFile *.js 0put =\"#!/usr/bin/env node\<nl>\"|$
  autocmd BufNewFile *.lua 0put =\"#!/usr/bin/env lua\<nl>\"|$
  autocmd BufNewFile *.make 0put =\"#!/usr/bin/make -f\<nl>\"|$
  autocmd BufNewFile *.php 0put =\"#!/usr/bin/env php\<nl>\"|$
  autocmd BufNewFile *.pl 0put =\"#!/usr/bin/env perl\<nl>\"|$
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl># -*- coding: utf-8 -*-\<nl>\"|$
  autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby -w\<nl># -*- coding: utf-8 -*-\<nl>\"|$
  autocmd BufNewFile *.sed 0put =\"#!/usr/bin/env sed\<nl>\"|$
  autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env sh\<nl>\"|$
  autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
  autocmd BufNewFile *.zsh 0put =\"#!/usr/bin/env zsh\<nl>\"|$
augroup END

" c
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c,*.hh,*.cc set filetype=c.doxygen
augroup END

" cpp
function! EnhanceCppSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
endfunction
autocmd Syntax cpp call EnhanceCppSyntax()
autocmd FileType c,cpp nmap <F5> "lYml[[kw"cye'l
autocmd FileType c,cpp nmap <F6> :set paste<CR>ma:let @n=@/<CR>"lp==:s/\<virtual\>\s*//e<CR>:s/\<static\>\s*//e<CR>:s/\<explicit\>\s*//e<CR>:s/\s*=\s*[^,)]*//ge<CR>:let @/=@n<CR>'ajf(b"cPa::<Esc>f;s<CR>{<CR>}<CR><Esc>kk:nohlsearch<CR>:set nopaste<CR>
autocmd FileType c,cpp set foldmethod=indent
autocmd FileType c,cpp set foldlevel=6

" python
" autocmd BufNewFile *.py execute "set paste" | execute "normal i# -*- coding: utf-8 -*-\rfrom __future__ import unicode_literals\r" | execute "set nopaste"
autocmd BufNewFile *.py execute "set paste" | execute "normal ifrom __future__ import unicode_literals\r" | execute "set nopaste"
autocmd FileType python set completeopt=menuone,menu,preview
autocmd FileType python setlocal complete+=k
autocmd FileType python setlocal isk+=".,("
autocmd BufRead *.py setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
let g:python_recommended_style=0

" javascript
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript set completefunc=javascriptcomplete#CompleteJS

" html
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType html set completefunc=htmlcomplete#CompleteTags
autocmd FileType html set filetype=htmldjango
autocmd FileType htmldjango vmap \tr <ESC>`>a'' %}<ESC>`<i{{% trans ''<ESC>

" css
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType css set completefunc=csscomplete#CompleteCSS

" common completion
autocmd FileType c,cpp,java,php,python,html,css,javascript imap <C-Space> <C-X><C-O>
autocmd FileType c,cpp,java,php,python,html,css,javascript imap <Nul> <C-X><C-O>

" Ansible Vault
au BufNewFile,BufRead *.yml,*.yaml call s:DetectAnsibleVault()
fun! s:DetectAnsibleVault()
    let n=1
    while n<10 && n < line("$")
        if getline(n) =~ 'ANSIBLE_VAULT'
            set filetype=ansible-vaulta
            " execute "!ansible-vault edit --vault-password-file=./password %"
            " execute "!ansible-vault edit %"
        endif
        let n = n + 1
    endwhile
endfun
