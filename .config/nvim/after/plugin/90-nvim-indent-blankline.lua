local status, plugin = pcall(require, 'indent_blankline')
if not status then return end

vim.opt.list = true
-- vim.opt.listchars:append 'eol:␤'
-- vim.opt.listchars:append 'space:⋅'

plugin.setup {
	show_current_context = true,
    show_current_context_start = true,
}
