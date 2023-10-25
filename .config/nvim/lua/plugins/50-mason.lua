return {
    { -- https://github.com/williamboman/mason.nvim
        'williamboman/mason.nvim',
        opts = {},
    },
    { -- https://github.com/williamboman/mason-lspconfig.nvim
        'williamboman/mason-lspconfig.nvim',
        dependencies = {'williamboman/mason.nvim'},
        config = function()
            local ensure_installed = T {'bashls', 'jsonls', 'perlnavigator', 'yamlls'}
            if not IS_KVM then
                ensure_installed:append{
                    'ansiblels',
                    'awk_ls',
                    'clangd',
                    'cmake',
                    'docker_compose_language_service',
                    'dockerls',
                    'eslint',
                    'flux_lsp',
                    'graphql',
                    'helm_ls',
                    'jqls',
                    'lua_ls',
                    'marksman',
                    'pkgbuild_language_server',
                    'puppet',
                    'pyright',
                    'sqlls',
                    'stylelint_lsp',
                    'tsserver',
                    'vimls',
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

            local lsps = T {'bash-language-server'}
            local daps = T {}
            local linters = T {'jsonlint', 'shellcheck', 'yamllint'}
            local formatters = T {'beautysh', 'fixjson', 'shfmt', 'yamlfix'}
            if not IS_KVM then
                lsps:append{'bzl', 'lua-language-server', 'vim-language-server'}
                daps:append{'perl-debug-adapter'}
                linters:append{
                    'actionlint',
                    'ansible-lint',
                    'cmakelang',
                    'cmakelint',
                    'luacheck',
                    'markdownlint',
                    'markuplint',
                    'proselint',
                    'sqlfluff',
                    'stylelint',
                    'vint',
                }
                formatters:append{'cmakelang', 'doctoc', 'gersemi', 'luaformatter', 'shellharden'}
            end

            local ensure_installed = T {}
            ensure_installed:append(lsps)
            ensure_installed:append(daps)
            ensure_installed:append(linters)
            ensure_installed:append(formatters)
            ensure_installed:sort()

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
                auto_update = false,
                -- debounce_hours = 1, -- at least 1 hours between attempts to install/update
                ensure_installed = ensure_installed,
                run_on_start = false,
                -- start_delay = 3000,
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
