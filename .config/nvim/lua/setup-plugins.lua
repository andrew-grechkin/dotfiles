local lazypath = vim.env.LAZY or (vim.fn.stdpath('data') .. '/lazy/lazy.nvim')
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

local ok, plugin = pcall(require, 'lazy')
if not ok then return end
plugin.setup('plugins')
