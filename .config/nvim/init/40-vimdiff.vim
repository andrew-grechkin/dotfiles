" => vimdiff ----------------------------------------------------------------------------------------------------- {{{1

set diffopt+=iwhite,vertical,context:3
silent! set diffopt+=algorithm:patience,indent-heuristic
if &diff
	augroup diff_only_configs
		autocmd!
		let s:is_started_as_vim_diff = 1
		setlocal nospell
		setlocal cmdheight=2                                                   " Increase lower status bar height in diff mode
		nnoremap <leader>n             ]czz
		nnoremap <leader>p             [czz
		nnoremap <leader>u             :diffupdate<CR>
		nnoremap <leader>a             :call diff#toggle_algorithm()<CR>
		nnoremap <leader>i             :call diff#toggle_ignore_whitespace()<CR>

		nnoremap <Left>                <C-W><Left>
"		nnoremap <Down>                ]czz
"		nnoremap <Up>                  [czz
		nnoremap <Right>               <C-w><Right>
	augroup END
else
	augroup save_restore_folds                                                 " save and restore folds only in non-diff mode
		autocmd!
		autocmd BufWinEnter * silent! loadview
		autocmd BufWinLeave * silent! mkview
	augroup END
endif
