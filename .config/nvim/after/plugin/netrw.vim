"let g:loaded_netrwPlugin = 1                                                   " Prevent netrw from loading
let g:netrw_banner     = 1
"let g:netrw_cursor     = 1
let g:netrw_liststyle  = 3
"let g:netrw_list_hide  = netrw_gitignore#Hide().'.*\.swp$'
"let g:netrw_preview    = 1
"let g:netrw_sizestyle  = 'H'
"let g:netrw_usetab     = 1
let g:netrw_winsize    = 25
"
" Netrw should be silent and run wget without saving history
let g:netrw_silent=1
let g:netrw_http_xcmd='-q --no-hsts -O'

"noremap <leader>n :Lexplore<CR>

"autocmd BufEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" | q | endif
