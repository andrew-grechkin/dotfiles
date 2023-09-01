if !plugin#is_loaded('tagbar') | finish | endif

nnoremap <leader><leader>' :TagbarToggle<CR>
