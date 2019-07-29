setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
setlocal foldmethod=syntax

" => -------------------------------------------------------------------------------------------------------------- {{{1

setlocal iskeyword+=-
setlocal keywordprg=:vertical\ Man

nnoremap <buffer> <F3> :silent w! <Bar> silent exec "!(open-file <C-R>%) &>/dev/null"<CR>
