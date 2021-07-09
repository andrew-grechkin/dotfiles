" => Automation -------------------------------------------------------------------------------------------------- {{{1

cnoreabbrev waq wqa

augroup DetectFileUpdated
	autocmd!
	autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * silent! checktime
augroup END

augroup SettingsByFileType
	autocmd!
	autocmd FileType *           setlocal textwidth=120 wrapmargin=0
	autocmd FileType qf,help,man setlocal nobuflisted | nnoremap <silent> <buffer> q :bwipeout<CR>
	autocmd FileType Run         setlocal nobuflisted | nnoremap <silent> <buffer> q :bwipeout!<CR>
augroup END

augroup SettingsByBufType
	autocmd!
if has('nvim-0.4')
	autocmd TermEnter * setlocal scrolloff=0
endif
	autocmd BufEnter * if (winnr('$') == 1 && (&buftype ==# 'quickfix' || &buftype ==# 'loclist')) | bd | endif
	autocmd BufEnter * if (
			\ &buftype ==# 'nofile' ||
			\ &buftype ==# 'loclist') |
			\ nnoremap <silent> <buffer> q :bwipeout<CR> |
		\ endif
augroup END

"augroup save_restore_position
"	autocmd!
"	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
"augroup END

augroup pre_post_process
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
	autocmd BufWritePost .config/nvim/colors/molokai-grand.vim source .config/nvim/colors/molokai-grand.vim
	""" Remove all trailing whitespaces (ALE does this better)
"	autocmd BufWritePre  *        :%s/\s\+$//e
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

augroup AutoGzipForNonstandardExtensions
	autocmd!
	""" Enable editing of gzipped files
	""" The functions are defined in autoload/gzip.vim
	""" Set binary mode before reading the file
	""" Use "gzip -d", gunzip isn't always available
	autocmd BufReadPre,FileReadPre     *.dsl.dz,*.dict.dz setlocal bin
	autocmd BufReadPost,FileReadPost   *.dsl.dz,*.dict.dz call     gzip#read("gzip -dn -S .dz")
	autocmd BufWritePost,FileWritePost *.dsl.dz,*.dict.dz call     gzip#write("gzip -S .dz")
	autocmd FileAppendPre              *.dsl.dz,*.dict.dz call     gzip#appre("gzip -dn -S .dz")
	autocmd FileAppendPost             *.dsl.dz,*.dict.dz call     gzip#write("gzip -S .dz")
augroup END

"let ssh_client=$SSH_CLIENT
"if ssh_client != ''
"	" Automatically call OSC52 function on yank to sync register with host clipboard
"	augroup Yank
"		autocmd!
"		autocmd TextYankPost * if v:event.operator ==# 'y' | call xterm#yank_osc52() | endif
"	augroup END
"endif
