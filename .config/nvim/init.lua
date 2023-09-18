-- Compatible with neovim only
-- Author: Andrew Grechkin
-- https://github.com/rockerBOO/awesome-neovim
vim.cmd('runtime! init/*.lua')
vim.cmd('runtime! init/*.vim')

GIT_NAME = vim.fn.system({'git', 'config', 'user.name'})
GIT_NAME = string.gsub(GIT_NAME, '%s+$', '')
IS_WORK = GIT_NAME and GIT_NAME == 'Andrei Grechkin'

-- checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
-- KDEHOME is always defined on personal machines. I need to do something smarter in future
IS_KVM = not (vim.env.KDEHOME and vim.env.KDEHOME ~= '')

require('setup-plugins')

-- vim.cmd('runtime! init/**/*.lua')
-- vim.cmd('runtime! init/**/*.vim')

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
