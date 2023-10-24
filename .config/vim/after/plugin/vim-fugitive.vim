if plugin#is_loaded('vim-fugitive')
	let g:fugitive_gitlab_domains = ['https://gitlab.' . PRIVATE_DOMAIN . '.com']

	nnoremap <leader><leader>c :Gstatus<CR>
endif
