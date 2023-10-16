return {
    { -- url: https://github.com/junegunn/fzf.vim
        'junegunn/fzf.vim',
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
}
