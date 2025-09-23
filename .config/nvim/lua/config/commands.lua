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

f('DecodeUtf16', ':edit! ++enc=utf-16le | set fileformat=unix | set fileencoding=utf-8', {
    bang = true,
})
f('Decode1251', ':edit! ++enc=cp1251 | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('Decode866', ':edit! ++enc=cp866 | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('DecodeKoi', ':edit! ++enc=koi8-r | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('W', ':execute \':silent w !sudo tee % > /dev/null\' | :edit!', {bang = true}) -- Save file with root privileges
f('Retab', 'call tabs#beginning()', {bang = true})
