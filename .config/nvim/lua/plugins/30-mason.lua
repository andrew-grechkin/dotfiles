return {
    { -- https://github.com/williamboman/mason.nvim
        'williamboman/mason.nvim',
        cmd = {'Mason'},
        opts = {},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {'williamboman/mason.nvim'},
        cmd = {'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean'},
        config = function()
            local plugin = require('mason-tool-installer')
            -- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
            -- table.unpack = table.unpack or unpack

            local lsps = T {}
            local daps = T {}
            local linters = T {'jsonlint', 'shellcheck', 'yamllint'}
            local formatters = T {'beautysh', 'fixjson', 'shfmt', 'yamlfix'}
            if not IS_KVM then
                lsps:append{
                    'ansible-language-server',
                    -- 'bzl',
                    -- 'clangd',
                    -- 'cmake-language-server',
                    'docker-compose-language-service',
                    'dockerfile-language-server',
                    'eslint-lsp',
                    -- 'flux-lsp',
                    -- 'graphql-language-service-cli',
                    'helm-ls',
                    'jq-lsp',
                    'lua-language-server',
                    'marksman',
                    -- 'pkgbuild-language-server',
                    -- 'puppet-editor-services',
                    'pyright',
                    'sqlls',
                    'stylelint-lsp',
                    'typescript-language-server',
                    'vim-language-server',
                }
                daps:append{'perl-debug-adapter'}
                linters:append{
                    -- 'actionlint',
                    'ansible-lint',
                    -- 'cmakelang',
                    -- 'cmakelint',
                    'luacheck',
                    'markdownlint',
                    'markuplint',
                    'proselint',
                    'sqlfluff',
                    'stylelint',
                    'vint',
                }
                formatters:append{
                    -- 'cmakelang',
                    'doctoc',
                    -- 'gersemi',
                    'luaformatter',
                    'shellharden',
                }
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
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/jay-babu/mason-nvim-dap.nvim
        'jay-babu/mason-nvim-dap.nvim',
        lazy = true,
        dependencies = {'williamboman/mason.nvim'},
        config = function()
            local plugin = require('mason-nvim-dap')
            local ensure_installed = {'bash', 'python'}

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
