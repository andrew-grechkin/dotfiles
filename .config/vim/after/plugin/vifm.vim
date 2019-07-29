if plugin#is_loaded('vifm.vim')
	let g:vifm_embed_split = 1

	noremap <silent> <leader><leader>n :EditVifm<CR>
endif
