-- Compatible with neovim only
-- Author: Andrew Grechkin
--
-- => links ------------------------------------------------------------------------------------------------------- {{{1
--
-- https://neovimcraft.com/
-- https://github.com/rockerBOO/awesome-neovim
-- https://neovim.io/doc/user/starting.html
-- https://neovim.io/doc/user/lua.html
-- https://neovim.io/doc/user/api.html
-- https://github.com/nanotee/nvim-lua-guide
--
-- => ------------------------------------------------------------------------------------------------------------- {{{1
--
vim.cmd('runtime! init/*.lua')
vim.cmd('runtime! init/*.vim')

GIT_NAME = vim.fn.system({'git', 'config', 'user.name'})
GIT_NAME = string.gsub(GIT_NAME, '%s+$', '')
IS_WORK = GIT_NAME and GIT_NAME == 'Andrei Grechkin'

HOSTNAME = vim.fn.system({'hostname'})
IS_KVM = not not string.find(HOSTNAME, 'king.com')

-- => settings ---------------------------------------------------------------------------------------------------- {{{1

vim.o.mouse = 'a'
vim.o.spelllang = 'en,nl,ru'
vim.o.termguicolors = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- => functions --------------------------------------------------------------------------------------------------- {{{1

T = function(t) return setmetatable(t, {__index = table}) end

function table:append(table)
    for _, v in ipairs(table) do self:insert(v) end
    return self
end

function table:each(code) for _, v in ipairs(self) do code(v) end end

function table:map(code)
    local acc = T {}
    for _, v in ipairs(self) do acc:insert(code(v)) end
    return acc
end

function table:reduce(init, code)
    local acc = init
    for _, v in ipairs(self) do acc = code(acc, v) end
    return acc
end

-- [[ detect project directory for path ]]
GET_PROJECT_DIR = function(path)
    -- local file = vim.api.nvim_buf_get_name(bufnr)
    -- vim.fn.stdpath('data')
    local dir = vim.fs.dirname(path)
    local gitpath = vim.fn.systemlist('git -C ' .. dir ..
                                          ' rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1')
    if gitpath and gitpath[1] then return gitpath[1] end

    local detected = vim.fs.dirname(vim.fs.find({
        '.bzr',
        '.hg',
        '.svn',
        '.vscode',
        'Makefile',
        'package.json',
        'pyproject.toml',
        'setup.py',
    }, {upward = true})[1])
    if detected then return detected end

    return vim.loop.cwd()
end

-- [[ close all other listed buffers ]]
BUF_ONLY = function()
    local curbuf = vim.api.nvim_get_current_buf()
    local bufs = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(bufs) do
        if curbuf ~= bufnr then
            local listed = vim.api.nvim_buf_get_option(bufnr, 'buflisted')
            if listed then vim.api.nvim_buf_delete(bufnr, {}) end
        end
    end
end

-- => plugins ----------------------------------------------------------------------------------------------------- {{{1

pcall(require, 'setup-plugins')

-- => automation -------------------------------------------------------------------------------------------------- {{{1

-- [[ change CWD according to the project root ]]
local rooter_notify_rec = nil
local group_auto_cd = vim.api.nvim_create_augroup('WindowAutoCD', {clear = true})
vim.api.nvim_create_autocmd({'BufReadPost', 'VimEnter'}, {
    group = group_auto_cd,
    pattern = {'*'},
    callback = function(ev)
        local notify_ok, notify = pcall(require, 'notify')
        local cwd = vim.loop.cwd()
        local dir = GET_PROJECT_DIR(ev.match)
        if cwd ~= dir then
            vim.cmd('lcd ' .. dir)
            if notify_ok then
                rooter_notify_rec = notify.notify(string.format('%s', dir), 'INFO',
                    {title = 'Project root detected', replace = rooter_notify_rec})
            end
        end

        local ok, plugin = pcall(require, 'dap.ext.vscode')
        if ok then plugin.load_launchjs(nil) end -- load launch.json
    end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost',
    {group = highlight_group, pattern = '*', callback = function() vim.highlight.on_yank() end})

-- => commands ---------------------------------------------------------------------------------------------------- {{{1

local f = vim.api.nvim_create_user_command
f('Decode1251', ':edit! ++enc=cp1251 | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('Decode866', ':edit! ++enc=cp866 | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('DecodeKoi', ':edit! ++enc=koi8-r | set fileformat=unix | set fileencoding=utf-8', {bang = true})
f('W', ':execute \':silent w !sudo tee % > /dev/null\' | :edit!', {bang = true}) -- Save file with root privileges
f('Retab', 'call tabs#beginning()', {bang = true})

-- => Cheat sheet ------------------------------------------------------------------------------------------------- {{{1

-- man: navigation
-- man: operator
-- man: text-objects
-- man: word-motions

-- => Know-How ---------------------------------------------------------------------------------------------------- {{{1

-- "=&rtp                                                                        " read variable to register
-- :verbose set tw? wm?
-- :verbose set formatoptions?
-- :vimfiles                                                                     " Config folder structure
-- :scriptnames
-- :help -V                                                                      " Trace all vim open files
-- :help filetype-overrule
-- vim --startuptime vim.log
-- vim --cmd 'profile start vimrc.profile' --cmd 'profile! file /home/agrechkin/.config/nvim/init.vim'
--
-- dump all globals
-- :redir > variables.vim
-- :let g:
-- :redir END
-- :n variables.vim
-- rm -f /tmp/vim.log; vim --startuptime /tmp/vim.log; vim /tmp/vim.log
