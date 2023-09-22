return {
    { -- https://github.com/williamboman/mason.nvim
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            'jay-babu/mason-nvim-dap.nvim',
        },
        config = function()
            local ok, plugin = pcall(require, 'mason')
            if not ok then return end

            plugin.setup({})

            local function on_attach(_, bufnr)
                local wk_ok, which_key = pcall(require, 'which-key')
                if not wk_ok then return end

                -- h: lsp-buf
                local normal_mappings = {
                    ['<leader>'] = {
                        ['k'] = {vim.lsp.buf.signature_help, 'LSP: signature help'},
                        ['l'] = {
                            name = 'LSP',
                            I = {'<cmd>LspInfo<CR>', 'Info'},
                            S = {
                                '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',
                                'symbols: workspace',
                            },
                            c = {'<cmd>Telescope lsp_incoming_calls<CR>', 'calls: incoming'},
                            d = {'<cmd>Telescope lsp_definitions<CR>', 'definitions'},
                            h = {vim.lsp.buf.hover, 'LSP: hover'},
                            i = {'<cmd>Telescope lsp_implementations<CR>', 'implementations'},
                            o = {'<cmd>Telescope lsp_outgoing_calls<CR>', 'calls: outgoing'},
                            r = {'<cmd>Telescope lsp_references<CR>', 'references'},
                            s = {'<cmd>Telescope lsp_document_symbols<CR>', 'document symbols'},
                            t = {'<cmd>Telescope lsp_type_definitions<CR>', 'type definitions'},
                            w = {
                                '<cmd>Telescope lsp_workspace_diagnostics<CR>',
                                'diagnostics: workspace',
                            },
                        },
                    },
                    ['['] = {['d'] = {vim.diagnostic.goto_prev, 'LSP: prev diagnostic'}},
                    [']'] = {['d'] = {vim.diagnostic.goto_next, 'LSP: next diagnostic'}},
                    ['\\'] = {
                        name = 'LSP',
                        ['\\'] = {vim.diagnostic.setloclist, 'show diagnostic'},
                        a = {vim.lsp.buf.code_action, 'code action'},
                        f = {vim.diagnostic.open_float, 'open diagnostic in floating window'},
                        i = {vim.lsp.buf.implementation, 'goto: implementation'},
                        q = {vim.lsp.buf.format, 'format'},
                        r = {vim.lsp.buf.rename, 'rename'},
                        t = {vim.lsp.buf.type_definition, 'goto: type definition'},
                    },
                    ['g'] = {
                        D = {vim.lsp.buf.declaration, 'goto: declaration'},
                        d = {vim.lsp.buf.definition, 'goto: definition'},
                        r = {vim.lsp.buf.references, 'goto: references'},
                    },
                }

                which_key.register(normal_mappings, {bufer = bufnr, noremap = true})
                -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]
            end

            local mason_lspconfig = require('mason-lspconfig')
            local ensure_installed = {'bashls', 'jsonls', 'perlnavigator', 'puppet', 'yamlls'}
            if not IS_KVM then
                ensure_installed = {
                    'ansiblels',
                    'awk_ls',
                    'bashls',
                    'clangd',
                    'cmake',
                    'docker_compose_language_service',
                    'dockerls',
                    'eslint',
                    'flux_lsp',
                    'graphql',
                    'helm_ls',
                    'jqls',
                    'jsonls',
                    'lua_ls',
                    'marksman',
                    'perlnavigator',
                    'pkgbuild_language_server',
                    'puppet',
                    'pyright',
                    'sqlls',
                    'stylelint_lsp',
                    'tsserver',
                    'vimls',
                    'yamlls',
                }
            end
            mason_lspconfig.setup {
                ensure_installed = ensure_installed,
                automatic_installation = true,
            }

            local lsp_ok, lspconfig = pcall(require, 'lspconfig')
            if not lsp_ok then return end

            mason_lspconfig.setup_handlers {

                function(server_name)
                    -- vim.notify(vim.inspect(server_name))
                    local opts = {on_attach = on_attach}
                    local lsp_set_ok, settings = pcall(require, string.format('lsp.settings-%s', server_name))
                    if lsp_set_ok then opts = vim.tbl_deep_extend('force', settings, opts) end

                    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
                    lspconfig[server_name].setup(opts)
                end,
            }

            local table = require('table')
            local mason_tool = require('mason-tool-installer')
            -- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
            -- table.unpack = table.unpack or unpack
            local lsps = {'bash-language-server', 'bzl'}
            local daps = {}
            local linters = {'jsonlint', 'yamllint'}
            local formatters = {'beautysh', 'fixjson', 'shfmt', 'yamlfix'}
            if not IS_KVM then
                lsps = {'bash-language-server', 'bzl', 'lua-language-server', 'vim-language-server'}
                daps = {'perl-debug-adapter'}
                linters = {
                    'actionlint',
                    'ansible-lint',
                    'cmakelang',
                    'cmakelint',
                    'jsonlint',
                    'luacheck',
                    'markdownlint',
                    'markuplint',
                    'proselint',
                    'stylelint',
                    'vint',
                    'yamllint',
                }
                formatters = {
                    'beautysh',
                    'cmakelang',
                    'doctoc',
                    'fixjson',
                    'gersemi',
                    'luaformatter',
                    'shellharden',
                    'shfmt',
                    'sql-formatter',
                    'sqlfmt',
                    'yamlfix',
                }
            end
            local ensure_installed2 = {}
			for i, v in ipairs(lsps) do table.insert(ensure_installed2, v) end
			for i, v in ipairs(daps) do table.insert(ensure_installed2, v) end
			for i, v in ipairs(linters) do table.insert(ensure_installed2, v) end
			for i, v in ipairs(formatters) do table.insert(ensure_installed2, v) end
            mason_tool.setup {
                ensure_installed = ensure_installed2,
                auto_update = true,
                run_on_start = true,
                start_delay = 3000,
                debounce_hours = 1, -- at least 1 hours between attempts to install/update
            }
            -- setup pre-install and post-install hook
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MasonToolsStartingInstall',
                callback = function()
                    vim.schedule(function() print 'mason-tool-installer is starting' end)
                end,
            })
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MasonToolsUpdateCompleted',
                callback = function(e)
                    vim.schedule(function()
                        if next(e.data) ~= nil then
                            print 'mason-tool-installer finished'
                            print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
                        end
                    end)
                end,
            })

            local mason_nvim_dap = require('mason-nvim-dap')
            local ensure_installed = {'bash-debug-adapter', 'perl-debug-adapter'}
            if not IS_KVM then ensure_installed = {
                'bash-debug-adapter',
                'perl-debug-adapter',
                'python',
            } end
            mason_nvim_dap.setup {
                automatic_installation = true,
                ensure_installed = ensure_installed,
                handlers = {},
            }
        end,
    },
}
