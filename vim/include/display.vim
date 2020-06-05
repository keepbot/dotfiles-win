""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Display
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set window size for GVIM
if has("gui_running")
    " GUI is running or is about to start.
    " Maximize gvim window (for an alternative on Windows, see simalt below).
    " set lines =999 columns=999
    set lines=60 columns=200
else
    " This is console Vim.
    if exists("+lines")
        set lines=50
    endif
    if exists("+columns")
        set columns=100
    endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Background: Personalized for light console themes.
if has("gui_running")
    " set background=dark
    set background=light
else
    set background=dark
    " set background=light
endif

" Set Colors
" colorscheme eclipse
" colorscheme gruvbox
" colorscheme papercolor
colorscheme pyte
" colorscheme summerfruit256

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
set conceallevel=0

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
if has("gui_running")
    set cursorline
else
    set cursorline
    :hi CursorLine   cterm=NONE ctermbg=3
    :hi CursorColumn cterm=NONE ctermbg=3
endif

" Automatic sync (slow!)
" autocmd BufEnter * syntax sync fromstart

" Max 500 lines for syntax
" syntax sync minlines=500

if (has('unix') || has('macunix'))
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

" Disable Italic comments
highlight Comment cterm=NONE gui=NONE
