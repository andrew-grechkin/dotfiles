return {
    { -- https://github.com/rcarriga/nvim-notify
        'rcarriga/nvim-notify',
        keys = {
            {
                '<leader><leader>N',
                function() require('notify').dismiss({silent = true, pending = true}) end,
                desc = 'Dismiss all Notifications',
            },
        },
        init = function()
            local plugin = require('notify')
            vim.notify = plugin
            print = function(...)
                local print_safe_args = {}
                local _ = {...}
                for i = 1, #_ do table.insert(print_safe_args, tostring(_[i])) end
                plugin(table.concat(print_safe_args, ' '), 'info')
            end
        end,
        opts = {
            background_colour = '#000000',
            fps = 30,
            icons = {DEBUG = '', ERROR = '', INFO = '', TRACE = '✎', WARN = ''},
            level = 2,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width = function() return math.floor(vim.o.columns * 0.75) end,
            minimum_width = 30,
            on_open = function(win) vim.api.nvim_win_set_config(win, {zindex = 100}) end,
            render = 'default',
            stages = 'fade',
            timeout = 5000,
            top_down = false,
        },
    },
}
