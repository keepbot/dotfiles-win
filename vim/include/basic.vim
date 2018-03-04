""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Basic settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix for: "[[2;2R"
set t_u7=

" Set paths
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after

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
