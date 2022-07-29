scriptencoding=utf-8
if !plugin#is_loaded('vim-grepper') | finish | endif

silent! runtime plugin/grepper.vim                                         " initialize g:grepper with default values
silent! let g:grepper.highlight   = 1
silent! let g:grepper.jump        = 0
silent! let g:grepper.quickfix    = 0
silent! let g:grepper.dir         = 'repo'
silent! let g:grepper.repo        = ['.git', '.hg', '.svn', '.cache']
silent! let g:grepper.stop        = 255
silent! let g:grepper.tools       = ['git', 'rg', 'ag', 'ack', 'ack-grep', 'grep']
silent! let g:grepper.ag.grepprg .= ' --hidden'
silent! let g:grepper.rg.grepprg .= ' --hidden --smart-case'

" Start Grepper prompt
nnoremap <leader>g         :Grepper -dir repo<CR>
nnoremap <leader><leader>g :Grepper -dir file<CR>
" Search for the current word
nnoremap <leader>*         :Grepper -cword -noprompt<CR>
nnoremap <leader><leader>* :Grepper -dir file -cword -noprompt<CR>
" Search for the current selection or {motion} (see text-objects)
nmap     gs                <Plug>(GrepperOperator)
xmap     gs                <Plug>(GrepperOperator)
" Search current selection (alias for gs in visual mode)
vmap     <leader>g         <Plug>(GrepperOperator)
