if plugin#is_loaded('vim-grepper')
	silent! runtime plugin/grepper.vim                                         " initialize g:grepper with default values
	silent! let g:grepper.highlight   = 1
	silent! let g:grepper.jump        = 0
	silent! let g:grepper.quickfix    = 1
"	let g:grepper.dir                 = 'repo,cwd,file' do not uncomment. operator stops working
	silent! let g:grepper.repo        = ['.git', '.hg', '.svn', '.cache']
	silent! let g:grepper.stop        = 2000
	silent! let g:grepper.tools       = ['rg', 'git', 'ag', 'ack', 'ack-grep', 'grep']
	silent! let g:grepper.git.grepprg .= ' -i'

	silent! let g:grepper.operator.git.grepprg .= ' -i'

	nnoremap <silent> <plug>(GrepperOperatorRepo) :let      g:grepper.operator.dir='repo,cwd,file' <BAR> set opfunc=GrepperOperator<CR>g@
	nnoremap <silent> <plug>(GrepperOperatorFile) :let      g:grepper.operator.dir='file,repo,cwd' <BAR> set opfunc=GrepperOperator<CR>g@
	vnoremap <silent> <plug>(GrepperOperatorRepo) :<C-u>let g:grepper.operator.dir='repo,cwd,file' <BAR> call GrepperOperator(visualmode())<CR>
	vnoremap <silent> <plug>(GrepperOperatorFile) :<C-u>let g:grepper.operator.dir='file,repo,cwd' <BAR> call GrepperOperator(visualmode())<CR>

	" Search for the current word
	nnoremap <leader>*          <Esc>:Grepper -dir file -cword -noprompt<CR>
	nnoremap <leader>8          <Esc>:Grepper -dir repo -cword -noprompt<CR>
	" Start Grepper prompt
	nnoremap <leader>G          <Esc>:Grepper -dir file<CR>
	nnoremap <leader>g          <Esc>:Grepper -dir repo<CR>
	" Search for the current selection or {motion} (see text-objects)
	nnoremap gS                 <Plug>(GrepperOperatorFile)
	nnoremap gs                 <Plug>(GrepperOperatorRepo)

	" Search current selection (alias for gs in visual mode)
	vnoremap <leader>G          <Plug>(GrepperOperatorFile)
	vnoremap <leader>g          <Plug>(GrepperOperatorRepo)
	vnoremap gS                 <Plug>(GrepperOperatorFile)
	vnoremap gs                 <Plug>(GrepperOperatorRepo)
endif
