return {
    { -- https://github.com/rcarriga/nvim-notify
        'rcarriga/nvim-notify',
        init = function()
            local plugin = require('notify')
            vim.notify = plugin

            print = function(...)
                local args = table.pack_to_array(...)
                local print_safe_args = T {}
                for i = 1, args.n do print_safe_args:insert(vim.inspect(args[i])) end
                plugin(print_safe_args:concat('\n'), 'INFO', {title = 'Print'})
            end
        end,
        keys = {
            {
                '<leader><leader>N',
                function() require('notify').dismiss({silent = true, pending = true}) end,
                desc = 'notifications: dismiss all',
            },
        },
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
