return {
    { -- https://github.com/andrew-grechkin/nvim-lint
        'andrew-grechkin/nvim-lint',
        config = function()
            local plugin = require('lint')

            -- customize linters
            local deno = plugin.linters.deno
            deno.args = {}
            deno.cmd = 'deno-check'
            deno.stdin = true

            plugin.linters_by_ft = {
                gitcommit = {'commitlint'},
                json = {'jsonlint'},
                -- perl = {'perlimports', 'perlcritic'},
                perl = {'perlcritic'},
                puppet = {'puppet-lint'},
                sql = {'sqlfluff'},
                yaml = {'yamllint'},
                ['deno'] = {'deno'},
                ['typescript.deno'] = {'deno'},
            }

            vim.api.nvim_create_autocmd({'BufWritePost'}, {
                group = vim.api.nvim_create_augroup('lint_OnSave', {clear = true}),
                callback = function() plugin.try_lint() end,
            })
        end,
        event = {'BufReadPre', 'BufNewFile'},
    },
}
