return {
    { -- https://github.com/williamboman/mason.nvim
        'williamboman/mason.nvim',
        opts = {},
    },
    { -- https://github.com/williamboman/mason-lspconfig.nvim
        'williamboman/mason-lspconfig.nvim',
        dependencies = {'williamboman/mason.nvim'},
        config = function()
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

            local plugin = require('mason-lspconfig')
            plugin.setup {ensure_installed = ensure_installed, automatic_installation = true}

            local function on_attach(data, bufnr)
                -- data.config.capabilities = nil
                -- print('attached', vim.inspect(data.config))
                if data.config.set_on_attach then data.config.set_on_attach(data, bufnr) end
            end

            -- LSP settings (for overriding per client)
            local handlers = {
                ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'}),
                ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = 'rounded',
                }),
            }

            local lspconfig = require('lspconfig')
            plugin.setup_handlers {
                function(server_name)
                    -- vim.notify(vim.inspect(server_name))
                    local opts = {on_attach = on_attach, handlers = handlers}
                    local lsp_set_ok, settings = pcall(require, string.format('lsp.settings-%s', server_name))
                    if lsp_set_ok then
                        if settings.set_prepare then settings.set_prepare(server_name, settings) end
                        opts = vim.tbl_deep_extend('force', settings, opts)
                    end

                    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
                    lspconfig[server_name].setup(opts)
                end,
            }
        end,
    },
    { -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {'williamboman/mason.nvim'},
        config = function()
            local table = require('table')
            local plugin = require('mason-tool-installer')
            -- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
            -- table.unpack = table.unpack or unpack

            local lsps = {'bash-language-server', 'bzl'}
            local daps = {'perl-debug-adapter'}
            local linters = {'jsonlint', 'shellcheck', 'yamllint'}
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
                    'shellcheck',
                    'sqlfluff',
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
                    'yamlfix',
                }
            end

            local ensure_installed2 = {}
            for _, v in ipairs(lsps) do table.insert(ensure_installed2, v) end
            for _, v in ipairs(daps) do table.insert(ensure_installed2, v) end
            for _, v in ipairs(linters) do table.insert(ensure_installed2, v) end
            for _, v in ipairs(formatters) do table.insert(ensure_installed2, v) end

            -- NOTIFY_REC = {id = nil}
            -- -- setup pre-install and post-install hook
            -- vim.api.nvim_create_autocmd('User', {
            --     pattern = 'MasonToolsStartingInstall',
            --     callback = function()
            --         vim.schedule(function()
            --             NOTIFY_REC = vim.notify('mason-tool-installer is starting', 'INFO',
            --                 {title = 'Mason tools', replace = NOTIFY_REC.id})
            --         end)
            --     end,
            -- })
            -- vim.api.nvim_create_autocmd('User', {
            --     pattern = 'MasonToolsUpdateCompleted',
            --     callback = function(e)
            --         vim.schedule(function()
            --             if next(e.data) ~= nil then
            --                 vim.notify('mason-tool-installer finished')
            --                 vim.notify(vim.inspect(e.data))
            --             end
            --         end)
            --     end,
            -- })

            plugin.setup {
                auto_update = true,
                debounce_hours = 1, -- at least 1 hours between attempts to install/update
                ensure_installed = ensure_installed2,
                run_on_start = true,
                start_delay = 3000,
            }
        end,
    },
    { -- https://github.com/jay-babu/mason-nvim-dap.nvim
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {'williamboman/mason.nvim'},
        config = function()
            local plugin = require('mason-nvim-dap')
            local ensure_installed = {'bash', 'python'}
            -- if not IS_KVM then ensure_installed = {'bash', 'python'} end

            plugin.setup {
                automatic_installation = true,
                ensure_installed = ensure_installed,
                handlers = {
                    function(config)
                        -- print(vim.inspect(config))
                        -- all sources with no handler get passed here
                        -- Keep original functionality
                        plugin.default_setup(config)
                    end,
                },
            }
        end,
    },
}
