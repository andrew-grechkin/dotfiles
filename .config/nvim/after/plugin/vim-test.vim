if !plugin#is_loaded('vim-test') | finish | endif

let g:test#strategy                = 'neovim'
let g:test#perl#prove#executable   = 'yath test --qvf'
let g:test#perl#prove#file_pattern = '\v(/|^)x?t/.*\.t$'

augroup PluginVimTest
	autocmd!
	autocmd FileType perl nmap <silent> <leader>th :let $T2_WORKFLOW = line(".") <bar> :TestFile<CR>
	autocmd FileType perl nmap <silent> <leader>te :let $T2_WORKFLOW = ""        <bar> :TestFile<CR>
augroup END
