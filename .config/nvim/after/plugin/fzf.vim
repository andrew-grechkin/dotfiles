if !plugin#is_loaded('fzf.vim') | finish | endif

"command! FilesProject    execute 'Files' dir#git_root()
command! FilesCurrentDir execute 'Files' dir#current()
"command! FilesCurrentDir  execute 'Files' getcwd()
command! FilesProject     execute 'Files' dir#git_root()

nnoremap <C-b>            :Buffers<CR>
nnoremap <C-h>            :History<CR>
nnoremap <C-p>            :FilesProject<CR>
nnoremap <C-t>            :FilesCurrentDir<CR>
