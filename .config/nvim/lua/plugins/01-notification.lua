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
                background_colour = 'NotifyBackground',
                fps = 30,
                icons = {DEBUG = '', ERROR = '', INFO = '', TRACE = '✎', WARN = ''},
                level = 2,
                minimum_width = 50,
                render = 'default',
                stages = 'fade_in_slide_out',
                timeout = 5000,
                top_down = true,
            }

            plugin.setup(config)
        end,
    },
}
