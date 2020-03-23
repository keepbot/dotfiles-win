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
set expandtab

" Make tabs as wide as four spaces
set tabstop=4

" Make shift as wide as tabstop
set shiftwidth=4

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
