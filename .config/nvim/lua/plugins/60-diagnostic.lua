return {
    { -- https://github.com/folke/todo-comments.nvim
        'folke/todo-comments.nvim',
        cmd = {'TodoTrouble', 'TodoTelescope'},
        event = {'BufReadPost', 'BufNewFile'},
        keys = {
            -- TODO: fix keymaps
            -- {']a', function() require('todo-comments').jump_next() end, desc = 'Next todo comment'},
            -- {
            --     '[a',
            --     function() require('todo-comments').jump_prev() end,
            --     desc = 'Previous todo comment',
            -- },
            -- {
            --     '<leader>sT',
            --     '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
            --     desc = 'Todo/Fix/Fixme',
            -- },
        },
        opts = {},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/folke/trouble.nvim
        'folke/trouble.nvim',
        config = true,
        cmd = {'Trouble'},
        version = (vim.version().major < 1 and vim.version().minor < 9) and 'v2.10.0' or nil,
    },
}
