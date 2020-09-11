if plugin#is_loaded('ultisnips')
	" Trigger configuration. Using <tab> here together with YouCompleteMe works because of 'supertab' plugin
	let g:UltiSnipsExpandTrigger       = '<tab>'
"	let g:UltiSnipsListSnippets        = '<c-tab>'
	let g:UltiSnipsJumpForwardTrigger  = '<tab>'
	let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

	" If you want :UltiSnipsEdit to split your window.
	let g:UltiSnipsEditSplit           = 'vertical'
endif
