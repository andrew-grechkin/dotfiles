let b:did_indent = 1

setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
setlocal foldmethod=syntax
setlocal foldnestmax=1

compiler deno

setlocal path+=**

" => -------------------------------------------------------------------------------------------------------------- {{{1

nnoremap <silent> <buffer> gz         :!<C-R>=g:zeal_app<CR> "typescript:<cword>"&<CR><CR>
vnoremap <silent> <buffer> gz        y:!<C-R>=g:zeal_app<CR> "typescript:<C-R>=escape(@",'/\')<CR>"&<CR><CR>
