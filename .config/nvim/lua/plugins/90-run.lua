return {
    { -- https://github.com/sbdchd/vim-run
        'sbdchd/vim-run',
        config = function()
            vim.g.run_cmd_flux = {
                'influx',
                'query',
                '--file',
                vim.fn['run#defaults#fullfilepath'](),
            }

            vim.cmd [[
                augroup PluginVimRun
                    autocmd!
                    autocmd FileType flux       nnoremap <F5> :Run<CR>G
                    autocmd FileType javascript nnoremap <F5> :Run<CR>G
                    autocmd FileType perl       nnoremap <F5> :Run<CR>G
                    autocmd FileType python     nnoremap <F5> :Run<CR>G
                    autocmd FileType sh         nnoremap <F5> :Run<CR>G
                    autocmd FileType typescript nnoremap <F5> :Run<CR>G
                    autocmd FileType yaml       nnoremap <F5> :Run<CR>G
                augroup END
            ]]
        end,
        event = {'BufReadPost', 'BufNewFile'},
    },
}
