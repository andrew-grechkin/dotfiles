if plugin#is_loaded('nerdcommenter')
	let g:NERDCommentEmptyLines      = 1                                        " Allow commenting and inverting empty lines (useful when commenting a region)
	let g:NERDCustomDelimiters       = { 'c': { 'left': '/**','right': '*/' } } " Add your own custom formats or override the defaults
	"let g:NERDDefaultAlign           = 'start'                                  " Comment at the beginning of the line instead of following code indentation
	let g:NERDRemoveExtraSpaces      = 1
	let g:NERDSpaceDelims            = 1                                        " Add spaces after comment delimiters by default
	let g:NERDToggleCheckAllLines    = 1                                        " Enable NERDCommenterToggle to check all selected lines is commented or not
	let g:NERDTrimTrailingWhitespace = 1                                        " Enable trimming of trailing whitespace when uncommenting

	" map comment to ctrl-/
	map <C-_> <Plug>NERDCommenterToggle
endif
