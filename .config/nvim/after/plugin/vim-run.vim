if plugin#is_loaded('vim-run')
	augroup PluginVimRun
		autocmd!
		autocmd FileType sh,perl    nnoremap <F5> :Run<CR>G
		autocmd FileType javascript nnoremap <F5> :Run<CR>G
		autocmd FileType python     nnoremap <F5> :Run<CR>G
	augroup END
endif
