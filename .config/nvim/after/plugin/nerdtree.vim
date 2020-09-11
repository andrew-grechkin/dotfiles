if plugin#is_loaded('nerdtree')
	let NERDTreeShowHidden        = 1
	let NERDTreeCaseSensitiveSort = 1
	let NERDTreeShowBookmarks     = 1
	let NERDTreeHijackNetrw       = 0
	let NERDTreeQuitOnOpen        = 1

	augroup PluginNERDTree
		autocmd!
		" Enable NERDTree on Vim startup
"		autocmd VimEnter * NERDTree
		" Autoclose NERDTree if it's the only open window left
		autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	augroup END

	noremap <leader><leader>n :NERDTreeToggle<CR>
endif

" => Plugin: vim-nerdtree-syntax-highlight ----------------------------------------------------------------------- {{{1

"let g:NERDTreeHighlightCursorline            = 0
"let g:NERDTreeLimitedSyntax                  = 1
"let g:NERDTreeSyntaxDisableDefaultExtensions = 1
"let g:NERDTreeDisableExactMatchHighlight     = 1
"let g:NERDTreeDisablePatternMatchHighlight   = 1
"let g:NERDTreeSyntaxEnabledExtensions        = ['c', 'h', 'c++', 'hpp', 'go', 'pm', 'pl']
