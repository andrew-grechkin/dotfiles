return {
    { -- https://github.com/nvim-neotest/neotest
        'nvim-neotest/neotest',
        dependencies = {
            { -- https://github.com/nvim-neotest/neotest-plenary
                'nvim-neotest/neotest-plenary',
            },
            { -- https://github.com/nvim-neotest/neotest-python
                'nvim-neotest/neotest-python',
            },
            { -- https://github.com/nvim-neotest/neotest-vim-test
                'nvim-neotest/neotest-vim-test',
                dependencies = {
                    { -- https://github.com/janko/vim-test
                        'janko/vim-test',
                        config = function()
                            vim.cmd [[
                                let g:test#strategy                = 'neovim'
                                let g:test#perl#prove#executable   = 'yath test --qvf'
                                let g:test#perl#prove#file_pattern = '\v(/|^)x?t/.*\.t$'

                                augroup PluginVimTest
                                    autocmd!
                                    autocmd FileType perl nmap <silent> <leader>th :let $T2_WORKFLOW = line(".") <bar> :TestFile<CR>
                                    autocmd FileType perl nmap <silent> <leader>te :let $T2_WORKFLOW = ""        <bar> :TestFile<CR>
                                augroup END
                            ]]
                        end,
                    },
                },
            },
        },
        init = function() require('which-key').register({['<leader>u'] = {name = 'Test'}}) end,
        keys = {
            {
                '<leader>um',
                function() require('neotest').run.run() end,
                mode = {'n'},
                desc = 'Test: method',
            },
            {
                '<leader>uM',
                function() require('neotest').run.run({strategy = 'dap'}) end,
                mode = {'n'},
                desc = 'Test: method dap',
            },
            {
                '<leader>uf',
                function() require('neotest').run.run({vim.fn.expand('%')}) end,
                mode = {'n'},
                desc = 'Test: file',
            },
            {
                '<leader>uF',
                function() require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'}) end,
                mode = {'n'},
                desc = 'Test: file dap',
            },
            {
                '<leader>uo',
                function() require('neotest').output.open({enter = true}) end,
                mode = {'n'},
                desc = 'Test: output',
            },
            {
                '<leader>up',
                function() require('neotest').output_panel.toggle() end,
                mode = {'n'},
                desc = 'Test: panel',
            },
            {
                '<leader>us',
                function() require('neotest').summary.toggle() end,
                mode = {'n'},
                desc = 'Test: summary',
            },
            {
                '<leader>uw',
                function() require('neotest').watch.toggle() end,
                mode = {'n'},
                desc = 'Test: watch',
            },
            {
                '<leader>uW',
                function() require('neotest').watch.toggle(vim.fn.expand('%')) end,
                mode = {'n'},
                desc = 'Test: watch file',
            },
            {
                '[u',
                function() require('neotest').watch.jump.prev({status = 'failed'}) end,
                mode = {'n'},
                desc = 'Test: previous fail',
            },
            {
                ']u',
                function() require('neotest').watch.jump.next({status = 'failed'}) end,
                mode = {'n'},
                desc = 'Test: next fail',
            },
        },
        config = function()
            local plugin = require('neotest')

            local config = {
                adapters = {
                    require('neotest-plenary'),
                    require('neotest-python')({
                        dap = {justMyCode = false, console = 'integratedTerminal'},
                        args = {'--log-level=DEBUG', '--quiet'},
                        runner = 'pytest',
                    }),
                    require('neotest-vim-test')({ignore_filetypes = {'lua', 'python', 'vim'}}),
                },
                output = {enabled = true, open_on_run = false},
            }

            plugin.setup(config)
        end,
    },
}
