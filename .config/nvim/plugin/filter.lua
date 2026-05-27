-- Generic command to pipe buffer through external filter and show in scratch buffer
-- Usage: :Filter <command>
-- Example: :Filter jq .
-- Example: :Filter gotmpl2text
-- Works on whole buffer or visual selection
local scratch = require('utils.scratch')

local function filter_to_scratch(filter_cmd, line1, line2)
    local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
    local content = table.concat(lines, '\n')

    local output = vim.fn.system(filter_cmd, content)
    local exit_code = vim.v.shell_error

    local cmd_name = filter_cmd:match('^%S+')
    local buf_name = '[' .. cmd_name .. ' output]'

    if exit_code ~= 0 then buf_name = '[' .. cmd_name .. ' output - exit code: ' .. exit_code .. ']' end

    scratch.create_buffer({
        name = buf_name,
        content = output,
        filetype = nil,
        modifiable = (exit_code ~= 0),
    })
end

vim.api.nvim_create_user_command('Filter', function(opts) filter_to_scratch(opts.args, opts.line1, opts.line2) end, {
    nargs = '+',
    range = '%',
    complete = 'shellcmd',
    desc = 'Pipe buffer/selection through external filter to scratch buffer',
})
