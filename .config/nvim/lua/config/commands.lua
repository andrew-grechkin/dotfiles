local f = vim.api.nvim_create_user_command

f('DecodeUtf16', ':edit! ++enc=utf-16le | set fileformat=unix | set fileencoding=utf-8', {
    bang = true,
})
f('Decode1251', ':edit! ++enc=cp1251 | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('Decode866', ':edit! ++enc=cp866 | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('DecodeKoi', ':edit! ++enc=koi8-r | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('W', ':execute \':silent w !sudo tee % > /dev/null\' | :edit!', {bang = true}) -- Save file with root privileges
f('Retab', 'call tabs#beginning()', {bang = true})
