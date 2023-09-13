if !plugin#is_loaded('vim-fugitive') | finish | endif

let g:fugitive_gitlab_domains = ['https://gitlab.' . PRIVATE_DOMAIN . '.com']

delcommand Gbrowse
