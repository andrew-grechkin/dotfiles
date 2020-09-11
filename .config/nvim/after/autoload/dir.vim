function! dir#git_root()
	return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

function! dir#current()
	return expand('%:p:h')
endfunction
