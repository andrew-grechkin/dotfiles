return {
    { -- https://github.com/polarmutex/git-worktree.nvim
        'nooproblem/git-worktree.nvim',
        event = {'BufReadPost', 'BufNewFile'},
        config = function()
            require('git-worktree').setup()
            require('telescope').load_extension('git_worktree')

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                which_key.add({
                    {'<leader>sW', group = ': workspaces'},
                    {
                        '<leader>sWW',
                        function() require('telescope').extensions.git_worktree.git_worktrees() end,
                        desc = ': worktree list',
                    },
                    {
                        '<leader>sWc',
                        function()
                            require('telescope').extensions.git_worktree.create_git_worktree()
                        end,
                        desc = ': worktree create',
                    },
                })
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/tpope/vim-fugitive
        'tpope/vim-fugitive',
        cmd = {'G'},
        config = function()
            vim.api.nvim_del_user_command('Gbrowse')
            vim.api.nvim_del_user_command('Gremove')

            vim.api.nvim_create_user_command('GBlame', 'Git blame', {})
        end,
        dependencies = {
            { -- https://github.com/tpope/vim-rhubarb
                'tpope/vim-rhubarb',
            },
            { -- url: https://github.com/shumphrey/fugitive-gitlab.vim
                'shumphrey/fugitive-gitlab.vim',
                enabled = IS_WORK,
                config = function()
                    vim.g.fugitive_gitlab_domains = {'https://gitlab.' .. PRIVATE_DOMAIN .. '.com'}
                end,
            },
        },
        event = {'BufReadPost', 'BufNewFile'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/lewis6991/gitsigns.nvim
        'lewis6991/gitsigns.nvim',
        enabled = not IS_KVM,
        event = {'BufReadPre', 'BufNewFile'},
        opts = {
            signs = {
                add = {text = '│'},
                change = {text = '║'},
                changedelete = {text = '╟'},
                delete = {text = '_'},
                topdelete = {text = '‾'},
                untracked = {text = '┆'},
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {follow_files = true},
            attach_to_untracked = true,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                delay = 1000,
                ignore_whitespace = true,
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1,
            },

            on_attach = function(bufnr)
                local plugin = package.loaded.gitsigns

                local ok, which_key = pcall(require, 'which-key')
                if not ok then return end

                which_key.add({
                    {'[h', plugin.prev_hunk, desc = 'GIT: previous hunk'},
                    {']h', plugin.next_hunk, desc = 'GIT: next hunk'},

                    {'<leader>h', group = 'GIT'},
                    {
                        '<leader>hD',
                        function() plugin.diffthis('~') end,
                        desc = 'GIT: diff with HEAD',
                    },
                    {'<leader>hS', plugin.stage_buffer, desc = 'GIT: stage buffer'},
                    {
                        '<leader>hb',
                        function() plugin.blame_line {full = true} end,
                        desc = 'GIT: blame line',
                    },
                    {'<leader>hd', plugin.diffthis, desc = 'GIT: diff with index'},
                    {'<leader>hp', plugin.preview_hunk, desc = 'GIT: preview hunk'},
                    {'<leader>hs', plugin.stage_hunk, desc = 'GIT: stage hunk'},
                    {'<leader>ht', group = 'GIT: toggle'},
                    {'<leader>htb', plugin.toggle_current_line_blame, desc = 'GIT: toggle blame'},
                    {'<leader>htd', plugin.toggle_deleted, desc = 'GIT: toggle deleted'},
                    {'<leader>hu', plugin.undo_stage_hunk, desc = 'GIT: unstage hunk'},
                    {'<leader>hv', plugin.select_hunk, desc = 'GIT: select hunk'},

                    {'<leader>hc', group = 'GIT: checkout'},
                    {'<leader>hcO', plugin.reset_buffer, desc = 'GIT: checkout buffer'},
                    {'<leader>hco', plugin.reset_hunk, desc = 'GIT: checkout hunk'},
                })
            end,
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- { -- https://github.com/NeogitOrg/neogit
    --     'NeogitOrg/neogit',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim', -- required
    --         'sindrets/diffview.nvim', -- optional - Diff integration

    --         -- Only one of these is needed, not both.
    --         'nvim-telescope/telescope.nvim',
    --         'ibhagwan/fzf-lua',
    --     },
    --     config = true,
    -- },
}
