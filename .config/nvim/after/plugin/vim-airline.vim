if plugin#is_loaded('vim-airline')
	let g:airline#extensions#ale#enabled     = 1
	let g:airline#extensions#branch#enabled  = 1
	let g:airline#extensions#keymap#enabled  = 0
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tagbar#enabled  = 1
	let g:airline#extensions#unicode#enabled = 1
	let g:airline_powerline_fonts            = 0
	let g:airline_skip_empty_sections        = 1
	let g:airline_theme                      = 'luna'
endif
