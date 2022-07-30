-- Compatible with neovim only
-- Author: Andrew Grechkin
vim.cmd('runtime! init/**/*.lua')
vim.cmd('runtime! init/**/*.vim')

-- => Cheat sheet ------------------------------------------------------------------------------------------------ {{{1

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

-- => Know-How --------------------------------------------------------------------------------------------------- {{{1

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
