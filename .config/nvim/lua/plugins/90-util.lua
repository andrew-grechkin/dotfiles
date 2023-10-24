return {
    { -- https://github.com/dstein64/vim-startuptime
        'dstein64/vim-startuptime',
        cmd = 'StartupTime', -- lazy-load on a command
        init = function() -- init is called during startup. Configuration for vim plugins typically should be set in an init function
            vim.g.startuptime_tries = 10
        end,
    },
    { -- url: https://github.com/diepm/vim-rest-console
        'diepm/vim-rest-console',
        config = function()
            vim.g.vrc_set_default_mapping = false
            -- vim.g.vrc_show_command = true
            vim.g.vrc_auto_format_uhex = true
            vim.g.vrc_auto_format_response_patterns = {
                json = 'jq -S',
                xml = 'tidy -xml -i -',
            }

            vim.api.nvim_exec([[

augroup PluginVimRestConsole
	autocmd!
	autocmd FileType rest       nnoremap <F5> :call VrcQuery()<CR>
augroup END

]], false)

        end,
    },
}
