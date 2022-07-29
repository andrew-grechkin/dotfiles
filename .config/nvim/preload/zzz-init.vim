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
silent! set completeopt=menuone,noinsert,noselect,preview

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
let &showbreak = '--->'                                                        " Pretty soft break character

set autoindent smartindent                                                     " Copy indent from the previous line

set noexpandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
set noshiftround

set formatoptions=tcqjl                                                        " More intuitive autoformatting

"set linebreak                                                                  " Soft word wrap


