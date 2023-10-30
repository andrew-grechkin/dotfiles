return {
    { -- url: https://github.com/ibhagwan/fzf-lua
        'ibhagwan/fzf-lua',
        dependencies = {
            { -- url: https://github.com/junegunn/fzf
                'junegunn/fzf',
                build = './install --bin',
            },
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local plugin = require('fzf-lua')
            plugin.setup({
                git = {
                    bcommits = {preview_pager = 'delta'},
                    commits = {preview_pager = 'delta'},
                    status = {preview_pager = 'delta'},
                },
                winopts = {preview = {layout = 'flex'}},
            })
            plugin.register_ui_select()

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<C-b>'] = {plugin.buffers, 'fzf: buffers'},
                    ['<C-h>'] = {plugin.oldfiles, 'fzf: history'},
                    ['<C-p>'] = {plugin.files, 'fzf: files project'},
                    ['<leader>'] = {
                        ['<C-p>'] = {
                            function()
                                local dir = vim.fs.dirname(vim.fn.expand('%'))
                                plugin.files({cwd = dir})
                            end,
                            'fzf: files curdir',
                        },
                        r = {
                            name = 'Repo (git)',
                            b = {'<cmd>FzfLua git_branches<CR>', 'fzf: branches'},
                            c = {'<cmd>FzfLua git_bcommits<CR>', 'fzf: commits for buffer'},
                            f = {'<cmd>FzfLua git_files<CR>', 'fzf: files'},
                            r = {'<cmd>FzfLua git_commits<CR>', 'fzf: commits'},
                            s = {'<cmd>FzfLua git_status<CR>', 'fzf: status'},
                            t = {'<cmd>FzfLua git_stash<CR>', 'fzf: stashes'},
                        },
                    },
                }

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/junegunn/fzf.vim
        'junegunn/fzf.vim',
        enabled = false,
        dependencies = {
            { -- url: https://github.com/junegunn/fzf
                'junegunn/fzf',
                build = './install --bin',
            },
        },
        config = function()
            vim.api.nvim_create_user_command('FilesCurrentDir', 'execute \'Files\' dir#current()', {
                bang = true,
            })
            vim.api.nvim_create_user_command('FilesProject', 'execute \'Files\' dir#git_root()', {
                bang = true,
            })

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<C-b>'] = {':Buffers<CR>', 'fzf: buffers'},
                    ['<C-h>'] = {':History<CR>', 'fzf: history'},
                    ['<C-p>'] = {':FilesProject<CR>', 'fzf: files repo'},
                    ['<leader>'] = {['<C-p>'] = {':FilesCurrentDir<CR>', 'fzf: files curdir'}},
                }

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/ThePrimeagen/harpoon
        'ThePrimeagen/harpoon',
        config = function()
            local plugin = require('harpoon')
            local config = {
                -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                save_on_toggle = false,

                -- saves the harpoon file upon every change. disabling is unrecommended.
                save_on_change = true,

                -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                enter_on_sendcmd = false,

                -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                tmux_autoclose_windows = false,

                -- filetypes that you want to prevent from adding to the harpoon list menu.
                excluded_filetypes = {'harpoon'},

                -- set marks specific to each git branch inside git repository
                mark_branch = false,

                -- enable tabline with harpoon marks
                tabline = false,
                tabline_prefix = '   ',
                tabline_suffix = '   ',
            }
            plugin.setup(config)
            require('telescope').load_extension('harpoon')

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['z<Space>'] = {
                        function() require('harpoon.mark').add_file() end,
                        'harpoon: add',
                    },
                    ['z,'] = {function() require('harpoon.ui').nav_prev() end, 'harpoon: prev'},
                    ['z.'] = {function() require('harpoon.ui').nav_next() end, 'harpoon: next'},
                    ['zh'] = {
                        function() require('harpoon.ui').toggle_quick_menu() end,
                        'harpoon: menu',
                    },
                    ['zj'] = {function() require('harpoon.ui').nav_file(1) end, 'harpoon: 1'},
                    ['zk'] = {function() require('harpoon.ui').nav_file(2) end, 'harpoon: 2'},
                    ['zl'] = {function() require('harpoon.ui').nav_file(3) end, 'harpoon: 3'},
                    ['z;'] = {function() require('harpoon.ui').nav_file(4) end, 'harpoon: 4'},
                }

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/vifm/vifm.vim
        'vifm/vifm.vim',
        config = function()
            vim.g.vifm_embed_split = 1

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<leader>'] = {['<leader>'] = {n = {':EditVifm<CR>', 'vifm: split vertical'}}},
                }

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/christoomey/vim-tmux-navigator
        'christoomey/vim-tmux-navigator',
        config = function()
            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local mappings = {
                    ['<M-\\>'] = {'<C-\\><C-n>:TmuxNavigatePrevious<CR>', 'tmux: navigate previous'},
                    ['<M-h>'] = {'<C-\\><C-n>:TmuxNavigateLeft<CR>', 'tmux: navigate left'},
                    ['<M-j>'] = {'<C-\\><C-n>:TmuxNavigateDown<CR>', 'tmux: navigate down'},
                    ['<M-k>'] = {'<C-\\><C-n>:TmuxNavigateUp<CR>', 'tmux: navigate up'},
                    ['<M-l>'] = {'<C-\\><C-n>:TmuxNavigateRight<CR>', 'tmux: navigate right'},
                }

                which_key.register(mappings, {mode = 'n', nowait = true, noremap = true})
                which_key.register(mappings, {mode = 'i', nowait = true, noremap = true})
                which_key.register(mappings, {mode = 't', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/mbbill/undotree
        'mbbill/undotree',
    },
}
