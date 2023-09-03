-- https://github.com/mfussenegger/nvim-dap
local dap_ok, dap = pcall(require, 'dap')
if not dap_ok then return end

-- dap.setup {}
-- dap.set_log_level('TRACE')
-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
-- dap.defaults.fallback.focus_terminal = true

-- => ------------------------------------------------------------------------------------------------------------- {{{1

local lua_ok, lua = pcall(require, 'dap-lua')
if lua_ok then lua.setup() end

-- => ------------------------------------------------------------------------------------------------------------- {{{1

-- https://github.com/mfussenegger/nvim-dap-python
local python_ok, python = pcall(require, 'dap-python')
if python_ok then
    -- python.setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
    python.setup('/usr/bin/python', {console = 'integratedTerminal'})
    python.test_runner = 'pytest'
end

-- => ------------------------------------------------------------------------------------------------------------- {{{1

dap.adapters.bashdb = {
    command = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
    name = 'bashdb',
    type = 'executable',
}

dap.configurations.sh = {
    {
        args = {},
        cwd = '${workspaceFolder}',
        env = {},
        file = '${file}',
        name = 'Launch file',
        pathBash = '/bin/bash',
        pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        pathCat = 'cat',
        pathMkfifo = 'mkfifo',
        pathPkill = 'pkill',
        program = '${file}',
        request = 'launch',
        showDebugOutput = true,
        terminalKind = 'integrated',
        trace = true,
        type = 'bashdb',
    },
}

-- => ------------------------------------------------------------------------------------------------------------- {{{1

dap.adapters.perl = {
    type = 'executable',
    command = vim.env.MASON .. '/bin/perl-debug-adapter',
    args = {},
}

dap.configurations.perl = {
    {
        name = 'Launch Perl',
        program = '${workspaceFolder}/${relativeFile}',
        request = 'launch',
        type = 'perl',
    },
}

-- => ------------------------------------------------------------------------------------------------------------- {{{1

-- https://github.com/theHamsta/nvim-dap-virtual-text
local text_ok, text = pcall(require, 'nvim-dap-virtual-text')
if text_ok then
    text.setup({
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
    })
end

-- => ------------------------------------------------------------------------------------------------------------- {{{1

-- https://github.com/rcarriga/nvim-dap-ui
local ui_ok, ui = pcall(require, 'dapui')
if ui_ok then ui.setup() end

dap.listeners.after.event_initialized['dapui_config'] = function() ui.open() end
-- dap.listeners.before.event_terminated['dapui_config'] = function() ui.close() end
-- dap.listeners.before.event_exited['dapui_config'] = function() ui.close() end

local which_key_ok, which_key = pcall(require, 'which-key')
if which_key_ok then
    -- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    -- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    -- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
    local normal_mappings = {
        ['<leader>'] = {
            b = {
                name = 'DAP',
                b = {dap.toggle_breakpoint, 'DAP: toggle breakpoint'},
                c = {
                    function() dap.set_breakpoint(vim.fn.input '[Condition] > ') end,
                    'DAP: conditional breakpoint',
                },
                e = {function() ui.eval(vim.fn.input '[Expression] > ') end, 'DAP: UI expression'},
                r = {dap.repl.open, 'DAP: REPL open'},
                s = {dap.continue, 'DAP: start/continue'},
                t = {python.test_method, 'DAP: test closest method'},
                u = {ui.toggle, 'DAP: UI toggle'},
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
        -- q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
        -- r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        -- x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
    }

    which_key.register(normal_mappings)
end

-- => ------------------------------------------------------------------------------------------------------------- {{{1

require('telescope').load_extension('dap')
