return {
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    { -- https://github.com/mfussenegger/nvim-dap
        'mfussenegger/nvim-dap',
        lazy = true,
        dependencies = {
            { -- https://github.com/theHamsta/nvim-dap-virtual-text
                'theHamsta/nvim-dap-virtual-text',
                opts = {
                    enabled = true, -- enable this plugin (the default)
                    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                    highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                    show_stop_reason = true, -- show stop reason when stopped for exceptions
                    commented = true, -- prefix virtual text with comment string
                    only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
                    all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                    --     filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
                    --     -- experimental features:
                    --     virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
                    --     all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                    --     virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                    --     virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
                    --     -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
                },
            },
            { -- https://github.com/nvim-telescope/telescope-dap.nvim
                'nvim-telescope/telescope-dap.nvim',
            },
        },
        config = function()
            local dap = require('dap')

            -- this is optional but can be helpful when starting out
            dap.set_log_level 'TRACE'

            -- require('dap.ext.vscode').load_launchjs(nil, {cppdbg = {'c', 'cpp'}})

            -- => perl -------------------------------------------------------------------------------------------- {{{1

            dap.adapters.perl = {args = {}, command = 'perl-debug-adapter', type = 'executable'}
            dap.configurations.perl = {
                {
                    name = 'Launch Perl',
                    program = '${workspaceFolder}/${relativeFile}',
                    request = 'launch',
                    type = 'perl',
                },
            }

            require('telescope').load_extension('dap')
        end,
    },
    { -- https://github.com/mfussenegger/nvim-dap-python
        'mfussenegger/nvim-dap-python',
        lazy = true,
        dependencies = {'mfussenegger/nvim-dap'},
        config = function()
            local plugin = require('dap-python')

            -- python.setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
            plugin.setup('python', {console = 'integratedTerminal'})
            plugin.test_runner = 'pytest'
            -- table.insert(require('dap').configurations.python, {
            --     type = 'python',
            --     request = 'launch',
            --     name = 'ZZZ My custom launch configuration',
            --     program = '${file}',
            -- })
        end,
    },
    { -- https://github.com/jbyuki/one-small-step-for-vimkind
        'jbyuki/one-small-step-for-vimkind',
        lazy = true,
        dependencies = {'mfussenegger/nvim-dap'},
        config = function()
            local dap = require('dap')

            dap.adapters.nlua = function(callback, config)
                callback({
                    type = 'server',
                    host = config.host or '127.0.0.1',
                    port = config.port or 8086,
                })
            end
            dap.configurations.lua = {
                {name = 'Attach to running Neovim instance', request = 'attach', type = 'nlua'},
            }
        end,
    },
    { -- https://github.com/rcarriga/nvim-dap-ui
        'rcarriga/nvim-dap-ui',
        keys = {'<leader>db', '<leader>dc', '<leader>dd'},
        dependencies = {'jay-babu/mason-nvim-dap.nvim', 'mfussenegger/nvim-dap'},
        config = function()
            local dap = require('dap')
            local ui = require('dapui')
            ui.setup()

            dap.listeners.after.event_initialized['dapui_config'] = function() ui.open() end
            -- dap.listeners.before.event_terminated['dapui_config'] = function() ui.close() end
            -- dap.listeners.before.event_exited['dapui_config'] = function() ui.close() end

            local wk_ok, which_key = pcall(require, 'which-key')
            if not wk_ok then return end
            -- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
            -- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
            -- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
            local normal_mappings = {
                ['<leader>'] = {
                    d = {
                        name = 'DAP',
                        B = {
                            function() dap.set_breakpoint(vim.fn.input '[Condition] > ') end,
                            'DAP: conditional breakpoint',
                        },
                        b = {dap.toggle_breakpoint, 'DAP: toggle breakpoint'},
                        c = {dap.continue, 'DAP: start/continue'},
                        d = {ui.toggle, 'DAP: UI toggle'},
                        e = {
                            function() ui.eval(vim.fn.input '[Expression] > ') end,
                            'DAP: UI expression',
                        },
                        q = {dap.disconnect, 'DAP: quit'},
                        r = {dap.repl.open, 'DAP: REPL open'},
                        -- t = {python.test_method, 'DAP: test closest method'},
                    },
                },
                ['<F6>'] = {dap.step_over, 'DAP: step over'},
                ['<S-F6>'] = {dap.step_back, 'DAP: step back'},
                ['<F7>'] = {dap.step_into, 'DAP: step into'},
                ['<F8>'] = {dap.step_out, 'DAP: step out'},
                ['<F9>'] = {dap.run_to_cursor, 'DAP: run to cursor'},

                -- vim.api.nvim_set_keymap('n', '<F12>', [[:lua require"dap.ui.widgets".hover()<CR>]], { noremap = true })
                -- vim.api.nvim_set_keymap('n', '<F5>', [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })
                -- d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
                -- e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
                -- g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
                -- h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
                -- S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
                -- p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
                -- r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
            }

            which_key.register(normal_mappings)
        end,
    },
}
