if plugin#is_loaded('vim-rooter')
	let g:rooter_patterns     = ['.config/', 'lib/', '.git', '.git/']
	let g:rooter_silent_chdir = 1
endif
