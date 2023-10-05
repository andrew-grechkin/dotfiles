-- Compatible with neovim only
-- Author: Andrew Grechkin
-- https://github.com/rockerBOO/awesome-neovim
-- https://neovim.io/doc/user/starting.html
-- https://neovim.io/doc/user/lua.html
-- https://neovim.io/doc/user/api.html
-- https://github.com/nanotee/nvim-lua-guide
vim.cmd('runtime! init/*.lua')
vim.cmd('runtime! init/*.vim')

GIT_NAME = vim.fn.system({'git', 'config', 'user.name'})
GIT_NAME = string.gsub(GIT_NAME, '%s+$', '')
IS_WORK = GIT_NAME and GIT_NAME == 'Andrei Grechkin'

HOSTNAME = vim.fn.system({'hostname'})
IS_KVM = not not string.find(HOSTNAME, 'king.com')

require('setup-plugins')

-- vim.cmd('runtime! init/**/*.lua')
-- vim.cmd('runtime! init/**/*.vim')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost',
    {callback = function() vim.highlight.on_yank() end, group = highlight_group, pattern = '*'})

-- => Cheat sheet ------------------------------------------------------------------------------------------------- {{{1

--                  gg
--                  ?
--                  ^b
--                  H
--                  {
--                  k
-- 0 ^ F T ( b ge h M l w e ) t f $
--                  j
--                  }
--                  L
--                  ^f
--                  /
--                  G
--
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
