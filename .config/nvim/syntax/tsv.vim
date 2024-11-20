" Disable native nvim tsv syntax: share/nvim/runtime/syntax/tsv.vim
" to prevet following error:
"
" CSV Syntax:Invalid column pattern, using default pattern \%([^,]*,\|$\)
" CSV Syntax:Or ftplugin hasn't been sourced before the syntax script

let b:current_syntax='tsv'
