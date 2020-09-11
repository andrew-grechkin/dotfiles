if plugin#is_loaded('vimwiki/vimwiki')
	let g:vimwiki_list = [
		\{'path': '~/.local/share/wiki', 'syntax': 'markdown', 'ext': '.mdwiki'},
		\{'path': 'wiki',                'syntax': 'markdown', 'ext': '.mdwiki'}
	\]
endif
