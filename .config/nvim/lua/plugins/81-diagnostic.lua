return {
    { -- https://github.com/folke/todo-comments.nvim
        'folke/todo-comments.nvim',
        cmd = {'TodoTrouble', 'TodoTelescope'},
        event = 'BufReadPost',
        opts = {},
        keys = {
            -- TODO: fix keymaps
            {']a', function() require('todo-comments').jump_next() end, desc = 'Next todo comment'},
            {
                '[a',
                function() require('todo-comments').jump_prev() end,
                desc = 'Previous todo comment',
            },
            -- {
            --     '<leader>sT',
            --     '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
            --     desc = 'Todo/Fix/Fixme',
            -- },
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/folke/trouble.nvim
        'folke/trouble.nvim',
        config = true,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/mfussenegger/nvim-lint
        'mfussenegger/nvim-lint',
        config = function()
            local plugin = require('lint')

            plugin.linters_by_ft = {
                json = {'jsonlint'},
                perl = {'perlimports'},
                puppet = {'puppet-lint'},
                sql = {'sqlfluff'},
                yaml = {'yamllint'},
            }

            vim.api.nvim_create_autocmd({'BufWritePost'}, {
                group = vim.api.nvim_create_augroup('lint_OnSave', {clear = true}),
                callback = function() plugin.try_lint() end,
            })
        end,
    },
}
