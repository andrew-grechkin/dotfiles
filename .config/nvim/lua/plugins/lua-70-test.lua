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
                dependencies = {'janko/vim-test'},
            },
        },
        config = function()
            plugin = require('neotest')

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

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<leader>'] = {
                        ['t'] = {
                            name = 'Test',
                            ['m'] = {function() plugin.run.run() end, 'Test: method'},
                            ['M'] = {
                                function() plugin.run.run({strategy = 'dap'}) end,
                                'Test: method dap',
                            },
                            ['f'] = {
                                function() plugin.run.run({vim.fn.expand('%')}) end,
                                'Test: file',
                            },
                            ['F'] = {
                                function()
                                    plugin.run.run({vim.fn.expand('%'), strategy = 'dap'})
                                end,
                                'Test: file dap',
                            },
                            ['o'] = {
                                function() plugin.output.open({enter = true}) end,
                                'Test: output',
                            },
                            ['p'] = {function() plugin.output_panel.toggle() end, 'Test: panel'},
                            ['s'] = {function() plugin.summary.toggle() end, 'Test: summary'},
                            ['w'] = {function() plugin.watch.toggle() end, 'Test: watch'},
                            ['W'] = {
                                function() plugin.watch.toggle(vim.fn.expand('%')) end,
                                'Test: watch file',
                            },
                        },
                    },
                    ['['] = {
                        name = 'Prev',
                        ['f'] = {
                            function() plugin.jump.prev({status = 'failed'}) end,
                            'Test: previous fail',
                        },
                    },
                    [']'] = {
                        name = 'Next',
                        ['f'] = {
                            function() plugin.jump.next({status = 'failed'}) end,
                            'Test: next fail',
                        },
                    },
                }

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end

            plugin.setup(config)
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/janko/vim-test
        'janko/vim-test',
        config = function()
            vim.api.nvim_exec([[

let g:test#strategy                = 'neovim'
let g:test#perl#prove#executable   = 'yath test --qvf'
let g:test#perl#prove#file_pattern = '\v(/|^)x?t/.*\.t$'

augroup PluginVimTest
	autocmd!
	autocmd FileType perl nmap <silent> <leader>th :let $T2_WORKFLOW = line(".") <bar> :TestFile<CR>
	autocmd FileType perl nmap <silent> <leader>te :let $T2_WORKFLOW = ""        <bar> :TestFile<CR>
augroup END

]], false)
        end,
    },
}
