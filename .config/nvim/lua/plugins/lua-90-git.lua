return {
    { -- https://github.com/lewis6991/gitsigns.nvim
        'lewis6991/gitsigns.nvim',
        event = {'BufReadPre', 'BufNewFile'},
        config = function()
            local ok, plugin = pcall(require, 'gitsigns')
            if not ok then return {} end

            local config = {
                signs = {
                    add = {text = '│'},
                    change = {text = '║'},
                    changedelete = {text = '╠'},
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
                show_deleted = false,
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
                yadm = {enable = false},

                on_attach = function(bufnr)
                    local ok, which_key = pcall(require, 'which-key')
                    if not ok then return end

                    local normal_mappings = {
                        ['['] = {name = 'Prev', ['h'] = {plugin.prev_hunk, 'GIT: previous hunk'}},
                        [']'] = {name = 'Next', ['h'] = {plugin.next_hunk, 'GIT: next hunk'}},
                        ['<leader>'] = {
                            ['h'] = {
                                name = 'GIT',
                                D = {function() plugin.diffthis('~') end, 'GIT: diff with revision'},
                                S = {plugin.stage_buffer, 'GIT: stage buffer'},
                                b = {
                                    function() plugin.blame_line {full = true} end,
                                    'GIT: blame line',
                                },
                                c = {
                                    name = 'GIT: checkout',
                                    O = {plugin.reset_buffer, 'GIT: checkout buffer'},
                                    o = {plugin.reset_hunk, 'GIT: checkout hunk'},
                                },
                                d = {plugin.diffthis, 'GIT: diff with index'},
                                p = {plugin.preview_hunk, 'GIT: preview hunk'},
                                s = {plugin.stage_hunk, 'GIT: stage hunk'},
                                t = {
                                    b = {plugin.toggle_current_line_blame, 'GIT: toggle blame'},
                                    d = {plugin.toggle_deleted, 'GIT: toggle deleted'},
                                },
                                u = {plugin.undo_stage_hunk, 'GIT: unstage hunk'},
                                v = {plugin.select_hunk, 'GIT: select hunk'},
                            },
                        },
                    }

                    which_key.register(normal_mappings, {bufer = bufnr, noremap = true})
                end,
            }

            plugin.setup(config)
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/tpope/vim-fugitive
        'tpope/vim-fugitive',
        config = function()
            local PRIVATE_DOMAIN = vim.api.nvim_get_var('PRIVATE_DOMAIN')
            vim.g.fugitive_gitlab_domains = 'https://gitlab.' .. PRIVATE_DOMAIN .. '.com'
            vim.api.nvim_del_user_command('Gbrowse')
        end,
    },
}
