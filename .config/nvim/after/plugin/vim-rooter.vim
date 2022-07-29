scriptencoding=utf-8
if !plugin#is_loaded('vim-rooter') | finish | endif

let g:rooter_patterns     = ['.config/', '.git', '.git/']
let g:rooter_silent_chdir = 1
