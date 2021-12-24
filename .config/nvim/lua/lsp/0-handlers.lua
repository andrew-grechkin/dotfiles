local function export_buffer_keymaps(bufnr)
    local opts = {noremap = true, silent = true}
    local map = vim.api.nvim_buf_set_keymap

    map(bufnr, 'n', '<C-h>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- map(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- map(bufnr, 'n', 'gl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- map(bufnr, 'n', '<leader>f', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    -- map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]
end

local M = {}

local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if status_ok then
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

M.setup = function()
    local signs = {
        {name = 'DiagnosticSignError', text = ''},
        {name = 'DiagnosticSignWarn', text = ''},
        {name = 'DiagnosticSignHint', text = ''},
        {name = 'DiagnosticSignInfo', text = ''},
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name,
                           {texthl = sign.name, text = sign.text, numhl = ''})
    end

    local config = {
        float = {
            focusable = false,
            header = '',
            prefix = '',
            source = 'always',
            style = 'minimal',
        },
        severity_sort = true,
        signs = {active = signs},
        underline = true,
        update_in_insert = true,
        virtual_text = true,
    }

    vim.diagnostic.config(config)
end

M.on_attach = function(client, bufnr)
    -- if client.name == 'tsserver' then
    --     client.resolved_capabilities.document_formatting = false
    -- end
    export_buffer_keymaps(bufnr)
end

return M
