if !plugin#is_loaded('vim-run') | finish | endif

let g:run_cmd_flux = [ 'influx', 'query', '--file', run#defaults#fullfilepath() ]

augroup PluginVimRun
	autocmd!
	autocmd FileType flux       nnoremap <F5> :Run<CR>G
	autocmd FileType javascript nnoremap <F5> :Run<CR>G
	autocmd FileType python     nnoremap <F5> :Run<CR>G
	autocmd FileType sh,perl    nnoremap <F5> :Run<CR>G
	autocmd FileType yaml       nnoremap <F5> :Run<CR>G
augroup END
