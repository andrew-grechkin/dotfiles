local status, plugin = pcall(require, 'neotest')
if not status then return end

-- TODO dynamic loading
local adapters = {
    require('neotest-python')({dap = {justMyCode = false}}), require('neotest-plenary'),
    require('neotest-vim-test')({ignore_file_types = {'python', 'vim', 'lua'}}),
}

plugin.setup {adapthers = adapters}
