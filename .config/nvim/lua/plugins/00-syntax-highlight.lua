return {
    { -- https://github.com/nvim-treesitter/nvim-treesitter
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            { -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
                'nvim-treesitter/nvim-treesitter-textobjects',
            },
            { -- https://github.com/nvim-treesitter/playground
                'nvim-treesitter/playground',
            },
        },
        -- build = ':TSUpdate',
        config = function()
            local ok, plugin = pcall(require, 'nvim-treesitter.configs')
            if not ok then return end

            local ensure_installed = {
                'bash',
                'dockerfile',
                'gitignore',
                'json',
                'lua',
                'make',
                'regex',
                'toml',
                'vim',
                'vimdoc',
                'yaml',
            }

            if not IS_KVM then
                ensure_installed = {
                    'bash',
                    'c',
                    'cmake',
                    'cpp',
                    'css',
                    'dockerfile',
                    'elixir',
                    'gitignore',
                    'go',
                    'html',
                    'http',
                    'javascript',
                    'json',
                    'lua',
                    'make',
                    'markdown',
                    'markdown_inline',
                    'python',
                    'query',
                    'regex',
                    'ruby',
                    'scss',
                    'sql',
                    'toml',
                    'tsx',
                    'typescript',
                    'vim',
                    'vimdoc',
                    'vue',
                    'yaml',
                }
            end
            local config = {
                ensure_installed = ensure_installed,
                highlight = {enable = true, disable = {}},
                indent = {enable = false, disable = {}},
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '[[',
                        node_incremental = '[[',
                        scope_incremental = '<c-s>',
                        node_decremental = ']]',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {[']f'] = '@function.outer', [']o'] = '@class.outer'},
                        goto_next_end = {[']F'] = '@function.outer', [']O'] = '@class.outer'},
                        goto_previous_start = {['[f'] = '@function.outer', ['[o'] = '@class.outer'},
                        goto_previous_end = {['[F'] = '@function.outer', ['[O'] = '@class.outer'},
                    },
                    -- swap = {
                    --     enable = true,
                    --     swap_next = {['<leader>a'] = '@parameter.inner'},
                    --     swap_previous = {['<leader>A'] = '@parameter.inner'},
                    -- },
                },
            }

            plugin.setup(config)
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- Automatically highlights other instances of the word under your cursor.
    -- This works with LSP, Treesitter, and regexp matching to find the other instances.
    { -- https://github.com/RRethy/vim-illuminate
        'RRethy/vim-illuminate',
        event = {'BufReadPost', 'BufNewFile'},
        opts = {delay = 200, large_file_cutoff = 2000, large_file_overrides = {providers = {'lsp'}}},
        config = function(_, opts)
            local plugin = require('illuminate')
            plugin.configure(opts)

            -- local function map(key, dir, buffer)
            --     vim.keymap.set('n', key, function()
            --         plugin['goto_' .. dir .. '_reference'](false)
            --     end, {desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' reference', buffer = buffer})
            -- end

            -- map(']r', 'next')
            -- map('[r', 'prev')

            -- -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            -- vim.api.nvim_create_autocmd('FileType', {
            --     callback = function()
            --         local buffer = vim.api.nvim_get_current_buf()
            --         map(']r', 'next', buffer)
            --         map('[r', 'prev', buffer)
            --     end,
            -- })

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['['] = {
                        ['r'] = {
                            function() plugin.goto_prev_reference(false) end,
                            'TreeSitter: prev reference',
                        },
                    },
                    [']'] = {
                        ['r'] = {
                            function() plugin.goto_next_reference(false) end,
                            'TreeSitter: next reference',
                        },
                    },
                }

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
}
