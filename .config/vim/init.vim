" Personal .vimrc file
" Compatible with vim and neovim
" Author: Andrew Grechkin

scriptencoding=utf-8

" => Variables ---------------------------------------------------------------------------------------------------- {{{1

let VIM_CONFIG_FILE = resolve(expand($MYVIMRC))
let VIM_CONFIG_HOME = '$HOME/.config/vim'
let VIM_DATA_HOME = '$HOME/.local/share/vim'

" => Sane defaults ------------------------------------------------------------------------------------------------ {{{1

if has('nvim')
	let VIM_CACHE_HOME = '$HOME/.cache/nvim'
	set inccommand=split

	" move all configs out of $HOME
	let rtp=&runtimepath
	set runtimepath=~/.cache/nvim
	let &runtimepath.=',/etc/xdg/nvim,~/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/share/nvim/runtime,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,~/.local/share/nvim/site/after,/etc/xdg/nvim/after,~/.config/nvim/after,~/.cache/nvim/after,~/.config/vim,~/.config/vim/after'
else
	let VIM_CACHE_HOME = '$HOME/.cache/vim'
	" vint: next-line -ProhibitSetNoCompatible
	set nocompatible                                                           " Disable Vi compatibility

	" move all configs out of $HOME
	let rtp=&runtimepath
	set runtimepath=~/.cache/vim
	let &runtimepath.=','.rtp.',~/.cache/vim/after,~/.config/vim,~/.config/vim/after'
	set viminfo+=n~/.cache/vim/info
	silent! set undodir=~/.cache/vim/undo                                      " Set undodir explicitly for vim

	silent! set langnoremap                                                    " Helps avoid mappings breaking
	silent! set nrformats=bin,hex                                              " <c-a> and <c-x> support
	set ruler                                                                  " Display current line # in a corner
	set showcmd                                                                " Show last command in the status line
	set sidescroll=1                                                           " Smoother sideways scrolling
	set tabpagemax=50                                                          " Maximum number of tabs open by -p flag
	set noesckeys                                                              " Don't wait after pressing ESC in insert mode
	set ttyfast                                                                " Indicates that our connection is fast

	set autoread                                                               " Set to auto read when a file is changed from the outside
endif

" => General ------------------------------------------------------------------------------------------------------ {{{1

set autowrite                                                                  " Write the content of the file automatically if you call :make
set fileformats=unix,dos,mac                                                   " Use Unix as the standard file type
set history=10000                                                              " Longest possible command history
set nobackup noswapfile nowritebackup
set nojoinspaces
set path=.,
set tags+=tags;                                                                " Look for a tags file recursively in parent directories
set pumheight=8                                                                " Maximum height of autocomplete popup window
set undofile                                                                   " Enable persistent undo

set secure

" => Encoding ----------------------------------------------------------------------------------------------------- {{{1

setglobal fileencodings=ucs-bom,utf-8,default,cp1251                           " Order of encodings detection
setglobal encoding=utf-8                                                       " Set utf-8 as default encoding

augroup SetDefaultEncoding
	autocmd!
	autocmd BufNewFile,BufRead * try
	autocmd BufNewFile,BufRead *     setlocal encoding=utf-8
	autocmd BufNewFile,BufRead * endtry
augroup END

augroup SetDefaultBom
	autocmd!
	autocmd BufNewFile *.txt try
	autocmd BufNewFile *.txt     setlocal bomb                                 " Set BOM
	autocmd BufNewFile *.txt endtry
augroup END

" => Copy & paste ------------------------------------------------------------------------------------------------- {{{1

" set clipboard=unnamedplus                                                      " Copy into system clipboard (*, +) registers

" disable indent while inserting from buffer
if !has('nvim')
	let &t_SI .= "\<Esc>[?2004h"
	let &t_EI .= "\<Esc>[?2004l"
	inoremap <special> <expr> <nowait> <Esc>[200~ xterm#begin_paste()
endif

" => Commands ----------------------------------------------------------------------------------------------------- {{{1

command! Force1251 :edit! ++enc=cp1251 | set fileformat=unix | set fileencoding=utf-8
command! Force866  :edit! ++enc=cp866  | set fileformat=unix | set fileencoding=utf-8
command! ForceKoi  :edit! ++enc=koi8-r | set fileformat=unix | set fileencoding=utf-8

if has('nvim')
	command! W :execute ':w suda://%'
else
	command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!           " Save file with root privileges
endif

" => Mouse settings ----------------------------------------------------------------------------------------------- {{{1

if has('mouse')
	set mouse=a
	noremap <S-ScrollWheelUp>          <C-u>
	noremap <S-ScrollWheelDown>        <C-d>
endif

" => Keys remap --------------------------------------------------------------------------------------------------- {{{1

let mapleader = "\<Space>"                                                     " Map leader key

" Easy insertion of a trailing ; or , from insert mode
		imap     ;;                    <Esc>A;<Esc>

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j              (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k              (v:count == 0 ? 'gk' : 'k')

" Select all
silent! nnoremap <C-a>                 gg<S-v>G

":noremap <F12> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

silent! execute "set <M-h>=\<Esc>h"
silent! execute "set <M-j>=\<Esc>j"
silent! execute "set <M-k>=\<Esc>k"
silent! execute "set <M-l>=\<Esc>l"

silent! tnoremap <leader><Esc>         <C-\><C-n>
silent! tnoremap <A-h>                 <C-\><C-n><C-w><Left>
silent! tnoremap <A-j>                 <C-\><C-n><C-w><Down>
silent! tnoremap <A-k>                 <C-\><C-n><C-w><Up>
silent! tnoremap <A-l>                 <C-\><C-n><C-w><Right>
		nnoremap <silent> <M-h>        <C-\><C-n>:TmuxNavigateLeft<CR>
		nnoremap <silent> <M-j>        <C-\><C-n>:TmuxNavigateDown<CR>
		nnoremap <silent> <M-k>        <C-\><C-n>:TmuxNavigateUp<CR>
		nnoremap <silent> <M-l>        <C-\><C-n>:TmuxNavigateRight<CR>
		nnoremap <silent> <M-\>        <C-\><C-n>:TmuxNavigatePrevious<CR>
		inoremap <silent> <M-h>        <C-\><C-n>:TmuxNavigateLeft<CR>
		inoremap <silent> <M-j>        <C-\><C-n>:TmuxNavigateDown<CR>
		inoremap <silent> <M-k>        <C-\><C-n>:TmuxNavigateUp<CR>
		inoremap <silent> <M-l>        <C-\><C-n>:TmuxNavigateRight<CR>

" fast buffers
		nnoremap gh                    :bprevious<CR>
		nnoremap gl                    :bnext<CR>
		nnoremap <leader>b0            :blast<CR>
		nnoremap <leader>b1            :bfirst<CR>
		nnoremap <leader>b2            :b2<CR>

" fast tabs
		nnoremap <leader><leader>t     :tab split<CR>
		nnoremap <leader>h             :tabfirst<CR>
		nnoremap <leader>j             :tabprevious<CR>
		nnoremap <leader>k             :tabnext<CR>
		nnoremap <leader>l             :tablast<CR>
		nnoremap <leader>0             :tablast<CR>
		nnoremap <leader>1             :tabfirst<CR>
		nnoremap <leader>2             :tabnext 2<CR>
		nnoremap <leader>3             :tabnext 3<CR>
		nnoremap <leader>4             :tabnext 4<CR>
		nnoremap <leader>5             :tabnext 5<CR>
		nnoremap <leader>6             :tabnext 6<CR>
		nnoremap <leader>7             :tabnext 7<CR>
		nnoremap <leader>8             :tabnext 8<CR>
		nnoremap <leader>9             :tabnext 9<CR>

		nnoremap <C-PageDown>          :tabnext<CR>
		nnoremap <C-PageUp>            :tabprevious<CR>

" yank without jank: http://ddrscott.github.io/blog/2016/yank-without-jank
		vnoremap  Y                    myY`y
		vnoremap  y                    myy`y

		vnoremap  <leader>Y            my"+Y`y
		vnoremap  <leader>y            my"+y`y

" paste replace visual selection without copying it
		vnoremap  P                    P:let @"=@0<CR>
		vnoremap  p                    p:let @"=@0<CR>

" => Old/new ------------------------------------------------------------------------------------------------------ {{{1

" Open the current file in the default program
		nmap     <leader>x             :!xdg-open %<cr><cr>

" Fast split navigation
silent! nnoremap <leader>'             :belowright vsplit<CR>
silent! nnoremap <leader>"             :belowright split<CR>
silent! tnoremap <leader>'             :belowright vsplit<CR>
silent! tnoremap <leader>"             :belowright split<CR>

" Make Y behave like the other capitals (yank till the end of line)
		nnoremap  Y                    y$

" Black hole deletes
		nnoremap <leader>d             "_d
		vnoremap <leader>dd            "_dd

" Paste replace visual selection without copying it
		vnoremap <leader>P             "_dP

" < and > don't loose selection when changing indentation
		vnoremap <                     <gv
		vnoremap >                     >gv

" center after operations
		nnoremap n                     nzzzv
		nnoremap N                     Nzzzv
		nnoremap J                     mzJ`z

" Clear current search highlighting
		nnoremap <leader><leader>l     :nohlsearch<CR>

" Open terminal
		nnoremap <leader><leader>m     :belowright 10split term://zsh<CR>

		nnoremap <leader>.             :execute 'lcd' dir#git_root()<CR>
"		nnoremap <leader>.             :lcd %:p:h<CR>

" => Bookmarks ---------------------------------------------------------------------------------------------------- {{{1

		nnoremap <leader><leader>v     :tabedit <C-R>=VIM_CONFIG_FILE<CR><CR>
		nnoremap <leader><leader>z     :tabedit ~/.zshenv<CR>

" => vimdiff ------------------------------------------------------------------------------------------------------ {{{1

set diffopt+=iwhite,vertical,context:3
silent! set diffopt+=algorithm:patience,indent-heuristic
if &diff
	augroup diff_only_configs
		autocmd!
		let s:is_started_as_vim_diff = 1
		setlocal nospell
		setlocal cmdheight=2                                                   " Increase lower status bar height in diff mode
		nnoremap <leader>n             ]czz
		nnoremap <leader>p             [czz
		nnoremap <leader>u             :diffupdate<CR>
		nnoremap <leader>a             :call diff#toggle_algorithm()<CR>
		nnoremap <leader>i             :call diff#toggle_ignore_whitespace()<CR>

		nnoremap <Left>                <C-W><Left>
"		nnoremap <Down>                ]czz
"		nnoremap <Up>                  [czz
		nnoremap <Right>               <C-w><Right>
	augroup END
else
	augroup save_restore_folds                                                 " save and restore folds only in non-diff mode
		autocmd!
		autocmd BufWinEnter * silent! loadview
		autocmd BufWinLeave * silent! mkview
	augroup END
endif

" => Automation --------------------------------------------------------------------------------------------------- {{{1

cnoreabbrev waq wqa

augroup save_restore_position
	autocmd!
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
augroup END

augroup DetectFileUpdated
	autocmd!
	autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * silent! checktime
augroup END

augroup SettingsByFileType
	autocmd!
	autocmd FileType *           setlocal textwidth=120 wrapmargin=0
	autocmd FileType qf,help,man setlocal nobuflisted | nnoremap <silent> <buffer> <nowait> q :bwipeout!<CR>
	autocmd FileType Run         setlocal nobuflisted | nnoremap <silent> <buffer> <nowait> q :bwipeout!<CR>
augroup END

augroup SettingsByBufType
	autocmd!
	if has('nvim-0.5')
		autocmd TermEnter * setlocal scrolloff=0
	endif
	autocmd BufEnter * if (winnr('$') == 1 && (&buftype ==# 'quickfix' || &buftype ==# 'loclist')) | bd | endif
	autocmd BufEnter * if (
			\ &buftype ==# 'nofile' ||
			\ &buftype ==# 'loclist') |
			\ nnoremap <silent> <buffer> q :bwipeout<CR> |
		\ endif
augroup END

augroup pre_post_process
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
	autocmd BufWritePost .config/nvim/colors/molokai-grand.vim source .config/nvim/colors/molokai-grand.vim
	""" Remove all trailing whitespaces (ALE does this better)
"	autocmd BufWritePre  *        :%s/\s\+$//e
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

" => Spelling ----------------------------------------------------------------------------------------------------- {{{1
" man: spell

set spelllang=en,nl,ru

nnoremap <leader><leader>s :set spell!<CR>

" => Debugger ----------------------------------------------------------------------------------------------------- {{{1

silent! packadd termdebug

" => vim-plug plugins --------------------------------------------------------------------------------------------- {{{1

let g:airline_highlighting_cache = 1
let g:ale_completion_enabled     = 0

""" necessary for UltiSnips
let g:ale_lint_on_enter            = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave     = 0
let g:ale_lint_on_text_changed     = 0

let g:man_hardwrap = 1

" let g:loaded_netrw             = 1                                             " Disable netrw (spellcheck unable to download files)
" let g:loaded_netrwPlugin       = 1
" let g:loaded_netrwSettings     = 1
" let g:loaded_netrwFileHandlers = 1

" man: ft-perl-syntax
let perl_fold                  = 1
let perl_include_pod           = 0
let perl_no_extended_vars      = 1
let perl_no_scope_in_variables = 1
let perl_nofold_packages       = 1

let g:loaded_python_provider = 0

let g:signify_vcs_cmds = {
	\ 'git': 'git diff --no-color --no-ext-diff -U0 --ignore-space-change -- %f',
\ }

let g:tmux_navigator_no_mappings = 1

let g:UltiSnipsExpandTrigger       = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsListSnippets        = '<C-l>'

let g:vimwiki_table_mappings = 0
let g:vimwiki_list           = [
	\ {'path': '~/.local/share/wiki', 'syntax': 'markdown', 'ext': '.md'},
\]

let VIM_PLUG_URL      = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let VIM_PLUG_DOWNLOAD = ':silent !curl -sfLo ' . VIM_CACHE_HOME . '/autoload/plug.vim --create-dirs ' . VIM_PLUG_URL

if empty(glob(VIM_CACHE_HOME . '/autoload/plug.vim'))                          " Download and install vim-plug
	" execute VIM_CREATE_DIR
	execute VIM_PLUG_DOWNLOAD
	augroup InstallPlugins
		autocmd!
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	augroup END
endif

runtime! plug.vim

" => UI ----------------------------------------------------------------------------------------------------------- {{{1

set scrolloff=5                                                                " Set 5 lines to the cursor - when moving vertically using j/k
set sidescrolloff=5

set wildmenu                                                                   " Enhanced command line completion
set wildignorecase
set wildignore+=*.a,*.o,*.obj,.git,*~,*.pyc,*.so,*.swp,*.zip,*.exe             " Ignore compiled files
set wildignore+=tmp/**,node_modules/**                                         " MacOSX/Linux

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

" => Colors and Fonts --------------------------------------------------------------------------------------------- {{{1

if has('nvim') && exists('+termguicolors')
	set termguicolors
endif

set cursorcolumn cursorline                                                    " Highlight current column

:silent! colorscheme molokai-grand

syntax enable

" => Editor ------------------------------------------------------------------------------------------------------- {{{1

filetype plugin indent on

set splitright
set complete+=kspell                                                           " Complete from include files and from spell if enabled
set shortmess+=c
silent! set completeopt=menuone,noinsert,noselect,preview

set foldcolumn=2
" set foldmethod=syntax

set list listchars=tab:↹\ ,trail:␣,extends:>,precedes:<,nbsp:+                 " Visual form of special characters

set showmatch matchpairs+=<:>,«:»

set whichwrap+=<,>,h,l

set display+=lastline                                                          " Prettier display of long lines of text

set virtualedit=block

" => Text, tab and indent related --------------------------------------------------------------------------------- {{{1

silent! set breakindent
set colorcolumn=121                                                            " Break line on 120 characters
let &showbreak = '--->'                                                        " Pretty soft break character

set autoindent smartindent                                                     " Copy indent from the previous line

set noexpandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
set noshiftround

set formatoptions=tcqjl                                                        " More intuitive autoformatting

"set linebreak                                                                  " Soft word wrap

" => Cheat sheet -------------------------------------------------------------------------------------------------- {{{1

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

" => Know-How ----------------------------------------------------------------------------------------------------- {{{1

":verbose set tw? wm?
":verbose set formatoptions?
":vimfiles                                                                     " Config dir structure
":scriptnames
":help -V                                                                      " Trace all vim open files
":help filetype-overrule
"vim --startuptime vim.log
"vim --cmd 'profile start vimrc.profile' --cmd 'profile! file /home/agrechkin/.config/vim/init.vim'

" dump all globals
" :redir > variables.vim
" :let g:
" :redir END
" :n variables.vim
