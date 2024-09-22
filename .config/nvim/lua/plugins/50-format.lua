return {
    { -- https://github.com/stevearc/conform.nvim
        'stevearc/conform.nvim',
        version = (vim.version().major < 1 and vim.version().minor < 10) and 'v6.1.0' or nil,
        event = {'BufReadPre', 'BufNewFile'},
        opts = {
            formatters_by_ft = {
                -- ['_'] = {'trim_newlines', 'trim_whitespace'},
                ['*'] = {'trim_newlines', 'trim_whitespace'},
                cpp = {'clang-format'},
                css = {'prettier'},
                fb2 = {'xmllint'},
                html = {'prettier', 'eslint'},
                javascript = {'prettier'},
                json = {'fixjson', 'jq'},
                jsonc = {'fixjson', 'jq-sort-one-line'},
                lua = {{'lua-format', 'stylua'}},
                markdown = {'prettierd'},
                mysql = {'sql-formatter', 'mysql_sqlfluff'},
                perl = {'perltidy'},
                python = {{'darker', 'black'}},
                pgsql = {'sql-formatter', 'sqlfluff'},
                sh = {'shellharden', 'beautysh'},
                sql = {'sql-formatter', 'sqlfluff'},
                typescript = {'prettier'},
                xml = {'xmllint'},
                yaml = {'yamlfix'},
            },
            formatters_by_ft_manual = {
                json = {'jq-sort'},
                jsonc = {'jq-sort-one-line'},
                -- perl = {'perlimports'},
                python = {'isort'},
                yaml = {'yaml-sanitize'},
            },
            log_level = vim.log.levels.DEBUG,
            notify_on_error = true,
            formatters = {
                ['beautysh'] = {command = 'beautysh', args = {'--indent-size', '4', '--tab', '-'}},
                -- ['eslint'] = {command = 'eslint-fix-stdout', args = '$FILENAME'},
                ['jq-sort'] = {command = 'jq', args = {'-S', '--indent', '2'}},
                ['jq-sort-one-line'] = {command = 'jq', args = {'-S', '-c'}},
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
                            plugin.format({
                                timeout_ms = 4000,
                                formatters = opts.formatters_by_ft_manual[filetype],
                            })
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
            vim.keymap.set('n', '<leader>tf', '<cmd>ConformToggle<CR>', {desc = ' auto format'})

            opts.format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

                local ignore_filetypes = opts.ignore_filetypes or {}
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then return end

                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match('/node_modules/') then return end

                return {timeout_ms = 4000, lsp_fallback = true}
            end

            plugin.setup(opts)
        end,
    },
}
