if !plugin#is_loaded('vim-grepper') | finish | endif

runtime plugin/grepper.vim                                         " initialize g:grepper with default values
let g:grepper.highlight   = 1
let g:grepper.jump        = 0
let g:grepper.quickfix    = 0
let g:grepper.dir         = 'repo,cwd,file'
let g:grepper.repo        = ['.git', '.hg', '.svn', '.cache']
let g:grepper.side        = 0
let g:grepper.stop        = 255
let g:grepper.tools       = ['git', 'rg', 'ag', 'ack', 'ack-grep', 'grep']
let g:grepper.ag.grepprg .= ' --hidden'
let g:grepper.rg.grepprg .= ' --hidden --smart-case'

nnoremap <silent> <plug>(GrepperOperatorRepo) :let g:grepper.operator.dir='repo,cwd,file' <bar> set opfunc=GrepperOperator<cr>g@
nnoremap <silent> <plug>(GrepperOperatorFile) :let g:grepper.operator.dir='file,repo,cwd' <bar> set opfunc=GrepperOperator<cr>g@
xnoremap <silent> <plug>(GrepperOperatorRepo) :<c-u>let g:grepper.operator.dir='repo,cwd,file' <bar> call GrepperOperator(visualmode())<CR>
xnoremap <silent> <plug>(GrepperOperatorFile) :<c-u>let g:grepper.operator.dir='file,repo,cwd' <bar> call GrepperOperator(visualmode())<CR>

" Start Grepper prompt
nnoremap <leader>g         :Grepper -dir repo<CR>
nnoremap <leader>G         :Grepper -dir file<CR>
" Search for the current word
nnoremap <leader>8         :Grepper -cword -noprompt<CR>
nnoremap <leader>*         :Grepper -dir file -cword -noprompt<CR>
" Search for the current selection or {motion} (see text-objects)
nmap     gs                <Plug>(GrepperOperatorRepo)
nmap     gS                <Plug>(GrepperOperatorFile)
xmap     gs                <Plug>(GrepperOperatorRepo)
xmap     gS                <Plug>(GrepperOperatorFile)
" " Search current selection (alias for gs in visual mode)
vmap     <leader>g         <Plug>(GrepperOperatorRepo)
vmap     <leader>G         <Plug>(GrepperOperatorFile)
