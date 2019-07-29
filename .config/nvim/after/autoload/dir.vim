function! dir#git_root()
	return system('git -C ' . expand('%:p:h') . ' rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1')[:-2]
endfunction

function! dir#current()
	return expand('%:p:h')
endfunction
