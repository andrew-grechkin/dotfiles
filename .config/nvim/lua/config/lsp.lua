vim.lsp.inlay_hint.enable(true)

vim.keymap.set('n', '<leader>K', function() -- run this twice to enter the window
    vim.lsp.buf.hover()
    vim.lsp.buf.hover()
end, {desc = 'LSP: hover'})
vim.keymap.set('n', '<leader>k', function() -- run this twice to enter the window
    vim.lsp.buf.signature_help()
    vim.lsp.buf.signature_help()
end, {desc = 'LSP: signature'})

vim.keymap.set('n', '\\a', vim.lsp.buf.code_action, {desc = 'LSP: code action'})
vim.keymap.set('n', '\\c', '<cmd>lua =vim.lsp.get_active_clients()[1].server_capabilities<CR>',
    {desc = 'LSP: capabilities'})
vim.keymap.set({'n', 'v'}, '\\q', function()
    vim.lsp.buf.format({
        formatting_options = {
            insertSpaces = true,
            trimFinalNewlines = true,
            trimTrailingWhitespace = true,
            insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
            insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
            insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
        },
        async = false,
    })
end, {desc = 'LSP: format'})
vim.keymap.set('n', '\\r', vim.lsp.buf.rename, {desc = 'LSP: rename'})

vim.keymap.set('n', '\\wa', vim.lsp.buf.add_workspace_folder, {desc = 'LSP: workspace add dir'})
vim.keymap.set('n', '\\wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    {desc = 'LSP: workspace list dirs'})
vim.keymap.set('n', '\\wr', vim.lsp.buf.remove_workspace_folder, {
    desc = 'LSP: workspace remove dir',
})
