scriptencoding=utf-8
if !plugin#is_loaded('vim-plug') | finish | endif

let g:plug_timeout = 300                                                       " Increase vim-plug timeout for YouCompleteMe

nnoremap <leader><leader>u :PlugUpdate<CR>
