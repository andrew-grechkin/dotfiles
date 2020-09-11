"command! FilesProject    execute 'Files' dir#git_root()
"command! FilesCurrentDir execute 'Files' dir#current()
command! FilesCurrentDir  execute 'Files' getcwd()
command! FilesProject     execute 'Files' dir#git_root()

noremap <C-p>             :FilesCurrentDir<CR>
noremap <C-t>             :FilesProject<CR>
noremap <leader><leader>b :Buffers<CR>
