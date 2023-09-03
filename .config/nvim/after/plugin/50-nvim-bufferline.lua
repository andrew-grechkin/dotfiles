local status, plugin = pcall(require, 'bufferline')
if not status then return end

plugin.setup {}
