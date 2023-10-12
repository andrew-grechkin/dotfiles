return {
    { -- https://github.com/tpope/vim-dadbod
        'tpope/vim-dadbod',
        -- cmd = {'DB'},
        -- lazy = true,
    },
    { -- https://github.com/kristijanhusak/vim-dadbod-ui
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { -- https://github.com/kristijanhusak/vim-dadbod-completion
                'kristijanhusak/vim-dadbod-completion',
                ft = {'sql', 'mysql', 'plsql'},
                lazy = true,
            },
        },
        cmd = {'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer'},
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_auto_execute_table_helpers = 1
        end,
    },
}
