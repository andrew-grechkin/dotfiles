-- Feed buffer content to an interactive terminal command
-- Usage: :Interactive <command>
-- Example: :Interactive jq-repl
-- Example: :Interactive python -i
-- Works on whole buffer or visual selection
local function interactive_with_buffer(cmd, line1, line2)
    local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
    local content = table.concat(lines, '\n')

    local tmpfile = vim.fn.tempname()
    vim.fn.writefile(vim.split(content, '\n'), tmpfile)

    local term_buf = vim.api.nvim_create_buf(false, true)

    vim.cmd('split')
    vim.api.nvim_win_set_buf(0, term_buf)

    local term_chan = vim.fn.termopen(cmd .. ' < ' .. tmpfile, {
        on_exit = function(job_id, exit_code, event_type)
            vim.fn.delete(tmpfile)
            -- Close the terminal buffer automatically (no pressin key to close)
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(term_buf) then
                    vim.api.nvim_buf_delete(term_buf, {force = true})
                end
            end)
        end,
    })

    vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = term_buf})

    vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('Interactive',
    function(opts) interactive_with_buffer(opts.args, opts.line1, opts.line2) end, {
        nargs = '+',
        range = '%',
        complete = 'shellcmd',
        desc = 'Feed buffer/selection to interactive terminal command',
    })
