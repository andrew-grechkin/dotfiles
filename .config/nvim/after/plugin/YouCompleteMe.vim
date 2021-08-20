scriptencoding=utf-8
if plugin#is_loaded('YouCompleteMe')
	let g:ycm_autoclose_preview_window_after_insertion  = 1
	let g:ycm_autoclose_preview_window_after_completion = 1

"	let g:ycm_global_ycm_extra_conf = '~/.config/shell/ycm_extra_conf.py'          " Where to search for .ycm_extra_conf.py if not found
"	let g:ycm_confirm_extra_conf                            = 0
"	let g:ycm_global_ycm_extra_conf                         = 0

"	let g:ycm_show_diagnostics_ui                           = 0 " default 1
"	let g:ycm_register_as_syntastic_checker                 = 0 " default 1

	let g:ycm_error_symbol                                  = '✘'
	let g:ycm_warning_symbol                                = '✱'
"	let g:ycm_always_populate_location_list                 = 1 " default 0

	let g:ycm_complete_in_comments                          = 1
	let g:ycm_complete_in_strings                           = 1
	let g:ycm_goto_buffer_command                           = 'new-or-existing-tab'

	let g:ycm_collect_identifiers_from_comments_and_strings = 1
	let g:ycm_collect_identifiers_from_tags_files           = 1
"	let g:ycm_seed_identifiers_with_syntax                  = 1

" necessary for UltiSnips
	" let g:ycm_key_list_select_completion                    = ['<C-n>', '<Down>', '<M-Space>']
	" let g:ycm_key_list_previous_completion                  = ['<C-p>', '<Up>']

"	nnoremap <leader>g :YcmCompleter GoTo<CR>
"	nnoremap <F9>      :YcmDiags <CR>
"	nnoremap <F11>     :YcmForceCompileAndDiagnostics <CR>
endif
