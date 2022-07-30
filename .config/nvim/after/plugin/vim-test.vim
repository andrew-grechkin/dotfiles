if !plugin#is_loaded('vim-test') | finish | endif

let g:test#strategy                = 'neovim'
let g:test#perl#prove#executable   = 'yath test --qvf'
let g:test#perl#prove#file_pattern = '\v^x?t/.*\.t$'

augroup PluginVimTest
	autocmd!
	autocmd FileType perl nmap <silent> <leader><leader>h :let $T2_WORKFLOW = line(".") \| :TestFile<CR>
	autocmd FileType perl nmap <silent> <leader><leader>f :let $T2_WORKFLOW = ""        \| :TestFile<CR>
augroup END
