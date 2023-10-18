" => Automation -------------------------------------------------------------------------------------------------- {{{1

cnoreabbrev waq wqa

augroup DetectFileUpdated
	autocmd!
	autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * silent! checktime
augroup END

augroup SettingsByFileType
	autocmd!
	autocmd FileType *              setlocal textwidth=120 wrapmargin=0
	autocmd FileType Run            setlocal nobuflisted | nnoremap <silent> <buffer> <nowait> q :bwipeout!<CR>
	autocmd FileType fugitiveblame  setlocal nobuflisted | nnoremap <silent> <buffer> <nowait> q :bwipeout!<CR>
	autocmd FileType neotest-output setlocal nobuflisted | nnoremap <silent> <buffer> <nowait> q :bwipeout!<CR>
	autocmd FileType qf,help,man    setlocal nobuflisted | nnoremap <silent> <buffer> <nowait> q :bwipeout!<CR>
augroup END

augroup SettingsByBufType
	autocmd!
	if has('nvim-0.5')
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

" => -------------------------------------------------------------------------------------------------------------- {{{1
" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff
augroup encrypted
	autocmd!

	" First make sure nothing is written to ~/.viminfo while editing an encrypted file.
	autocmd BufReadPre,FileReadPre *.gpg set viminfo=
	" We don't want a swap file, as it writes unencrypted data to disk
	autocmd BufReadPre,FileReadPre *.gpg set noswapfile

	" Switch to binary mode to read the encrypted file
	autocmd BufReadPre,FileReadPre *.gpg set bin
	autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2

	autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2>/dev/null
	" Switch to normal mode for editing
	autocmd BufReadPost,FileReadPost *.gpg set nobin
	autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
	autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

	" Convert all text to encrypted text before writing
	autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --armor --encrypt --recipient=27DAEE512BCA39EB --recipient=CDBA7E3E844B6508 2>/dev/null
	" Undo the encryption so we are back in the normal text, directly after the file has been written.
	autocmd BufWritePost,FileWritePost *.gpg u
augroup END
