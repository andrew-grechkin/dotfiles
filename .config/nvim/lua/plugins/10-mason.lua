return {
    { -- https://github.com/mason-org/mason-lspconfig.nvim
        'mason-org/mason-lspconfig.nvim',
        opts = {ensure_installed = {'bashls', 'jsonls', 'perlnavigator', 'yamlls'}},
        dependencies = {
            { -- https://github.com/mason-org/mason.nvim
                'mason-org/mason.nvim',
                -- opts = {}
                cmd = {'Mason'},
                opts = {install_root_dir = vim.fs.joinpath(vim.fn.stdpath('cache'), 'mason')},
            },
            { -- https://github.com/neovim/nvim-lspconfig
                'neovim/nvim-lspconfig',
                config = function()
                    -- vim.lsp.set_log_level('debug')

                    -- => default commands -------------------------------------------------------------------------------- {{{1

                    -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]

                    -- => default keybindings ----------------------------------------------------------------------------- {{{1

                    -- vim.notify('init lsp', 'INFO')
                    vim.lsp.config('denols', {filetypes = {'deno', 'typescript.deno'}})

                    local wk_ok, which_key = pcall(require, 'which-key')
                    if not wk_ok then return end

                    -- h: lsp-buf

                    vim.api.nvim_create_autocmd('LspAttach', {
                        group = vim.api.nvim_create_augroup('UserLspConfig', {clear = true}),
                        callback = function(ev)
                            -- Enable completion triggered by <c-x><c-o>
                            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                            -- See `:help vim.lsp.*` for documentation on any of the below functions
                            which_key.add({
                                noremap = true,
                                {'<leader>l', group = 'LSP'},
                                {'<leader>li', '<cmd>LspInfo<CR>', desc = 'Info'},
                                {
                                    '<leader>ll',
                                    '<cmd>Telescope lsp_document_symbols<CR>',
                                    desc = 'symbols',
                                },

                                {'<leader>lc', group = 'calls'},
                                {
                                    '<leader>lci',
                                    '<cmd>Telescope lsp_incoming_calls<CR>',
                                    desc = 'incoming',
                                },
                                {
                                    '<leader>lco',
                                    '<cmd>Telescope lsp_outgoing_calls<CR>',
                                    desc = 'outgoing',
                                },

                                {'<leader>ls', group = 'symbols'},
                                {
                                    '<leader>lsd',
                                    '<cmd>Telescope lsp_document_symbols<CR>',
                                    desc = 'document',
                                },
                                {
                                    '<leader>lsw',
                                    '<cmd>Telescope lsp_workspace_symbols<CR>',
                                    desc = 'workspace',
                                },
                                {
                                    '<leader>lsy',
                                    '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',
                                    desc = 'dynamic workspace',
                                },

                                {
                                    'gD',
                                    '<cmd>FzfLua lsp_declarations<CR>',
                                    desc = 'goto: declaration',
                                },
                                -- I = {vim.lsp.buf.implementation, 'goto: implementation'},
                                {
                                    'gI',
                                    '<cmd>FzfLua lsp_implementations<CR>',
                                    desc = 'goto: implementation',
                                },
                                -- d = {vim.lsp.buf.definition, 'goto: definition'},
                                {'gd', '<cmd>FzfLua lsp_definitions<CR>', desc = 'goto: definition'},
                                -- r = {vim.lsp.buf.references, 'goto: references'},
                                {'gr', '<cmd>FzfLua lsp_references<CR>', desc = 'goto: references'},
                                -- y = {vim.lsp.buf.type_definition, 'goto: type definition'},
                                {
                                    'gy',
                                    '<cmd>FzfLua lsp_typedefs<CR>',
                                    desc = 'goto: type definition',
                                },
                            }, {bufer = ev.buf})
                        end,
                    })
                end,
                dependencies = {
                    -- { -- https://github.com/j-hui/fidget.nvim
                    --     'j-hui/fidget.nvim',
                    --     tag = 'legacy',
                    --     opts = {},
                    -- },
                    { -- https://github.com/folke/neoconf.nvim
                        'folke/neoconf.nvim',
                        opts = {},
                    },
                },
                event = {'BufReadPost', 'BufNewFile'},
            },
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        cmd = {'MasonToolsClean', 'MasonToolsUpdate'},
        config = function()
            local plugin = require('mason-tool-installer')
            -- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
            -- table.unpack = table.unpack or unpack

            local lsps = T {
                'bash-language-server',
                'json-lsp',
                'perlnavigator',
                'yaml-language-server',
            }
            local daps = T {'bash-debug-adapter', 'debugpy'}
            local linters = T {'jsonlint', 'shellcheck', 'yamllint'}
            local formatters = T {'beautysh', 'fixjson', 'yamlfix'}

            if not IS_KVM then
                if IS_WORK then lsps:append{'gitlab-ci-ls'} end
                lsps:append{
                    -- 'ansible-language-server',
                    -- 'autotools-language-server',
                    'basedpyright',
                    -- 'bzl',
                    -- 'clangd',
                    -- 'cmake-language-server',
                    'docker-compose-language-service',
                    'dockerfile-language-server',
                    'eslint-lsp',
                    -- 'flux-lsp',
                    -- 'graphql-language-service-cli',
                    -- 'helm-ls',
                    'jq-lsp',
                    'lua-language-server',
                    -- 'marksman',
                    -- 'pkgbuild-language-server',
                    -- 'puppet-editor-services',
                    -- 'pyright',
                    'sqlls',
                    -- 'stylelint-lsp',
                    'typescript-language-server',
                    'vim-language-server',
                }
                daps:append{'perl-debug-adapter'}
                linters:append{
                    -- 'actionlint',
                    -- 'ansible-lint',
                    -- 'cmakelang',
                    -- 'cmakelint',
                    -- 'eslint_d',
                    'luacheck',
                    -- 'markdownlint',
                    -- 'markuplint',
                    -- 'proselint',
                    'sqlfluff',
                    -- 'stylelint',
                    'vint',
                }
                formatters:append{
                    -- 'cmakelang',
                    'darker',
                    -- 'doctoc',
                    -- 'gersemi',
                    'luaformatter',
                    'shellharden',
                    -- 'shfmt',
                }
            end

            local ensure_installed = T {}
            ensure_installed:append(lsps)
            -- ensure_installed:append(daps)
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
        dependencies = {'williamboman/mason.nvim'},
    },
}
