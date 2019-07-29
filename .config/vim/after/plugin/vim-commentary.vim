" url: https://github.com/tpope/vim-commentary

if plugin#is_loaded('vim-commentary')
	nmap     <C-_>                         gcl
	vmap     <C-_>                         gc

	augroup SettingsVimCommentary
		autocmd!
		autocmd FileType perl,vim let b:commentary_startofline = 1
	augroup END
endif
