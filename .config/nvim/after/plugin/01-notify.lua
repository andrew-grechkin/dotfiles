local notify_ok, notify = pcall(require, 'notify')
if not notify_ok then return end

vim.notify = notify
print = function(...)
    local print_safe_args = {}
    local _ = {...}
    for i = 1, #_ do table.insert(print_safe_args, tostring(_[i])) end
    notify(table.concat(print_safe_args, ' '), 'info')
end

notify.setup({
    background_colour = 'NotifyBackground',
    fps = 30,
    icons = {DEBUG = '', ERROR = '', INFO = '', TRACE = '✎', WARN = ''},
    level = 2,
    minimum_width = 50,
    render = 'default',
    stages = 'fade_in_slide_out',
    timeout = 5000,
    top_down = true,
})
