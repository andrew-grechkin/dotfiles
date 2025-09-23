setlocal foldmethod=indent
setlocal foldnestmax=1

setlocal path+=**

" => -------------------------------------------------------------------------------------------------------------- {{{1

setlocal equalprg=black\ -\ 2>/dev/null
setlocal formatprg=black\ -\ 2>/dev/null
setlocal keywordprg=:Pydoc

command! -nargs=1 Pydoc :setlocal splitright
	\| :vnew
	\| :setlocal buftype=nofile bufhidden=hide noswapfile
	\| :execute ":r !doc-pydoc-wrapper '<args>'"
	\| :Man!
	\| :vertical resize 80
	\| :norm gg

nnoremap <silent> <buffer> gz         :!<C-R>=g:zeal_app<CR> "python:<cword>"&<CR><CR>
vnoremap <silent> <buffer> gz        y:!<C-R>=g:zeal_app<CR> "python:<C-R>=escape(@",'/\')<CR>"&<CR><CR>
