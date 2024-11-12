return {
    { -- https://github.com/chrisbra/csv.vim
        'chrisbra/csv.vim',
        config = function()
            vim.api.nvim_set_hl(0, 'CSVDelimiter', {link = 'Ignore'})
            vim.api.nvim_set_hl(0, 'CSVColumnEven', {link = 'SpecialComment'})
            -- vim.api.nvim_set_hl(0, 'CSVColumnOdd', {})
            vim.api.nvim_set_hl(0, 'CSVColumnHeaderEven', {link = 'Title'})
            vim.api.nvim_set_hl(0, 'CSVColumnHeaderOdd', {link = 'Title'})
        end,
        init = function()
            -- vim.g.csv_default_delim = '\t'
            -- vim.g.csv_delim_test = '\t,'
            -- vim.g.csv_no_conceal = 1

            vim.g.csv_arrange_use_all_rows = 1
            vim.g.csv_autocmd_arrange = 1
            vim.g.csv_no_progress = 1
            vim.g.csv_strict_columns = 1

            -- vim.g.csv_no_column_highlight = 1
            vim.g.csv_highlight_column = 'y'

            -- vim.g.csv_skipfirst = 1
            vim.g.csv_start = 1
            vim.g.csv_end = 1
        end,
        opt = {},
    },
}
