local status, plugin = pcall(require, 'lsp_signature')
if not status then return end

plugin.setup {}
