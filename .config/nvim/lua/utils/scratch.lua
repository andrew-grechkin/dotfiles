-- Utility functions for creating scratch buffers
local M = {}

-- Detect filetype from content (pretty dumb but usefull)
-- @param content string: buffer content
-- @return string|nil: detected filetype or nil
local function detect_filetype(content)
    if content:match('^%s*[{%[]') then
        return 'json'
    elseif content:match('^%-%-%-') or content:match('^%s*%w+:%s*%S') then
        return 'yaml'
    elseif content:match('^<?xml') or content:match('^<html') then
        return 'xml'
    end
    return nil
end

-- Create and display a scratch buffer with content
-- @param opts table: {name, content, filetype, modifiable}
--   - name: buffer name to display
--   - content: string content to put in buffer
--   - filetype: string or nil (nil = auto-detect)
--   - modifiable: boolean or nil (default: true)
-- @return number: buffer number
function M.create_buffer(opts)
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buf})
    vim.api.nvim_set_option_value('buflisted', false, {buf = buf})
    vim.api.nvim_set_option_value('buftype', 'nofile', {buf = buf})
    vim.api.nvim_set_option_value('swapfile', false, {buf = buf})

    vim.api.nvim_buf_set_name(buf, opts.name)

    -- for some reason buffer shows newline as explicit line if there is one.
    -- thus i'm explicitly removing ALL newlines at the end even though there must be one left by the standard
    local content = opts.content:gsub('\n+$', '')
    local content_lines = vim.split(content, '\n')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content_lines)

    local filetype = opts.filetype
    if filetype == nil then filetype = detect_filetype(opts.content) end
    if filetype then vim.api.nvim_set_option_value('filetype', filetype, {buf = buf}) end

    if opts.modifiable ~= nil then vim.api.nvim_set_option_value('modifiable', opts.modifiable, {
        buf = buf,
    }) end

    vim.cmd('sbuffer ' .. buf)

    return buf
end

return M
