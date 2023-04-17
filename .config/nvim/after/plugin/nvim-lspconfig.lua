local status_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not status_lspconfig then return end

local function on_attach(_, bufnr)
    local ok, which_key = pcall(require, 'which-key')
    if not ok then return end

    local normal_mappings = {
        ['<leader>'] = {
            ['h'] = {vim.lsp.buf.hover, 'LSP: hover'},
            ['k'] = {vim.lsp.buf.signature_help, 'LSP: signature help'},
        },
        ['[d'] = {vim.diagnostic.goto_pre, 'LSP: diagnostic prev'},
        [']d'] = {vim.diagnostic.goto_next, 'LSP: diagnostic next'},
        ['\\'] = {
            name = 'LSP',
            ['\\'] = {vim.diagnostic.setloclist, 'show diagnostic'},
            a = {vim.lsp.buf.code_action, 'code action'},
            f = {vim.diagnostic.open_float, 'open float'},
            i = {vim.lsp.buf.implementation, 'goto: implementation'},
            n = {vim.lsp.buf.rename, 'rename'},
            q = {vim.lsp.buf.formatting, 'format'},
            r = {vim.lsp.buf.references, 'goto: references'},
            t = {vim.lsp.buf.type_definition, 'goto: type definition'},
        },
        g = {
            D = {vim.lsp.buf.declaration, 'goto: declaration'},
            d = {vim.lsp.buf.definition, 'goto: definition'},
        },
    }

    which_key.register(normal_mappings, {bufer = bufnr})
    -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]
end

-- => ------------------------------------------------------------------------------------------------------------- {{{1

local status, mason = pcall(require, 'mason')
if status then
    mason.setup {}

    local config = require('mason-lspconfig')
    config.setup {
        ensure_installed = {
            'ansiblels', 'bashls', 'clangd', 'cmake', 'dockerls', 'lua_ls', 'marksman',
            'perlnavigator', 'puppet', 'pyright', 'sqlls', 'tsserver',
        },
        -- 'flux_lsp',
        automatic_installation = true,
    }
    config.setup_handlers {
        function(server_name)
            -- vim.notify(vim.inspect(server_name))
            local opts = {on_attach = on_attach}
            local ok, settings = pcall(require, string.format('lsp.settings-%s', server_name))
            if ok then opts = vim.tbl_deep_extend('force', settings, opts) end

            -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            lspconfig[server_name].setup(opts)
        end,
    }
end

-- => ------------------------------------------------------------------------------------------------------------- {{{1

local signs = {
    {name = 'DiagnosticSignError', text = ''}, {name = 'DiagnosticSignHint', text = ''},
    {name = 'DiagnosticSignInfo', text = ''}, {name = 'DiagnosticSignWarn', text = ''},
}

for _, sign in ipairs(signs) do
    local value = {texthl = sign.name, text = sign.text, numhl = ''}
    vim.fn.sign_define(sign.name, value)
end

local config = {
    float = {source = true},
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    virtual_text = {source = 'if_many'},
}

vim.diagnostic.config(config)
