return {
    { -- https://github.com/andrew-grechkin/nvim-lint
        'andrew-grechkin/nvim-lint',
        config = function()
            local plugin = require('lint')

            plugin.linters_by_ft = {
                gitcommit = {'commitlint'},
                json = {'jsonlint'},
                -- perl = {'perlimports', 'perlcritic'},
                perl = {'perlcritic'},
                puppet = {'puppet-lint'},
                sql = {'sqlfluff'},
                yaml = {'yamllint'},
            }

            vim.api.nvim_create_autocmd({'BufWritePost'}, {
                group = vim.api.nvim_create_augroup('lint_OnSave', {clear = true}),
                callback = function() plugin.try_lint() end,
            })
        end,
        event = {'BufReadPre', 'BufNewFile'},
    },
}
