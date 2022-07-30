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

if has('nvim') && exists('+termguicolors')
	set termguicolors
endif

set cursorcolumn cursorline                                                    " Highlight current column

"colorscheme last256
colorscheme molokai-grand
"colorscheme woju

" syntax enable
