" Personal .vimrc file
" Compatible with vim and neovim
" Author: Andrew Grechkin

scriptencoding=utf-8

" => Variables --------------------------------------------------------------------------------------------------- {{{1

let VIM_CONFIG_HOME = '$HOME/.config/nvim'
let VIM_CONFIG_FILE = resolve(expand($MYVIMRC))

" => Company-specific -------------------------------------------------------------------------------------------- {{{1

let PRIVATE_DOMAIN  = 'boo' . 'king'
let &runtimepath.=','.VIM_CONFIG_HOME.'/'.PRIVATE_DOMAIN

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
endif

" => General ----------------------------------------------------------------------------------------------------- {{{1

set autoread                                                                   " Set to auto read when a file is changed from the outside
set autowrite                                                                  " Write the content of the file automatically if you call :make
set fileformats=unix,dos,mac                                                   " Use Unix as the standard file type
set history=10000                                                              " Longest possible command history
set magic
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
runtime plug.vim

" => UI ---------------------------------------------------------------------------------------------------------- {{{1

set scrolloff=5                                                                " Set 5 lines to the cursor - when moving vertically using j/k
set sidescrolloff=5

set wildmenu                                                                   " Enhanced command line completion
"set wildmode=longest:full
set wildignorecase
set wildignore+=*.a,*.o,*.obj,.git,*~,*.pyc,*.so,*.swp,*.zip,*.exe             " Ignore compiled files
set wildignore+=tmp/**,node_modules/**                                         " MacOSX/Linux
" set wildignore+=*/tmp/*,*/node_modules/*                                       " MacOSX/Linux
" set wildignore+=*\\tmp\\*                                                      " Windows

set number                                                                     " Enable numbers
set relativenumber                                                             " Display relative column numbers
set cmdheight=1                                                                " Height of the command bar

set hidden                                                                     " A buffer becomes hidden when it is abandoned

set ignorecase                                                                 " Ignore case when searching
set smartcase                                                                  " When searching try to be smart about cases
set infercase                                                                  " Adjust completions to match case
set hlsearch                                                                   " Highlight search results
set incsearch                                                                  " Move cursor as you type when searching

set lazyredraw                                                                 " Don't redraw while executing macros (good performance config)

set noerrorbells                                                               " No annoying sound on errors
set visualbell

set laststatus=2                                                               " Always show the status line

" => Colors and Fonts -------------------------------------------------------------------------------------------- {{{1

if has('nvim') && exists('+termguicolors')
	set termguicolors
endif

set cursorcolumn cursorline                                                    " Highlight current column

":silent! colorscheme last256
:silent! colorscheme molokai-grand
":silent! colorscheme woju

syntax enable

" => Editor ------------------------------------------------------------------------------------------------------ {{{1

filetype plugin indent on

set complete+=kspell                                                           " Complete from include files and from spell if enabled
set shortmess+=c
set completeopt=menuone,noinsert,noselect,preview

set foldcolumn=2 foldmethod=syntax

set list listchars=tab:↹\ ,trail:␣,extends:>,precedes:<,nbsp:+                 " Visual form of special characters
"set listchars+=eol:↵                                                          " Visible end of line

set showmatch matchpairs+=<:>,«:»

set whichwrap+=<,>,h,l

set display+=lastline                                                          " Prettier display of long lines of text

set virtualedit=block

" => Text, tab and indent related -------------------------------------------------------------------------------- {{{1

silent! set breakindent
set colorcolumn=120                                                            " Break line on 120 characters
let &showbreak = '↳⋙⋙⋙'                                                        " Pretty soft break character

set autoindent smartindent                                                     " Copy indent from the previous line

set noexpandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
set noshiftround

set formatoptions=tcqjl                                                        " More intuitive autoformatting

"set linebreak                                                                  " Soft word wrap

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
