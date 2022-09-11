local status, plugin = pcall(require, 'dap')
if not status then return end

-- plugin.setup {}
-- plugin.set_log_level('TRACE')

local python_ok, python = pcall(require, 'dap-python')
if python_ok then
    -- python.setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
    python.setup('/usr/bin/python')
    python.test_runner = 'pytest'
end

local ui_ok, ui = pcall(require, 'dapui')
if ui_ok then ui.setup() end

local which_key_ok, which_key = pcall(require, 'which-key')
if which_key_ok then
    -- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    -- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    -- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
    local normal_mappings = {
        ['<leader>'] = {
            b = {
                name = 'DAP',
                b = {plugin.toggle_breakpoint, 'DAP: toggle breakpoint'},
                r = {plugin.repl.open, 'DAP: REPL open'},
                s = {plugin.continue, 'DAP: start/continue'},
                t = {python.test_method, 'DAP: test closest method'},
                u = {ui.toggle, 'DAP: UI toggle'},
            },
        },
        ['<F6>'] = {plugin.step_over, 'DAP: step over'},
        ['<F7>'] = {plugin.step_into, 'DAP: step into'},
        ['<F8>'] = {plugin.step_out, 'DAP: step out'},
    }

    which_key.register(normal_mappings)
end
