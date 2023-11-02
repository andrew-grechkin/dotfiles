T = function(t) return setmetatable(t, {__index = table}) end

function table:append(table)
    for _, v in ipairs(table) do self:insert(v) end
    return self
end

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

-- [[ detect project directory for path ]]
GET_PROJECT_DIR = function(path)
    -- local file = vim.api.nvim_buf_get_name(bufnr)
    -- vim.fn.stdpath('data')
    local dir = vim.fs.dirname(path)
    local gitpath = vim.fn.systemlist('git -C ' .. dir ..
                                          ' rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1')
    if gitpath and gitpath[1] then return gitpath[1] end

    local detected = vim.fs.dirname(vim.fs.find({
        '.bzr',
        '.hg',
        '.svn',
        '.vscode',
        'Makefile',
        'package.json',
        'pyproject.toml',
        'setup.py',
    }, {upward = true})[1])
    if detected then return detected end

    return vim.loop.cwd()
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
