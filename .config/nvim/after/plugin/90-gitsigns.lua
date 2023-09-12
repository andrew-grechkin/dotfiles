local status, plugin = pcall(require, 'gitsigns')
if not status then return end

-- https://github.com/lewis6991/gitsigns.nvim

plugin.setup {
    signs = {
        add = {text = '│'},
        change = {text = '║'},
        changedelete = {text = '╠'},
        delete = {text = '_'},
        topdelete = {text = '‾'},
        untracked = {text = '┆'},
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {follow_files = true},
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        delay = 1000,
        ignore_whitespace = false,
        virt_text = true,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
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
    yadm = {enable = false},

    on_attach = function(bufnr)
        local ok, which_key = pcall(require, 'which-key')
        if not ok then return end

        local gs = package.loaded.gitsigns

        -- local function map(mode, l, r, opts)
        --     opts = opts or {}
        --     opts.buffer = bufnr
        --     vim.keymap.set(mode, l, r, opts)
        -- end

        -- Navigation
        local normal_mappings = {
            ['['] = {
                name = 'Prev',
                ['h'] = {
                    function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, 'GIT: previous hunk',
                },
            },
            [']'] = {
                name = 'Next',
                ['h'] = {
                    function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, 'GIT: next hunk',
                },
            },
            ['<leader>'] = {
                ['h'] = {
                    name = 'GIT',
                    D = {function() gs.diffthis('~') end, 'GIT: diff with revision'},
                    S = {gs.stage_buffer, 'GIT: stage buffer'},
                    b = {function() gs.blame_line {full = true} end, 'GIT: blame line'},
                    d = {gs.diffthis, 'GIT: diff with index'},
                    p = {gs.preview_hunk, 'GIT: preview hunk'},
                    r = {gs.reset_hunk, 'GIT: reset hunk'},
                    s = {gs.stage_hunk, 'GIT: stage hunk'},
                    t = {
                        b = {gs.toggle_current_line_blame, 'GIT: toggle blame'},
                        d = {gs.toggle_deleted, 'GIT: toggle deleted'},
                    },
                    u = {gs.undo_stage_hunk, 'GIT: undo stage hunk'},
                },
            },
        }

        which_key.register(normal_mappings, {bufer = bufnr})

        -- -- Actions
        -- map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        -- map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        -- map('n', '<leader>hR', gs.reset_buffer)

        -- -- Text object
        -- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
}
