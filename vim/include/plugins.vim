""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins settings
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
if (has('unix') || has('macunix'))
  let g:pymode_lint = 1
else
  let g:pymode_lint = 0
endif
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
if (has('unix') || has('macunix')|| has("gui_running"))
  let g:indent_guides_enable_on_vim_startup = 1
else
  let g:indent_guides_enable_on_vim_startup = 0
endif
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
" if has("python3")
"     command! -nargs=1 Py py3 <args>
" else
"     command! -nargs=1 Py py <args>
" endif
" Py << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   if os.name == 'nt':
"     activate_this = os.path.join(project_base_dir, 'Scripts\\activate_this.py')
"   else:
"     activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   if sys.version_info >= (3, 0):
"     exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), dict(__file__=activate_this))
"   else:
"     execfile(activate_this, dict(__file__=activate_this))
" EOF
" let python_highlight_all=1
" command! Python2Completer :YcmCompleter RestartServer /usr/bin/python2
" command! Python3Completer :YcmCompleter RestartServer /usr/bin/python3

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
