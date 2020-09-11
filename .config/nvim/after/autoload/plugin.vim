function! plugin#is_loaded(name)
	return (has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir))
endfunction
