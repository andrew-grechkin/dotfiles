local f = vim.api.nvim_create_user_command

-- Make command to always run silently and auto-open quickfix
vim.api.nvim_create_user_command('Make', function(opts)
    vim.cmd('silent! make ' .. opts.args)
    vim.cmd('redraw!')
    local qflist = vim.fn.getqflist()
    if #qflist > 0 then vim.cmd('copen') end
end, {nargs = '*', bang = true, complete = 'file'})

-- Override :make with Make
vim.cmd([[cabbrev make Make]])

-- Decode current file to UTF-8; arg forces source encoding, defaults to detected
f('Decode', function(a)
    vim.cmd('edit! ++enc=' .. (a.args ~= '' and a.args or vim.bo.fileencoding))
    vim.bo.fileformat, vim.bo.fileencoding = 'unix', 'utf-8'
end, {nargs = '?', bang = true})

-- Save file with root privileges
f('W', function()
    vim.cmd('silent w !sudo tee % > /dev/null')
    vim.cmd('edit!')
end, {bang = true})

-- Normalize leading indentation to tabs or spaces per 'expandtab'/'tabstop'
f('Retab', function()
    local ts, et = vim.bo.tabstop, vim.bo.expandtab
    local view = vim.fn.winsaveview()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local changed = false
    for i, line in ipairs(lines) do
        local lead = line:match('^[ \t]*')
        local width = 0
        for ch in lead:gmatch('.') do width = ch == '\t' and width + ts - width % ts or width + 1 end
        local indent = et and string.rep(' ', width) or string.rep('\t', math.floor(width / ts)) ..
                           string.rep(' ', width % ts)
        if indent ~= lead then
            changed = true
            lines[i] = indent .. line:sub(#lead + 1)
        end
    end
    if changed then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.fn.winrestview(view)
    end
end, {bang = true})
