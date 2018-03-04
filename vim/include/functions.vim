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
