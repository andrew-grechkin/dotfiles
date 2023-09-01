if !plugin#is_loaded('vifm.vim') | finish | endif

let g:vifm_embed_split = 1

nnoremap <silent> <leader><leader>n :EditVifm<CR>
