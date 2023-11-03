return {
    { -- https://github.com/stevearc/conform.nvim
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                cpp = {'clang-format'},
                css = {'prettier'},
                fb2 = {'xmllint'},
                html = {'prettier', 'eslint'},
                javascript = {{'prettierd', 'prettier'}},
                json = {'fixjson', 'jq'},
                lua = {{'stylua', 'lua-format'}},
                mysql = {'sql-formatter', 'mysql_sqlfluff'},
                perl = {'perltidy'},
                python = {'isort', 'black'},
                sh = {'shellharden', 'beautysh'},
                sql = {'sql-formatter', 'sqlfluff'},
                typescript = {'eslint'},
                xml = {'xmllint'},
                yaml = {'yamlfix'},
                ['*'] = {'trim_newlines', 'trim_whitespace'},
                -- ['_'] = {'trim_newlines', 'trim_whitespace'},
            },
            formatters_by_ft_manual = {
                json = {'jq-sort'},
                perl = {'perlimports'},
                yaml = {'yaml-sanitize'},
            },
            log_level = vim.log.levels.DEBUG,
            notify_on_error = true,
            formatters = {
                ['jq-sort'] = {command = 'jq', args = {'-S', '--indent', '2'}},
                ['lua-format'] = {command = 'lua-format', args = {'-i'}},
                ['yaml-sanitize'] = {command = 'yaml-sanitize'},
            },
        },
        config = function(_, opts)
            local plugin = require('conform')

            vim.api.nvim_create_autocmd({'BufReadPost'}, {
                group = vim.api.nvim_create_augroup('format_ManualKeymaps', {clear = true}),
                callback = function(event)
                    local filetype = vim.bo[event.buf].filetype
                    if opts.formatters_by_ft_manual[filetype] then
                        vim.keymap.set({'n'}, 'gqq', function()
                            plugin.format({formatters = opts.formatters_by_ft_manual[filetype]})
                        end, {desc = 'Format: manual whole file', nowait = true, noremap = true})
                    end
                    -- TODO: implement inject formatting
                    -- {
                    --     '<leader>cF',
                    --     function() require('conform').format({ formatters = { 'injected' } }) end,
                    --     mode = { 'n', 'v' },
                    --     desc = 'Format Injected Langs',
                    -- },
                end,
            })

            vim.api.nvim_create_user_command('ConformToggle', function()
                vim.b[0].disable_autoformat = not (vim.b[0].disable_autoformat == nil and vim.g.disable_autoformat or
                                                  vim.b[0].disable_autoformat)
            end, {})

            opts.format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

                local ignore_filetypes = opts.ignore_filetypes or {}
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then return end

                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match('/node_modules/') then return end

                return {timeout_ms = 1000, lsp_fallback = true}
            end

            plugin.setup(opts)
        end,
    },
}
