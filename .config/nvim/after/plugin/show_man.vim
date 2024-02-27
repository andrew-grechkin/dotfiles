function! ShowMan(man, word)
	execute ':vertical Man ' . a:man
	execute '/' . a:word
	let @/ = '\v<' . a:word . '>'
	set hlsearch
	normal n
endfunction

command! -nargs=* ManSpecific set nohlsearch | call ShowMan(<f-args>)
