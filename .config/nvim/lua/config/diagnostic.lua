-- => h: vim.diagnostic.config ------------------------------------------------------------------------------------ {{{1
local signs = T {
    {texthl = 'DiagnosticSignError', text = ''},
    {texthl = 'DiagnosticSignHint', text = ''},
    {texthl = 'DiagnosticSignInfo', text = ''},
    {texthl = 'DiagnosticSignWarn', text = ''},
}

signs = signs:map(function(it)
    it['name'] = it['texthl']
    it['numhl'] = ''
    return it
end)

vim.fn.sign_define(signs)

local config = {
    float = {source = true},
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {source = true, spacing = 4},
}

vim.diagnostic.config(config)

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = 'Diagnostic: prev'})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = 'Diagnostic: next'})
vim.keymap.set('n', '\\\\', vim.diagnostic.setloclist, {desc = 'Diagnostic: show loclist'})
vim.keymap.set('n', '\\f', function() vim.diagnostic.open_float(nil, {border = 'rounded'}) end,
    {desc = 'Diagnostic: show floating'})
