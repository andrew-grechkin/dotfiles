function! ShowMan(man, word)
	execute ':vertical Man ' . a:man
	let @/ = '\v(<|\.)' . a:word . '(>|\.)'
	set hlsearch
	normal n
" 	execute '/' . a:word
endfunction

command! -nargs=* ManSpecific set nohlsearch | call ShowMan(<f-args>)
