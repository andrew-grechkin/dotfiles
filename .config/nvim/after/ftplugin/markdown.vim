setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4

nnoremap <buffer> <F5> :silent w! <bar> silent exec "!(open-file <C-R>%) &>/dev/null"<CR>
