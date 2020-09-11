setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
setlocal foldmethod=indent

setlocal path+=**

augroup Python
	autocmd!
	" Regenerate tags when saving files
	autocmd BufWritePost *.py silent! !ctags -R &
augroup END
