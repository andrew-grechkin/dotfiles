return {
    { -- https://github.com/nvim-neotest/neotest
        'nvim-neotest/neotest',
        dependencies = {
            { -- https://github.com/nvim-neotest/nvim-nio
                'nvim-neotest/nvim-nio',
            },
            { -- https://github.com/nvim-lua/plenary.nvim
                'nvim-lua/plenary.nvim',
            },
            { -- https://github.com/nvim-neotest/neotest-plenary
                'nvim-neotest/neotest-plenary',
            },
            { -- https://github.com/nvim-neotest/neotest-python
                'nvim-neotest/neotest-python',
            },
            -- { -- https://github.com/nvim-neotest/neotest-jest
            --     'nvim-neotest/neotest-jest',
            -- },
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
        enabled = not IS_KVM,
        -- init = function() require('which-key').add({{'<leader>a', group = 'Test'}}) end,
        keys = {
            group = 'Test',
            {
                '<leader>am',
                function() require('neotest').run.run() end,
                mode = {'n'},
                desc = 'Test: method',
            },
            {
                '<leader>aM',
                function() require('neotest').run.run({strategy = 'dap'}) end,
                mode = {'n'},
                desc = 'Test: method dap',
            },
            {
                '<leader>af',
                function() require('neotest').run.run({vim.fn.expand('%')}) end,
                mode = {'n'},
                desc = 'Test: file',
            },
            {
                '<leader>aF',
                function() require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'}) end,
                mode = {'n'},
                desc = 'Test: file dap',
            },
            {
                '<leader>ao',
                function() require('neotest').output.open({enter = true}) end,
                mode = {'n'},
                desc = 'Test: output',
            },
            {
                '<leader>ap',
                function() require('neotest').output_panel.toggle() end,
                mode = {'n'},
                desc = 'Test: panel',
            },
            {
                '<leader>as',
                function() require('neotest').summary.toggle() end,
                mode = {'n'},
                desc = 'Test: summary',
            },
            {
                '<leader>aw',
                function() require('neotest').watch.toggle() end,
                mode = {'n'},
                desc = 'Test: watch',
            },
            {
                '<leader>aW',
                function() require('neotest').watch.toggle(vim.fn.expand('%')) end,
                mode = {'n'},
                desc = 'Test: watch file',
            },
            {
                '[1',
                function() require('neotest').watch.jump.prev({status = 'failed'}) end,
                mode = {'n'},
                desc = 'Test: previous fail',
            },
            {
                ']1',
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
                    -- require('neotest-jest')({
                    --     discovery = {enabled = false},
                    --     jestCommand = 'npm test --',
                    --     jestConfigFile = 'custom.jest.config.ts',
                    --     env = {CI = true},
                    --     cwd = function(_) return vim.fn.getcwd() end,
                    -- }),
                    require('neotest-vim-test')({ignore_filetypes = {'lua', 'python', 'vim'}}),
                },
                output = {enabled = true, open_on_run = false},
            }

            plugin.setup(config)
        end,
    },
}
