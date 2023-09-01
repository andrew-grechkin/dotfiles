local status, plugin = pcall(require, 'neotest')
if not status then return end

-- TODO dynamic loading
local adapters = {
    require('neotest-python')({dap = {justMyCode = false}}), require('neotest-plenary'),
    require('neotest-vim-test')({ignore_file_types = {'python', 'vim', 'lua'}}),
}

plugin.setup {adapters = adapters}

local which_key_ok, which_key = pcall(require, 'which-key')
if which_key_ok then
    local normal_mappings = {
        ['<leader>'] = {
            t = {
                name = 'Test',
                d = {
                    function() plugin.run.run({vim.fn.expand('%'), strategy = 'dap'}) end,
                    'test: file debug',
                },
                f = {function() plugin.run.run(vim.fn.expand('%')) end, 'test: file'},
                j = {function() plugin.jump.next({status = 'failed'}) end, 'test: jump next'},
                o = {function() plugin.output.open({enter = true}) end, 'test: output'},
                s = {plugin.summary.toggle, 'test: summary'},
                t = {plugin.run.run, 'test: this'},
            },
        },
    }

    which_key.register(normal_mappings)
end
