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
pcall(require, 'config')
pcall(require, 'setup-plugins')

-- => Cheat sheet ------------------------------------------------------------------------------------------------- {{{1

-- man: navigation
-- man: operator
-- man: text-objects
-- man: word-motions

-- => Know-How ---------------------------------------------------------------------------------------------------- {{{1

-- "=&rtp                                                                        " read variable to register
-- :verbose set tw? wm?
-- :verbose set formatoptions?
-- :vimfiles                                                                     " Config dir structure
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
