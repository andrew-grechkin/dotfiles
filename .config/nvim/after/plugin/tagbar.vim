if !plugin#is_loaded('tagbar') | finish | endif

noremap <leader><leader>' :TagbarToggle<CR>
