-- => h: lsp ------------------------------------------------------------------------------------------------------ {{{1
local status_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not status_lspconfig then return end

local function on_attach(_, bufnr)
    local ok, which_key = pcall(require, 'which-key')
    if not ok then return end

    local normal_mappings = {
        ['<leader>'] = {
            ['h'] = {vim.lsp.buf.hover, 'LSP: hover'},
            ['k'] = {vim.lsp.buf.signature_help, 'LSP: signature help'},
            ['l'] = {
                name = 'LSP',
                I = {'<cmd>LspInfo<CR>', 'Info'},
                S = {'<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', 'symbols: workspace'},
                c = {'<cmd>Telescope lsp_incoming_calls<CR>', 'calls: incoming'},
                d = {'<cmd>Telescope lsp_definitions<CR>', 'definitions'},
                i = {'<cmd>Telescope lsp_implementations<CR>', 'implementations'},
                o = {'<cmd>Telescope lsp_outgoing_calls<CR>', 'calls: outgoing'},
                r = {'<cmd>Telescope lsp_references<CR>', 'references'},
                s = {'<cmd>Telescope lsp_document_symbols<CR>', 'document symbols'},
                t = {'<cmd>Telescope lsp_type_definitions<CR>', 'type definitions'},
                w = {'<cmd>Telescope lsp_workspace_diagnostics<CR>', 'diagnostics: workspace'},
            },
        },
        ['[d'] = {vim.diagnostic.goto_prev, 'LSP: diagnostic prev'},
        [']d'] = {vim.diagnostic.goto_next, 'LSP: diagnostic next'},
        ['\\'] = {
            name = 'LSP',
            ['\\'] = {vim.diagnostic.setloclist, 'show diagnostic'},
            a = {vim.lsp.buf.code_action, 'code action'},
            f = {vim.diagnostic.open_float, 'open diagnostic in floating window'},
            i = {vim.lsp.buf.implementation, 'goto: implementation'},
            n = {vim.lsp.buf.rename, 'rename'},
            q = {vim.lsp.buf.format, 'format'},
            r = {vim.lsp.buf.references, 'goto: references'},
            t = {vim.lsp.buf.type_definition, 'goto: type definition'},
        },
        ['g'] = {
            D = {vim.lsp.buf.declaration, 'goto: declaration'},
            d = {vim.lsp.buf.definition, 'goto: definition'},
        },
    }

    which_key.register(normal_mappings, {bufer = bufnr})
    -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]
end

-- => h: vim.diagnostic.config ------------------------------------------------------------------------------------ {{{1

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
    update_in_insert = false,
    virtual_text = {source = true},
}

vim.diagnostic.config(config)

-- => ------------------------------------------------------------------------------------------------------------- {{{1

local status, mason = pcall(require, 'mason')
if status then
    mason.setup {}

    local mason_lspconfig = require('mason-lspconfig')
    mason_lspconfig.setup {
        ensure_installed = {
            'ansiblels', 'awk_ls', 'bashls', 'clangd', 'cmake', 'docker_compose_language_service',
            'dockerls', 'eslint', -- 'flux_lsp',
            'graphql', 'helm_ls', 'jqls', 'jsonls', 'lua_ls', 'marksman', 'perlnavigator',
            'pkgbuild_language_server', 'puppet', 'pyright', 'sqlls', 'stylelint_lsp', 'tsserver',
            'vimls', 'yamlls',
        },
        automatic_installation = true,
    }
    mason_lspconfig.setup_handlers {
        function(server_name)
            -- vim.notify(vim.inspect(server_name))
            local opts = {on_attach = on_attach}
            local ok, settings = pcall(require, string.format('lsp.settings-%s', server_name))
            if ok then opts = vim.tbl_deep_extend('force', settings, opts) end

            -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            lspconfig[server_name].setup(opts)
        end,
    }

    local table = require('table')
    local mason_tool = require('mason-tool-installer')
    -- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
    table.unpack = table.unpack or unpack
    local lsps = {'bash-language-server', 'bzl', 'lua-language-server', 'vim-language-server'}
    local daps = {'perl-debug-adapter'}
    local linters = {
        'actionlint', 'ansible-lint', 'cmakelang', 'cmakelint', 'commitlint', 'jsonlint',
        'luacheck', 'markdownlint', 'markuplint', 'proselint', 'stylelint', 'vint', 'yamllint',
    }
    local formatters = {
        'beautysh', 'cmakelang', 'doctoc', 'fixjson', 'gersemi', -- 'luaformatter',
        'markdown-toc', 'mdformat', 'shellharden', 'shfmt', 'sql-formatter', 'sqlfmt', 'yamlfix',
    }
    mason_tool.setup {
        ensure_installed = {
            table.unpack(lsps), table.unpack(daps), table.unpack(linters), table.unpack(formatters),
        },
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 5, -- at least 5 hours between attempts to install/update
    }
    -- setup pre-install and post-install hook
    vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsStartingInstall',
        callback = function() vim.schedule(function() print 'mason-tool-installer is starting' end) end,
    })
    vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsUpdateCompleted',
        callback = function(e)
            vim.schedule(function()
                print 'mason-tool-installer finished'
                print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
            end)
        end,
    })

    local mason_nvim_dap = require('mason-nvim-dap')
    mason_nvim_dap.setup {
        automatic_installation = true,
        ensure_installed = {'bash-debug-adapter', 'perl-debug-adapter', 'python'},
        handlers = {},
    }
end
