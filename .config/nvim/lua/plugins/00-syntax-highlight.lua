return {
    { -- https://github.com/nvim-treesitter/nvim-treesitter
        'nvim-treesitter/nvim-treesitter',
        enabled = true,
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

            local ensure_installed = T {
                'bash',
                'diff',
                'dockerfile',
                'git_rebase',
                'gitcommit',
                'gitignore',
                'json',
                'jsonc',
                'lua',
                'make',
                'regex',
                'toml',
                'yaml',
            }

            if not IS_KVM then
                ensure_installed:append({
                    'c',
                    'cmake',
                    'comment',
                    'cpp',
                    'css',
                    'csv',
                    'doxygen',
                    'elixir',
                    'git_config',
                    'gitattributes',
                    'go',
                    'gpg',
                    'graphql',
                    'html',
                    'http',
                    'ini',
                    'javascript',
                    'jq',
                    'jsdoc',
                    'json5',
                    'luadoc',
                    'markdown_inline',
                    'objdump',
                    'passwd',
                    'pem',
                    'perl',
                    'pod',
                    'puppet',
                    'python',
                    'query',
                    'ruby',
                    'scss',
                    'sql',
                    'ssh_config',
                    'strace',
                    'sxhkdrc',
                    'terraform',
                    'tsx',
                    'typescript',
                    'vim',
                    'vimdoc',
                    'vue',
                    'xml',
                    -- 'markdown',
                })
            end

            local config = {
                ensure_installed = ensure_installed,
                highlight = {
                    additional_vim_regex_highlighting = false,
                    enable = true,
                    disable = {'perl'},
                },
                indent = {enable = false, disable = {}},
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '[[',
                        node_incremental = '[[',
                        scope_incremental = '<c-s>',
                        node_decremental = ']]',
                    },
                    disable = {'vimwiki', 'markdown'},
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = {query = '@parameter.outer', desc = 'around argument'},
                            ['ia'] = {query = '@parameter.inner', desc = 'in argument'},
                            ['af'] = {query = '@function.outer', desc = 'around function'},
                            ['if'] = {query = '@function.inner', desc = 'in function'},
                            ['ac'] = {query = '@class.outer', desc = 'around class'},
                            ['ic'] = {query = '@class.inner', desc = 'in class'},
                        },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v',
                        ['@parameter.inner'] = 'v',
                        ['@function.outer'] = 'V',
                        ['@function.inner'] = 'V',
                        ['@class.outer'] = 'V',
                        ['@class.inner'] = 'V',
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']a'] = '@parameter.outer',
                            [']f'] = '@function.outer',
                            [']o'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']A'] = '@parameter.outer',
                            [']F'] = '@function.outer',
                            [']O'] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[a'] = '@parameter.outer',
                            ['[f'] = '@function.outer',
                            ['[o'] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[A'] = '@parameter.outer',
                            ['[F'] = '@function.outer',
                            ['[O'] = '@class.outer',
                        },
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
        dependencies = {'nvim-treesitter/nvim-treesitter'},
        event = {'BufReadPost', 'BufNewFile'},
        opts = {delay = 200, large_file_cutoff = 2000, large_file_overrides = {providers = {'lsp'}}},
        config = function(_, opts)
            local plugin = require('illuminate')
            plugin.configure(opts)

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
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nvim-treesitter/nvim-treesitter-context
        'nvim-treesitter/nvim-treesitter-context',
        enabled = vim.version().major > 0 or vim.version().minor > 8,
        dependencies = {'nvim-treesitter/nvim-treesitter'},
        opts = {},
    },
}
