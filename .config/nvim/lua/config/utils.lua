T = function(t) return setmetatable(t, {__index = table}) end

function table:append(table)
    for _, v in ipairs(table) do self:insert(v) end
    return self
end

function table.pack_to_array(...) return {n = select('#', ...), ...} end

function table:each(code) for _, v in ipairs(self) do code(v) end end

function table:map(code)
    local acc = T {}
    for _, v in ipairs(self) do acc:insert(code(v)) end
    return acc
end

function table:reduce(init, code)
    local acc = init
    for _, v in ipairs(self) do acc = code(acc, v) end
    return acc
end

GIT_ROOT = function(dir)
    return vim.fn.systemlist('git -C "' .. dir ..
                                 '" rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1')[1]
end

PROJECT_GIT_ROOT_OR_CWD = function(path)
    local dir = vim.fs.dirname(path or '.')

    local gitpath = GIT_ROOT(dir)
    if gitpath then return gitpath end

    return vim.loop.cwd()
end

-- [[ detect project directory for path ]]
GET_PROJECT_DIR = function(path)
    -- local file = vim.api.nvim_buf_get_name(bufnr)
    -- vim.fn.stdpath('data')
    local dir = vim.fs.dirname(path)
    local cwd = vim.loop.cwd()

    local names = {
        '.eslintrc.json',
        '.vscode',
        'Makefile',
        'deno.json',
        'deno.jsonc',
        'package.json',
        'pyproject.toml',
        'setup.py',
    }
    local opts = {upward = true, path = dir, limit = 1}

    local gitpath = GIT_ROOT(dir)
    if gitpath then
        if gitpath == cwd then
            return gitpath
        else
            opts.stop = gitpath
        end
    end

    local detected = vim.fs.dirname(vim.fs.find(names, opts)[1])

    if detected then return detected end
    if opts.stop then return opts.stop end
    return cwd
end

-- [[ close all other listed buffers ]]
BUF_ONLY = function()
    local curbuf = vim.api.nvim_get_current_buf()
    local bufs = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(bufs) do
        if curbuf ~= bufnr then
            local listed = vim.api.nvim_buf_get_option(bufnr, 'buflisted')
            if listed then vim.api.nvim_buf_delete(bufnr, {}) end
        end
    end
end

-- local function create_scratch_buffer(title, lines)
--     local bufnr = vim.api.nvim_create_buf(false, true)

--     vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
--     vim.api.nvim_buf_set_name(bufnr, title)

--     vim.cmd('vsplit')
--     vim.api.nvim_set_current_buf(bufnr)
-- end

vim.api.nvim_create_user_command('Ai', function(opts)
    local start_line = vim.api.nvim_buf_get_mark(0, '<')[1]
    local end_line = vim.api.nvim_buf_get_mark(0, '>')[1]
    if start_line < 1 then start_line = 1 end
    if end_line < 1 then end_line = -1 end

    local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)
    local input = table.concat(selected_lines, '\n') .. '\n'

    local cmd = ('echo request: "%s"; echo; tee >(%s %s)'):format(opts.args, 'gemini-api streamed-prompt', opts.args)
    if end_line == -1 then
        cmd = ('echo request: "%s"; echo; cat | %s %s'):format(opts.args, 'gemini-api streamed-prompt', opts.args)
    end

    vim.cmd('vsplit')
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, ('gemini-api streamed-prompt %s'):format(os.time()))
    -- vim.api.nvim_win_set_buf(0, bufnr)
    vim.api.nvim_set_current_buf(bufnr)
    local job = vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
            if data then
                vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
                -- vim.api.nvim_win_set_cursor(output_winnr, {
                --     vim.api.nvim_buf_line_count(output_bufnr),
                --     0,
                -- })
                -- vim.bo[output_bufnr].modified = false
            end
        end,
        on_stderr = function(_, data) if data then vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data) end end,
    })
    vim.fn.chansend(job, input)
    vim.fn.chanclose(job, 'stdin')
end, {
    desc = 'Pipes visual selection to a command and shows output in quickfix.',
    bang = false,
    range = true,
    nargs = '*',
})
