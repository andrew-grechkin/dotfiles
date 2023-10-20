setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
setlocal foldmethod=syntax

setlocal path+=**

" => -------------------------------------------------------------------------------------------------------------- {{{1

nnoremap <silent> <buffer> gz         :!<C-R>=g:zeal_app<CR> "javascript:<cword>"&<CR><CR>
vnoremap <silent> <buffer> gz        y:!<C-R>=g:zeal_app<CR> "javascript:<C-R>=escape(@",'/\')<CR>"&<CR><CR>
