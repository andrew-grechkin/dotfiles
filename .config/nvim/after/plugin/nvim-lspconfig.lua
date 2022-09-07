local status_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not status_lspconfig then return end

local status, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not status then return end
lsp_installer.setup {}

local function on_attach(_client, bufnr)
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
            ['\\'] = {':lua vim.diagnostic.setloclist()<CR>', 'show diagnostic'},
            D = {':lua vim.lsp.buf.declaration()', 'goto: declaration'},
            a = {':lua vim.lsp.buf.code_action()<CR>', 'code action'},
            d = {':lua vim.lsp.buf.definition()<CR>', 'goto: definition'},
            f = {':lua vim.diagnostic.open_float()<CR>', 'open float'},
            i = {
                ':lua vim.lsp.buf.implementation()<CR>', 'goto: implementation',
            },
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

local servers = lsp_installer.get_installed_servers()
for _, server in ipairs(servers) do
    -- vim.notify(vim.inspect(server))
    local opts = {on_attach = on_attach}
    local req_name = string.format('lsp.settings-%s', server.name)
    local ok, settings = pcall(require, req_name)
    if ok then opts = vim.tbl_deep_extend('force', settings, opts) end

    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    -- vim.notify(vim.inspect(opts))
    lspconfig[server.name].setup(opts)
end

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
