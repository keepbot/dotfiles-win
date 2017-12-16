""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       ______
"                      __   ____(_)______ ___
"                     __ | / /_  /__  __ `__ \
"                     __ |/ /_  / _  / / / / /
"                     _____/ /_/  /_/ /_/ /_/
"
" ------------------------------------------------------------------------------

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Basic settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix for: "[[2;2R"
set t_u7=

" Turn on vim features (no compatible with vi)
set nocompatible

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Better line breaks
set breakindent

" Enable history
set history=1000

" Enable : in keywords
set iskeyword=@,~,48-57,_,192-255

" Enable hidden buffers
set hidden

" Disable visual bell
set noerrorbells
set novisualbell
set t_vb=

" Set grep prorgram
set grepprg=grep\ -nH\ $*

" Enable mouse in all modes
set mouse=nv
set mousehide
set mousemodel=popup

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed,unnamedplus

" Save clipboard on exit
autocmd VimLeave * call system("xsel -ib", getreg('+'))

" Allow cursor keys in insert mode
set esckeys

" Don’t add empty newlines at the end of files
set binary
set noeol

" Allow backspace in insert mode
set backspace=indent,eol,start

" Don’t show the intro message when starting Vim
set shortmess=atI

" Ignore case of searches
set ignorecase

" Respect modeline in files
set modeline
set modelines=4

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Show the cursor position
set ruler

" Show the current mode
set showmode

" Show the (partial) command as it’s being typed
set showcmd

" Reload file without prompting if it has changed on disk.
" Will still prompt if there is unsaved text in the buffer.
set autoread

" Auto completiion files: prompt, don't auto pick.
set wildmode=longest,list

" Use one space, not two, after punctuation.
set nojoinspaces

" Spelling
" set spell
" set spelllang=en,fromtags

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Display
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Background
set background=dark
"set background=light

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Set colors
"colorscheme monokai
"colorscheme hybrid
colorscheme gruvbox
"colorscheme mirec

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=80
set wrap

" Enable line numbers
set number

" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif
noremap <leader>. :set relativenumber!<CR> :set number!<CR> :GitGutterToggle <CR>

" Set visible lines / columns before and after cursor
set scrolloff=3
set sidescroll=5

" Set wrap long lines by word, but not by letter
set lbr

" Hide conceal chars
set conceallevel=2

" Show the filename in the window titlebar
set title

" Show matching brackets
set showmatch

" Highlight searches
set hlsearch

" Highlight dynamically as pattern is typed
set incsearch

" Disable toolbars
if has("gui_running")
	set guioptions-=T
endif

" Optimize for fast terminal connections
set ttyfast

" Highlight current line
set cursorline

" Automatic sync (slow!)
" autocmd BufEnter * syntax sync fromstart

" Max 500 lines for syntax
" syntax sync minlines=500

" Split symbols
if has("multi_byte")
	set fillchars=stl:\ ,stlnc:\ ,vert:┆,fold:-,diff:-
else
	set fillchars=stl:\ ,stlnc:\ ,vert:\|,fold:-,diff:-
endif

" Whitespace symbols
if has("multi_byte")
" set lcs=tab:»·,trail:·,nbsp:·
" set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" set lcs=tab:\⁝\ ,trail:•,extends:>,precedes:<,nbsp:¤"
	set lcs=tab:»·,trail:•,extends:>,precedes:<,nbsp:¤"
	let &sbr = nr2char(8618).' '
else
	set lcs=tab:>\ ,extends:>,precedes:<,trail:-
	let &sbr = '+++ '
endif

function! UpdateLcs()
	if (&previewwindow)
		setlocal nolist
	endif
endfunction

autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter * call UpdateLcs()
set list

" Highlight extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter *{cpp,h,hpp,php,python,css,js,html,xhtml,htm} match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd InsertEnter *{cpp,h,hpp,php,python,css,js,html,xhtml,htm} match ExtraWhitespace /\s\+\%#\@<!$\| \+\ze\t\%#\@<!/
autocmd InsertLeave *{cpp,h,hpp,php,python,css,js,html,xhtml,htm} match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinLeave *{cpp,h,hpp,php,python,css,js,html,xhtml,htm} call clearmatches()

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Formating
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions=jroq1
" Legenda:
" jcroq1
" ||||||
" |||||+ Not break lines in insert mode
" ||||+ Formatting with gq
" |||+ Insert comment leader after 'o'
" ||+ Insert comment leader after <Enter>
" |+ Auto wrap comments using textwidth
" + Remove comment leader when joining lines if it makes sense

" Wrap on end
set wrapmargin=0
set linebreak

" Copy indent structure
set copyindent
set preserveindent

" Round to tabs
set shiftround

" Replace tabs with spaces.
"set expandtab

" Make tabs as wide as two spaces
set tabstop=2

" Make shift as wide as tabstop
set shiftwidth=2

" Indent for language
set smartindent

set display=lastline

" Adjust indent
xnoremap <Tab> >gv
au BufEnter * xnoremap <Tab> >gv
au InsertLeave * xnoremap <Tab> >gv
xmap <BS> <gv

func! RetabIndents()
	execute '%!unexpand --first-only -t '.&ts
endfunc
command! RetabIndents call RetabIndents()

func! ReformatHTML() range
	let content = join(getline(a:firstline, a:lastline), "\n")
	let baka = @a
	let baks = @/
	let @a = content
	silent execute 'new'
	silent execute 'normal "ap'
	silent execute 'set filetype=html'
	silent execute ':%s/^\s*//g'
	silent execute ':%s/\s*$//g'
	silent execute ':%s/<[^>]*>/\r&\r/g'
	silent execute ':%g/^$/d'
	silent execute 'normal 1G'
	silent execute 'normal VG'
	silent execute 'normal ='
	silent execute 'normal 1G'
	silent execute 'normal VG'
	silent execute 'normal "ay'
	silent execute ':bdelete!'
	silent execute a:firstline.','.a:lastline.'d'
	silent execute 'normal "aP'
	let @a = baka
	let @/ = baks
endfunc

command! -range=% ReformatHTML <line1>,<line2>call ReformatHTML()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language options
"language messages en
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
if (has('win32') || has('win64')) && has('gui_running')
  set encoding=cp1251 nobomb
  set termencoding=cp1251
  set guifont=Consolas:h12
else
  set encoding=utf-8 nobomb
  set termencoding=utf-8
endif
set fileencoding=utf-8

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
"au BufNewFile,BufRead *.py
"      \set tabstop=4
"      \set softtabstop=4
"      \set shiftwidth=4
"      \set textwidth=79
"      \set colorcolumn=+1
"      \set expandtab
"      \set autoindent
"      \set fileformat=unix
"
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
  autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby\<nl># -*- coding: None -*-\<nl>\"|$
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" => pathogen plugin manager: Must turn filetype off and then back on.
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin on
filetype indent on

" => a.vim (c-h. cpp-h)
autocmd FileType c,cpp map <buffer> <F12> :A<CR>
autocmd FileType c,cpp imap <buffer> <F12> <ESC>:A<CR>

" => ack.vim
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
let g:ackprg = 'ag --vimgrep'

" => ansible-vim
let g:ansible_unindent_after_newline = 1
let g:ansible_attribute_highlight = "ob"

" => ctrlp
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 20
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_switch_buffer = 0
" Only cache if we're over this number of files.
let g:ctrlp_use_caching = 2000
" Don't let ctrlp change the working directory. Instead it now uses
" the directory where vim was started. This fixes issues with some
" projects that have nested git directories.
let g:ctrlp_working_path_mode = 0
" Files to skip.
" Possibly used by other plugins, like Command-T.
set wildignore+=*.o,*.obj,.git,tmp
set wildignore+=public/uploads,db/sphinx,vim/backup
set wildignore+=.themes  " Octopress.
set wildignore+=deps,node_modules  " Phoenix
map <C-s> :CtrlPBuffer<CR>

" => delimitMate
let loaded_delimitMate = 1
let b:delimitMate_autoclose = 1

" => file-line
" When you open a file:line, for instance when coping and pasting from an error from your compiler vim tries to open a file with a colon in its name.
" vim index.html:20
" vim app/models/user.rb:1337

" => gundo
nmap <F8> :GundoToggle<CR>

" => NERDTree
" Autoload:
" autocmd vimenter * NERDTree
let NERDTreeIgnore=['\.rbc$', '\~$']
let NERDTreeShowHidden=1
" Disable menu.
let g:NERDMenuMode=0
" If you want to see nerdtree on every tab
"map <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>
"map <leader>N :NERDTreeFindIfFindable<CR> :NERDTreeMirror<CR>
"autocmd BufWinEnter * NERDTreeMirror
map <leader>n :NERDTreeToggle<CR>
map <leader>N :NERDTreeFindIfFindable<CR>
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

" => python-mode
let g:pymode_options = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion_bind = '<C-Shift-Space>'
let g:pymode_indent = 1
let g:pymode_syntax = 1
let g:pymode_lint = 1
let g:pymode_lint_ignore="E501"
let g:pymode_folding = 0

" => rainbow-parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" let g:rbpt_colorpairs = [
"     \ ['brwn',       'RoyalBlue3'],
"     \ ['Darkblue',    'SeaGreen3'],
"     \ ['dargray',    'DarkOrchid3'],
"     \ ['darkreen',   'firebrick3'],
"     \ ['darkcyan',    'RoyalBlue3'],
"     \ ['darkred',     'SeaGreen3'],
"     \ ['darkmagenta', 'DarkOrchid3'],
"     \ ['brown',       'firebrick3'],
"     \ ['gray',        'RoyalBlue3'],
"     \ ['black',       'SeaGreen3'],
"     \ ['darkmagenta', 'DarkOrchid3'],
"     \ ['Darkblue',    'firebrick3'],
"     \ ['darkgreen',   'RoyalBlue3'],
"     \ ['darkcyan',    'SeaGreen3'],
"     \ ['darkred',     'DarkOrchid3'],
"     \ ['red',         'firebrick3'],
"     \ ]

" => rename
" :rename[!] {newname}
nmap <F2> :Rename! 

" => syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"--------------
let g:syntastic_enable_signs=1
" let g:syntastic_quiet_messages = {'level': 'warnings'}
" Slow, so only run on :SyntasticCheck
"let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': [] }

let g:syntastic_error_symbol = '✖'
let g:syntastic_style_error_symbol = '✘'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_warning_symbol = '!'

let g:syntastic_php_phpcs_args="--tab-width=4"
let g:syntastic_css_phpcs_args="--tab-width=4"
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_balloons = 1
let g:syntastic_rst_checkers=['']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_cuda_config_file = "Makefile"
nmap <F7> :SyntasticCheck<CR>

" => tagbar
nmap <F10> :TagbarToggle<CR>

" => ultisnips
" silent! call UltiSnips#FileTypeChanged()
" au BufEnter * call UltiSnips#FileTypeChanged()
let g:UltiSnipsExpandTrigger="<TAB>"
let g:UltiSnipsJumpForwardTrigger="<TAB>"
let g:UltiSnipsJumpBackwardTrigger="<S-TAB>"
let g:UltiSnipsSnippetDirectories=['~/.vim/UltiSnips', 'UltiSnips']
let g:UltiSnipsTriggerInVisualMode=0

function Ultisnips_get_current_python_class()
	let l:retval = ""
	let l:line_declaring_class = search('^class\s\+', 'bnW')
	if l:line_declaring_class != 0
		let l:nameline = getline(l:line_declaring_class)
		let l:classend = matchend(l:nameline, '\s*class\s\+')
		let l:classnameend = matchend(l:nameline, '\s*class\s\+[A-Za-z0-9_]\+')
		let l:retval = strpart(l:nameline, l:classend, l:classnameend-l:classend)
	endif
	return l:retval
endfunction

function Ultisnips_get_current_python_method()
	let l:retval = ""
	let l:line_declaring_method = search('\s*def\s\+', 'bnW')
	if l:line_declaring_method != 0
		let l:nameline = getline(l:line_declaring_method)
		let l:methodend = matchend(l:nameline, '\s*def\s\+')
		let l:methodnameend = matchend(l:nameline, '\s*def\s\+[A-Za-z0-9_]\+')
		let l:retval = strpart(l:nameline, l:methodend, l:methodnameend-l:methodend)
	endif
	return l:retval
endfunction

" => vim-bufferlist
map <silent> <F3> :call BufferList()<CR>
"let g:BufferListWidth = 25
"let g:BufferListMaxWidth = 50
hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold
hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE

" => vim-commentary
xmap <leader>c <Plug>Commentary
nmap <leader>c <Plug>Commentary
nmap <leader>cc <Plug>CommentaryLine
nmap <leader>cu <Plug>CommentaryUndo

" => vim-css-syntax
augroup VimCSS3Syntax
	autocmd!
	autocmd FileType css setlocal iskeyword+=-
augroup END

" => vim-endwise
" This is a simple plugin that helps to end certain structures automatically.

" => vim-flake8
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1
let g:flake8_show_quickfix=0
autocmd BufWritePost *.py call Flake8()

" => vim-fugitive
" Fugitive.vim may very well be the best Git wrapper of all time.

" => vim-gitgutter:
let g:gitgutter_max_signs=10000
"let g:gitgutter_highlight_lines = 1
nmap <F12> :GitGutterLineHighlightsToggle<CR>

" => vim-indent-guides
nmap <C-F12> :IndentGuidesToggle<CR>
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'project']
let g:indent_guides_space_guides = 0
let g:indent_guides_tab_guides = 1
let g:indent_guides_start_level = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#1c1c1c   ctermbg=234
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=#262626   ctermbg=235

" => vim-javascript
let g:javascript_plugin_jsdoc        = 1
let g:javascript_plugin_ngdoc        = 1
let g:javascript_plugin_flow         = 1
"let g:javascript_conceal            = 1
"let g:javascript_conceal_function   = "ƒ"
"let g:javascript_conceal_null       = "ø"
"let g:javascript_conceal_this       = "@"
"let g:javascript_conceal_return     = "⇚"
"let g:javascript_conceal_undefined  = "¿"
"let g:javascript_conceal_NaN        = "ℕ"
"let g:javascript_conceal_prototype  = "¶"
"let g:javascript_conceal_static     = "•"
"let g:javascript_conceal_super      = "Ω"

" => vim-lastplace
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"

" => vim-markdown
let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html']
let g:markdown_syntax_conceal = 0

" => vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

" => vim-snippets
" This repository contains snippets files for various programming languages.

" => vim-surround
" Surrounding examples
" It's easiest to explain with examples. Press cs"' inside
" "Hello world!"
" to change it to
" 'Hello world!'
" Now press cs'<q> to change it to
" <q>Hello world!</q>
" To go full circle, press cst" to get
" "Hello world!"
" To remove the delimiters entirely, press ds".
" Hello world!
" Now with the cursor on "Hello", press ysiw] (iw is a text object).
" [Hello] world!
" Let's make that braces and add some space (use } instead of { for no space):
" cs]{
" { Hello } world!
" Now wrap the entire line in parentheses with yssb or yss).
" ({ Hello } world!)
" Revert to the original text: ds{ds)
" Hello world!
" Emphasize hello: ysiw<em>
" <em>Hello</em> world!
" Finally, let's try out visual mode. Press a capital V (for linewise visual
" mode) followed by S<p class="important">.
" <p class="important">
"   <em>Hello</em> world!
" </p>

" => vim-unimpaired
" Pairs of handy bracket mappings

" => vim-yaml-helper
let g:vim_yaml_helper#always_get_root = 1
let g:vim_yaml_helper#auto_display_path = 1

" => vimux
let g:VimuxOrientation = "h"
let g:VimuxUseNearestPane = 1
" Inspect runner pane map
map <Leader>vi :VimuxInspectRunner<CR>
" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>
" Interrupt any command running in the runner pane map
map <Leader>vs :VimuxInterruptRunner<CR>
" Clear the tmux history of the runner pane
map <Leader>vc :VimuxClearRunnerHistory<CR>
" Zoom the tmux runner page
map <Leader>vz :VimuxZoomRunner<CR>
" Prompt for a command to run
map <Leader>vv :VimuxPromptCommand<CR>
" Runners: 
map <Leader>x :call VimuxRunCommand("./" . bufname("%"), 1)<CR>
map <Leader>vx :call VimuxRunCommandInDir("./" . bufname("%"), 1)<CR>
" Run the curent python file
autocmd FileType python map <Leader>x :call VimuxRunCommand("./" . bufname("%"), 1)<CR>
autocmd FileType python map <Leader>vx :call VimuxRunCommandInDir("./" . bufname("%"), 1)<CR>
" Run the curent python file and don't hit enter
autocmd FileType python map <Leader><Leader>x :call VimuxRunCommand("va && ./" . bufname("%"), 0)<CR>
autocmd FileType python map <Leader><Leader>vx :call VimuxRunCommandInDir("va && ./" . bufname("%"), 0)<CR>
" Run the current ruby file with rspec
autocmd FileType ruby map <Leader>x :call VimuxRunCommand("clear; rspec " . bufname("%"), 1)<CR>
autocmd FileType ruby map <Leader>vx :call VimuxRunCommandInDir("clear; rspec " . bufname("%"), 1)<CR>
" Run the current ruby file with rspec and don't hit enter
autocmd FileType ruby map <Leader><Leader>x :call VimuxRunCommand("clear; rspec " . bufname("%"), 0)<CR>
autocmd FileType ruby map <Leader><Leader>vx :call VimuxRunCommandInDir("clear; rspec " . bufname("%"), 0)<CR>

" => YouCompleteMe
let g:ycm_confirm_extra_conf=0
let g:ycm_python_binary_path = 'python'
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion=['Down']
let g:ycm_key_list_previous_completion=['Up']

map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
" Python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
let python_highlight_all=1
command! Python2Completer :YcmCompleter RestartServer /usr/bin/python2
command! Python3Completer :YcmCompleter RestartServer /usr/bin/python3

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
" set wildmode=list:longest,list:full
" function! InsertTabWrapper()
"     let col = col('.') - 1
"     if !col || getline('.')[col - 1] !~ '\k'
"         return "\<tab>"
"     else
"         return "\<c-p>"
"     endif
" endfunction
" inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
" inoremap <S-Tab> <c-n>
" " . scan the current buffer, b scan other loaded buffers that are in the buffer list, u scan the unloaded buffers that 
" " are in the buffer list, w scan buffers from other windows, t tag completion
" set complete=.,b,u,w,t,]
" " Keyword list
" set complete+=k~/.vim/keywords.txt

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convert vimrc to HTML
" Link to section: *> Section name
" Section: => Section name
function! VimrcTOHtml()
	TOhtml
	try
		silent exe '%s/&quot;\(\s\+\)\*&gt; \(.\+\)</"\1<a href="#\2" style="color: #bdf">\2<\/a></g'
	catch
	endtry

	try
		silent exe '%s/&quot;\(\s\+\)=&gt; \(.\+\)</"\1<a name="\2" style="color: #fff">\2<\/a></g'
	catch
	endtry

	exe ":write!"
	exe ":bd"
endfunction

function! ReformatXml()
	%!xmllint --format --recover --encode utf-8 - 2>/dev/null
endfunction

function! ReplaceDiacritic()
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ľ/\\&#317;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Š/\\&#352;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ť/\\&#356;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ž/\\&#381;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ľ/\\&#318;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/š/\\&#353;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ť/\\&#357;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ž/\\&#382;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ŕ/\\&#340;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ĺ/\\&#313;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Č/\\&#268;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ě/\\&#282;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ď/\\&#270;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ň/\\&#327;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ř/\\&#344;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ů/\\&#366;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ŕ/\\&#341;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ľ/\\&#314;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/č/\\&#269;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ě/\\&#283;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ď/\\&#271;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ň/\\&#328;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ř/\\&#345;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ô/\\&#244;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ô/\\&#212;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ý/\\&#221;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ý/\\&#253;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Á/\\&Aacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/á/\\&aacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/É/\\&Eacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/é/\\&eacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Í/\\&Iacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/í/\\&iacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ó/\\&Oacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ó/\\&oacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/Ú/\\&Uacute;/g"
	execute "silent! " . a:firstline . "," . a:lastline . "s/ú/\\&uacute;/g"
endfunction

au BufReadPost * if getfsize(bufname("%")) > 512*1024 | set syntax= | endif

function! CleanCSS()
	try
		silent execute "%s/\\t\\+$//g"
	catch
	endtry

	try
		silent execute "%s/[ ]\\+$//g"
	catch
	endtry

	try
		silent execute "%s/\\([^ ]\\){/\\1 {/g"
	catch
	endtry

	try
		silent execute "%s/:\\([^ ]\\)\\(.*\\);/: \\1\\2;/"
	catch
	endtry
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

