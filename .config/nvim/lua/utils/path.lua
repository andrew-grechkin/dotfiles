local M = {}

-- Yank current buffer's path to the system clipboard.
-- @param modifier string: filename modifier passed to expand('%:...') (e.g. 'p', '.', 't')
-- @param label string: short label shown in the notification
-- @param sub_home boolean|nil: when true, replace a leading $HOME prefix with the literal '$HOME'
function M.yank(modifier, label, sub_home)
    local path = vim.fn.expand('%:' .. modifier)
    if path == '' then
        vim.notify('No file name for current buffer', vim.log.levels.WARN)
        return
    end
    if sub_home then
        local home = vim.uv.os_homedir()
        if home and path:sub(1, #home) == home then
            path = '$HOME' .. path:sub(#home + 1)
        end
    end
    vim.fn.setreg('+', path)
    vim.notify(label .. ': ' .. path)
end

return M
