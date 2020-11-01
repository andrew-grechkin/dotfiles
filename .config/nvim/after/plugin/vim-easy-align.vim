if plugin#is_loaded('vim-easy-align')
	" Start interactive EasyAlign for a motion/text object (e.g. gaip)
	nmap <leader>a <Plug>(EasyAlign)
	" Start interactive EasyAlign in visual mode (e.g. vipga)
	xmap <leader>a <Plug>(EasyAlign)
endif
