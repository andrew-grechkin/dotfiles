function! hl#show()
	execute 'TSHighlightCapturesUnderCursor'
endfun

" function! hl#show()
" 	let l:s = synID(line('.'), col('.'), 1)
" 	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
" endfun
