setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4

nnoremap <buffer> <F3> :silent w! <Bar> silent exec "!(open-file <C-R>%) &>/dev/null"<CR>
nnoremap <buffer> <F5> :silent w! <Bar> silent exec "!(open-presentation <C-R>%) &>/dev/null"<CR>
