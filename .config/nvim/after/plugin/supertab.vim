if plugin#is_loaded('supertab')
	let g:SuperTabClosePreviewOnPopupClose = 1
	if has('python3')                                                          " compatible with YouCompleteMe
		let g:SuperTabDefaultCompletionType = '<C-n>'
	else
		let g:SuperTabDefaultCompletionType        = 'context'
		let g:SuperTabContextDefaultCompletionType = '<C-n>'
	endif
endif
