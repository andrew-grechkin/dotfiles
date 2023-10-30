return {
    { -- https://github.com/rcarriga/nvim-notify
        'rcarriga/nvim-notify',
        config = function()
            local ok, plugin = pcall(require, 'notify')
            if not ok then return end

            vim.notify = plugin
            print = function(...)
                local print_safe_args = {}
                local _ = {...}
                for i = 1, #_ do table.insert(print_safe_args, tostring(_[i])) end
                plugin(table.concat(print_safe_args, ' '), 'info')
            end

            local config = {
                -- background_colour = 'NotifyBackground',
                background_colour = "#000000",
                fps = 30,
                icons = {DEBUG = '', ERROR = '', INFO = '', TRACE = '✎', WARN = ''},
                level = 2,
                minimum_width = 30,
                render = 'default',
                stages = 'fade',
                timeout = 5000,
                top_down = false,
            }

            plugin.setup(config)
        end,
    },
}
