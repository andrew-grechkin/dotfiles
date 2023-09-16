return {
    { -- https://github.com/dstein64/vim-startuptime
        'dstein64/vim-startuptime',
        cmd = 'StartupTime', -- lazy-load on a command
        init = function() -- init is called during startup. Configuration for vim plugins typically should be set in an init function
            vim.g.startuptime_tries = 10
        end,
    },
}
