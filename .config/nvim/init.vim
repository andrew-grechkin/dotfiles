" Personal .vimrc file
" Compatible with vim and neovim
" Author: Andrew Grechkin

scriptencoding=utf-8

" => Variables --------------------------------------------------------------------------------------------------- {{{1

let VIM_CONFIG_HOME = '$HOME/.config/nvim'
let VIM_CONFIG_FILE = resolve(expand($MYVIMRC))

" => Company-specific -------------------------------------------------------------------------------------------- {{{1

let PRIVATE_DOMAIN  = 'boo' . 'king'
"let &runtimepath.=','.VIM_CONFIG_HOME.'/'.PRIVATE_DOMAIN

" => Sane defaults ----------------------------------------------------------------------------------------------- {{{1

if has('nvim')
	set inccommand=split
else
	" vint: next-line -ProhibitSetNoCompatible
	set nocompatible                                                           " Disable Vi compatibility

	" move all configs out of $HOME
	let rtp=&runtimepath
	set runtimepath=~/.cache/vim
	let &runtimepath.=','.rtp.',~/.cache/vim/after,~/.config/nvim,~/.config/nvim/after'
	set viminfo+=n~/.cache/vim/info
	silent! set undodir=~/.cache/vim/undo                                      " Set undodir explicitly for vim

"	set belloff=all                                                            " Disable the bell
"	set cscopeverbose                                                          " Verbose cscope output
"	set display=lastline,msgsep                                                " Display more message text
"	set fillchars=vert:|,fold:                                                 " Separator characters
"	set fsync                                                                  " Call fsync() for robust file saving
	silent! set langnoremap                                                    " Helps avoid mappings breaking
	silent! set nrformats=bin,hex                                              " <c-a> and <c-x> support
	set ruler                                                                  " Display current line # in a corner
"	set sessionoptions-=options                                                " Do not carry options across sessions
	set showcmd                                                                " Show last command in the status line
	set sidescroll=1                                                           " Smoother sideways scrolling
	set tabpagemax=50                                                          " Maximum number of tabs open by -p flag
	set noesckeys                                                              " Don't wait after pressing ESC in insert mode
	set ttyfast                                                                " Indicates that our connection is fast

	set autoread                                                               " Set to auto read when a file is changed from the outside
endif

" => General ----------------------------------------------------------------------------------------------------- {{{1

set autowrite                                                                  " Write the content of the file automatically if you call :make
set fileformats=unix,dos,mac                                                   " Use Unix as the standard file type
set history=10000                                                              " Longest possible command history
set nobackup noswapfile nowritebackup
set nojoinspaces
set path=.,
set tags+=tags;                                                                " Look for a tags file recursively in parent directories
set pumheight=8                                                                " Maximum height of autocomplete popup window
set undofile                                                                   " Enable persistent undo

" set exrc
set secure

" => Load configuration ------------------------------------------------------------------------------------------ {{{1

runtime! config/*.vim

" => vim-plug plugins -------------------------------------------------------------------------------------------- {{{1

runtime! preload/*.vim

" => Cheat sheet ------------------------------------------------------------------------------------------------- {{{1

"                  gg
"                  ?
"                  ^b
"                  H
"                  {
"                  k
" 0 ^ F T ( b ge h M l w e ) t f $
"                  j
"                  }
"                  L
"                  ^f
"                  /
"                  G
"
"man: navigation
"man: operator
"man: text-objects
"man: word-motions

" => Know-How ---------------------------------------------------------------------------------------------------- {{{1

" "=&rtp                                                                       " read variable to register 
":verbose set tw? wm?
":verbose set formatoptions?
":vimfiles                                                                     " Config folder structure
":scriptnames
":help -V                                                                      " Trace all vim open files
":help filetype-overrule
"vim --startuptime vim.log
"vim --cmd 'profile start vimrc.profile' --cmd 'profile! file /home/agrechkin/.config/nvim/init.vim'

" dump all globals
" :redir > variables.vim
" :let g:
" :redir END
" :n variables.vim
