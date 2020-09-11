if plugin#is_loaded('vim-go')
"" first setup steps:
""	:GoInstallBinaries
"
"let g:go_fmt_command                 = "goimports"
"let g:go_fmt_fail_silently           = 1
"let g:go_fmt_autosave                = 1
"let g:go_fmt_experimental            = 1
"let g:go_highlight_types             = 1
"let g:go_highlight_fields            = 1
"let g:go_highlight_functions         = 1
"let g:go_highlight_function_calls    = 1
"let g:go_highlight_operators         = 1
"let g:go_highlight_extra_types       = 1
"let g:go_highlight_build_constraints = 1
"let g:go_highlight_structs           = 1
"let g:go_highlight_methods           = 1
"
""let g:go_play_open_browser           = 0
""let g:loaded_syntastic_go_gofmt_checker = 0
"
"" run :GoBuild or :GoTestCompile based on the go file
"function! s:build_go_files()
"	let l:file = expand('%')
"	if l:file =~# '^\f\+_test\.go$'
"		call go#test#Test(0, 1)
"	elseif l:file =~# '^\f\+\.go$'
"		call go#cmd#Build(0)
"	endif
"endfunction
"
"augroup SettingsByFileTypeGo
"	autocmd!
"	autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
""	autocmd BufWritePost       *.go normal! zv
"	autocmd FileType go nnoremap <leader>b :<C-u>call <SID>build_go_files()<CR>
"	autocmd FileType go nnoremap <leader>e :GoRename<CR>
"	autocmd FileType go nmap     <leader>r <Plug>(go-run)
"	autocmd FileType go nmap     <leader>c <Plug>(go-coverage-toggle)
"	autocmd FileType go nmap     <leader>i <Plug>(go-info)
"augroup END
endif
