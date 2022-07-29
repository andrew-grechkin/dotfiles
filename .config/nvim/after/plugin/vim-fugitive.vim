scriptencoding=utf-8
if !plugin#is_loaded('vim-fugitive') | finish | endif

let g:fugitive_gitlab_domains = ['https://gitlab.' . PRIVATE_DOMAIN . '.com']

nnoremap <leader><leader>c :Gstatus<CR>
