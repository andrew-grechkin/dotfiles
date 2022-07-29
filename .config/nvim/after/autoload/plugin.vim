function! plugin#is_loaded(name)
	return (exists("g:plugs") && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir))
endfunction
