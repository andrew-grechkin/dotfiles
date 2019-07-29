"command! FilesProject    execute 'Files' dir#git_root()
command! FilesCurrentDir execute 'Files' dir#current()
"command! FilesCurrentDir  execute 'Files' getcwd()
command! FilesProject     execute 'Files' dir#git_root()

noremap <C-b>             :Buffers<CR>
noremap <C-h>             :History<CR>
noremap <C-p>             :FilesProject<CR>
noremap <C-t>             :FilesCurrentDir<CR>
