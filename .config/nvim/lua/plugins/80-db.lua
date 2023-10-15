return {
    { -- https://github.com/tpope/vim-dadbod
        'tpope/vim-dadbod',
        -- cmd = {'DB'},
        -- lazy = true,
    },
    { -- https://github.com/kristijanhusak/vim-dadbod-ui
        'kristijanhusak/vim-dadbod-ui',
        cmd = {'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer'},
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_table_helpers = {
                postgresql = {
                    Columns = 'SELECT * FROM information_schema.columns WHERE table_schema=\'{dbname}\' AND table_name=\'{table}\'',
                    Count = 'SELECT COUNT(*) FROM {table}',
                    List = 'SELECT * FROM {table} LIMIT 200',
                },
            }
        end,
    },
}
