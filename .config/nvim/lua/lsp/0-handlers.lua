local function export_buffer_keymaps(_client, bufnr)
    local ok, which_key = pcall(require, 'which-key')
    if (not ok) then return end

    local normal_mappings = {
        ['[d'] = {':lua vim.diagnostic.goto_prev()<CR>', 'LSP: diagnostic prev'},
        [']d'] = {':lua vim.diagnostic.goto_next()<CR>', 'LSP: diagnostic next'},
        ['<A-h>'] = {':lua vim.lsp.buf.hover()<CR>', 'LSP: hover'},
        ['<A-k>'] = {
            ':lua vim.lsp.buf.signature_help()<CR>', 'LSP: signature help',
        },
        ['\\'] = {
            name = 'LSP',
            D = {':lua vim.lsp.buf.declaration()', 'goto: declaration'},
            a = {':lua vim.lsp.buf.code_action()<CR>', 'code action'},
            d = {':lua vim.lsp.buf.definition()<CR>', 'goto: definition'},
            f = {':lua vim.diagnostic.open_float()<CR>', 'open float'},
            i = {
                ':lua vim.lsp.buf.implementation()<CR>', 'goto: implementation',
            },
            l = {':lua vim.diagnostic.setloclist()<CR>', 'show diagnostic'},
            n = {':lua vim.lsp.buf.rename()<CR>', 'rename'},
            q = {':lua vim.lsp.buf.formatting()<CR>', 'format'},
            r = {':lua vim.lsp.buf.references()<CR>', 'goto: references'},
            t = {
                ':lua vim.lsp.buf.type_definition()<CR>',
                'goto: type definition',
            },
        },
    }

    which_key.register(normal_mappings, {bufer = bufnr})
    -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]
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
        {name = 'DiagnosticSignHint', text = ''},
        {name = 'DiagnosticSignInfo', text = ''},
        {name = 'DiagnosticSignWarn', text = ''},
    }

    for _, sign in ipairs(signs) do
        local value = {texthl = sign.name, text = sign.text, numhl = ''}
        vim.fn.sign_define(sign.name, value)
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
    export_buffer_keymaps(client, bufnr)
end

return M
