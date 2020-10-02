" Personal .vimrc file
" Compatible with vim and neovim
" Author: Andrew Grechkin
"
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

scriptencoding=utf-8

" => Variables --------------------------------------------------------------------------------------------------- {{{1

let VIM_CONFIG_HOME = '$HOME/.config/nvim'
let PRIVATE_DOMAIN  = 'book' . 'ing'
let VIM_CONFIG_FILE = resolve(expand($MYVIMRC))

if has('nvim')
	let VIM_CACHE_HOME = '$HOME/.config/nvim'
else
	let VIM_CACHE_HOME = '$HOME/.cache/vim'
endif

" => Company-specific -------------------------------------------------------------------------------------------- {{{1

let &runtimepath.=','.VIM_CACHE_HOME.'/'.PRIVATE_DOMAIN

" => Sane defaults ----------------------------------------------------------------------------------------------- {{{1

if has('nvim')
	set inccommand=split
	command! W :execute ':w suda://%'
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
"	set shortmess=F                                                            " Less verbose file info
	set showcmd                                                                " Show last command in the status line
	set sidescroll=1                                                           " Smoother sideways scrolling
	set tabpagemax=50                                                          " Maximum number of tabs open by -p flag
	set noesckeys                                                              " Don't wait after pressing ESC in insert mode
	set ttyfast                                                                " Indicates that our connection is fast
	command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!           " Save file with root privileges
endif

" => Preload ----------------------------------------------------------------------------------------------------- {{{1

let g:man_hardwrap = 1

" let g:loaded_netrw             = 1                                             " Disable netrw (spellcheck unable to download files)
" let g:loaded_netrwPlugin       = 1
" let g:loaded_netrwSettings     = 1
" let g:loaded_netrwFileHandlers = 1

" man: ft-perl-syntax
let perl_include_pod           = 0
let perl_no_scope_in_variables = 1
let perl_no_extended_vars      = 1
let perl_fold                  = 1
let perl_nofold_packages       = 1

let g:tmux_navigator_no_mappings = 1

let VIM_PLUG_URL      = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let VIM_CREATE_DIR    = ':silent !mkdir -p '. VIM_CACHE_HOME . '/autoload'
let VIM_PLUG_DOWNLOAD = ':silent !curl -sfLo ' . VIM_CACHE_HOME . '/autoload/plug.vim ' . VIM_PLUG_URL

if empty(glob(VIM_CACHE_HOME . '/autoload/plug.vim'))                          " Download and install vim-plug
	execute VIM_CREATE_DIR
	execute VIM_PLUG_DOWNLOAD
	augroup InstallPlugins
		autocmd!
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	augroup END
endif

" => General ----------------------------------------------------------------------------------------------------- {{{1

let mapleader = "\<Space>"                                                     " Map leader key

set autoread                                                                   " Set to auto read when a file is changed from the outside
augroup DetectFileUpdated
	autocmd!
	autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * silent! checktime
augroup END

set autowrite                                                                  " Write the content of the file automatically if you call :make
set fileformats=unix,dos,mac                                                   " Use Unix as the standard file type
set history=10000                                                              " Longest possible command history
set magic
set nobackup noswapfile nowritebackup
set path=.,
set tags+=tags;                                                                " Look for a tags file recursively in parent directories
set pumheight=8                                                                " Maximum height of autocomplete popup window
set undofile                                                                   " Enable persistent undo

" set exrc
set secure

" => Encodings --------------------------------------------------------------------------------------------------- {{{1

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

" => vim-plug plugins -------------------------------------------------------------------------------------------- {{{1

call plug#begin('~/.cache/vim/plugged')
	Plug 'junegunn/vim-plug'
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'tpope/vim-abolish'
	Plug 'tpope/vim-fugitive'                                                  " Git support
	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-surround'                                                  " Better surround commands
	Plug 'tpope/vim-unimpaired'                                                " Pairs of helpful commands
"	Plug 'tpope/vim-commentary'                                                " Commenting helpers
"	Plug 'tomtom/tcomment_vim'                                                 " Commenting helpers
	Plug 'scrooloose/nerdcommenter', {'on': '<Plug>NERDCommenterToggle'}       " Commenting helpers
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
	Plug 'mhinz/vim-grepper'                                                   " Grep integration
	Plug 'nelstrom/vim-visual-star-search'
	Plug 'andrew-grechkin/vim-rooter'                                          " Cwd if file is in git repo should be repo root
	Plug 'vim-airline/vim-airline'                                             " Most informative status line
"	Plug 'vim-airline/vim-airline-themes'                                      " Status line themes
	Plug 'rodjek/vim-puppet'                                                   " For Puppet syntax highlighting
	Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                                  " For Facts, Ruby functions, and custom providers
	Plug 'vifm/vifm.vim'
"	Plug '~/.local/share/vim-plug/trackperlvars', {'for': 'perl'}
"	Plug '~/.local/share/vim-plug/perlart',       {'for': 'perl'}
	if has('nvim-0.4') && has('python3')
		let g:ale_completion_enabled = 0
		let g:ycm_collect_identifiers_from_comments_and_strings = 1
		let g:ycm_collect_identifiers_from_tags_files           = 1
		let g:ycm_seed_identifiers_with_syntax                  = 1
"		Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-libclang'}
		Plug 'Valloric/YouCompleteMe', {'do': './install.py --clangd-completer'}
	else
		let g:ale_completion_enabled = 1
	endif
	if has('nvim') || v:version >= 800                                         " These plugins demand modern vim or neovim
		Plug 'dense-analysis/ale'                                              " Async syntax checker
		Plug 'unblevable/quick-scope'
		Plug 'easymotion/vim-easymotion'                                       " Better move commands
		Plug 'ervandew/supertab'
		Plug 'junegunn/vim-peekaboo'                                           " Preview registers
		Plug 'lambdalisue/suda.vim'                                            " run sudo from vim
		" Plug 'majutsushi/tagbar'
		Plug 'mhinz/vim-startify'
		Plug 'pedrohdz/vim-yaml-folds'
		Plug 'mhinz/vim-signify'                                               " Git status/modifications of the file
		""" necessary for UltiSnips
		let g:ale_lint_on_enter            = 0
		let g:ale_lint_on_filetype_changed = 0
		let g:ale_lint_on_text_changed     = 0
		let g:ale_lint_on_insert_leave     = 0
		""" Trigger configuration. Using <tab> here together with YouCompleteMe works because of 'supertab' plugin
		let g:UltiSnipsExpandTrigger       = '<tab>'
		let g:UltiSnipsListSnippets        = '<A-Space>'
		let g:UltiSnipsJumpForwardTrigger  = '<tab>'
		let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
		Plug 'SirVer/ultisnips'
		Plug 'andrew-grechkin/vim-snippets'
	endif
	if has('nvim')                                                             " These plugins demand neovim
		Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFPrompt','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
		Plug 'janko/vim-test'
		Plug 'sbdchd/vim-run'
		Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}                   " Visualize the undo tree
	endif
	""" checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
	""" KDEHOME is always defined on personal machines. I need to do something smarter in future
	if empty($KDEHOME)                                                         " Install these pluggins only at work remote machines
		Plug 'junegunn/fzf', {'dir': '~/.cache/fzf', 'do': './install --bin'}
	else                                                                       " Install these pluggins only on personal machines
		Plug 'inkarkat/vim-localrc'
		Plug 'masukomi/vim-markdown-folding'
		Plug 'mgrabovsky/vim-cuesheet'
		Plug 'pearofducks/ansible-vim'
		Plug 'ryanoasis/vim-devicons'
		Plug 'shumphrey/fugitive-gitlab.vim'                                   " fugitive Gitlab module
		Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                          " Vim plugin for .tmux.conf
		Plug 'tpope/vim-rhubarb'                                               " fugitive Github module
	endif
" 	if 0                                                                       " These plugins are disabled
" 		Plug 'fatih/vim-go', {'for': 'go'}
" 		Plug 'vimwiki/vimwiki'                                                 " Personal wiki
" 		Plug 'chrisbra/csv.vim'
" 		Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
" 		Plug 'flazz/vim-colorschemes'                                          " Huge set of color schemes
" 		Plug 'vim-scripts/ScrollColors', {'on': 'SCROLL'}                      " Scroll through color schemes
" 		Plug 'itchyny/lightline.vim'
" 		Plug 'jceb/vim-hier'
" 		Plug 'mhinz/vim-grepper', {'on': ['Grepper', '<Plug>(GrepperOperator)']} " Grep integration
" 		Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}             " Language Server support
" 		Plug 'samoshkin/vim-mergetool'
" 		Plug 'tpope/vim-vinegar'
" 		Plug 'vim-vdebug/vdebug'
" 		Plug 'xolox/vim-misc'
" 		Plug 'xolox/vim-easytags'
" 		Plug 'jiangmiao/auto-pairs'
" 		" perl autocomplete (not working properly)
" 		Plug 'chumakd/perlomni.vim'
" 		Plug 'Shougo/deoplete.nvim'
" 		Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}
" 	endif
call plug#end()

"packloadall                                                                    " Load all plugins
"silent! helptags ALL                                                           " Load help files for all plugins

" => UI ---------------------------------------------------------------------------------------------------------- {{{1

set scrolloff=5                                                                " Set 5 lines to the cursor - when moving vertically using j/k

set wildmenu                                                                   " Enhanced command line completion
"set wildmode=longest:full
set wildignorecase
set wildignore+=*.a,*.o,*~,*.pyc,*.so,*.swp,*.zip,*.exe                        " Ignore compiled files
set wildignore+=*/tmp/*,*/node_modules/*                                       " MacOSX/Linux
set wildignore+=*\\tmp\\*                                                      " Windows

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

" set termguicolors
set cursorcolumn cursorline                                                    " Highlight current column

":silent! colorscheme last256
:silent! colorscheme molokai
":silent! colorscheme woju

syntax enable

" => Editor ------------------------------------------------------------------------------------------------------ {{{1

filetype plugin indent on

set complete+=kspell                                                           " Complete from include files and from spell if enabled

set foldcolumn=2 foldmethod=syntax

set list listchars=tab:↹\ ,trail:␣,extends:>,precedes:<,nbsp:+                 " Visual form of special characters
"set listchars+=eol:↵                                                          " Visible end of line

set showmatch matchpairs+=<:>,«:»

set whichwrap+=<,>,h,l

set display+=lastline                                                          " Prettier display of long lines of text

set virtualedit=block

" => Spell ------------------------------------------------------------------------------------------------------- {{{1
" man: spell

set spelllang=en,nl,ru

nnoremap <leader><leader>s :set spell!<CR>

" => Text, tab and indent related -------------------------------------------------------------------------------- {{{1

silent! set breakindent
set colorcolumn=120                                                            " Break line on 120 characters
let &showbreak = '↳⋙⋙⋙'                                                        " Pretty soft break character

set autoindent smartindent                                                     " Copy indent from the previous line

set noexpandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
set noshiftround

set formatoptions=tcqj                                                         " More intuitive autoformatting

"set linebreak                                                                  " Soft word wrap

" => Copy & paste ------------------------------------------------------------------------------------------------ {{{1

set clipboard=unnamed,unnamedplus                                              " Copy into system clipboard (*, +) registers

"vnoremap <C-c>                         "*y :let @+=@*<CR>
"vmap <C-c>                             y
"vmap <C-x>                             c<ESC>
"vmap <C-v>                             "0c<ESC>p
"imap <C-v>                             <C-r><C-o>+

" disable indent while inserting from buffer
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ xterm#begin_paste()

" => Keys remap -------------------------------------------------------------------------------------------------- {{{1

":noremap <F12> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Fast split navigation
silent! nnoremap <leader>'             :belowright vsplit<CR>
silent! nnoremap <leader>"             :belowright split<CR>
silent! tnoremap <leader>'             :belowright vsplit<CR>
silent! tnoremap <leader>"             :belowright split<CR>

silent! tnoremap <leader><Esc>         <C-\><C-N>
silent! tnoremap <A-h>                 <C-\><C-N><C-w><Left>
silent! tnoremap <A-j>                 <C-\><C-N><C-w><Down>
silent! tnoremap <A-k>                 <C-\><C-N><C-w><Up>
silent! tnoremap <A-l>                 <C-\><C-N><C-w><Right>
" silent! tnoremap <C-h>                 <C-\><C-N><C-w><Left>
" silent! tnoremap <C-j>                 <C-\><C-N><C-w><Down>
" silent! tnoremap <C-k>                 <C-\><C-N><C-w><Up>
" silent! tnoremap <C-l>                 <C-\><C-N><C-w><Right>
" 		inoremap <A-h>                 <C-\><C-N><C-w><Left>
" 		inoremap <A-j>                 <C-\><C-N><C-w><Down>
" 		inoremap <A-k>                 <C-\><C-N><C-w><Up>
" 		inoremap <A-l>                 <C-\><C-N><C-w><Right>
" 		noremap  <A-h>                 <C-w><Left>
" 		noremap  <A-j>                 <C-w><Down>
" 		noremap  <A-k>                 <C-w><Up>
" 		noremap  <A-l>                 <C-w><Right>
		nnoremap <silent> <A-h>        :TmuxNavigateLeft<CR>
		nnoremap <silent> <A-j>        :TmuxNavigateDown<CR>
		nnoremap <silent> <A-k>        :TmuxNavigateUp<CR>
		nnoremap <silent> <A-l>        :TmuxNavigateRight<CR>
		nnoremap <silent> <A-\>        :TmuxNavigatePrevious<CR>
		inoremap <silent> <A-h>        :TmuxNavigateLeft<CR>
		inoremap <silent> <A-j>        :TmuxNavigateDown<CR>
		inoremap <silent> <A-k>        :TmuxNavigateUp<CR>
		inoremap <silent> <A-l>        :TmuxNavigateRight<CR>

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

" Black hole deletes
		nnoremap <leader>d             "_d
		vnoremap <leader>dd            "_dd

" < and > don't loose selection when changing indentation
		vnoremap >                     >gv
		vnoremap <                     <gv

" Clear current search highlighting
		nnoremap <leader><leader>l     :nohlsearch<CR>

" Open terminal
		nnoremap <leader><leader>m     :belowright 10split term://zsh<CR>

" => Bookmarks --------------------------------------------------------------------------------------------------- {{{1

		nnoremap <leader><leader>v     :tabedit <C-R>=VIM_CONFIG_FILE<CR><CR>
		nnoremap <leader><leader>z     :tabedit ~/.zshenv<CR>

" => Mouse settings ---------------------------------------------------------------------------------------------- {{{1

if has('mouse')
	set mouse=a
"	noremap <ScrollWheelUp>            <C-Y>
"	noremap <ScrollWheelDown>          <C-E>
	noremap <S-ScrollWheelUp>          <C-U>
	noremap <S-ScrollWheelDown>        <C-D>
endif

" => vimdiff ----------------------------------------------------------------------------------------------------- {{{1

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

"		hi DiffAdd    ctermfg=233   ctermbg=LightGreen guifg=#003300 guibg=#DDFFDD gui=none cterm=none
"		hi DiffChange ctermbg=white                                  guibg=#ececec gui=none cterm=none
"		hi DiffText   ctermfg=233   ctermbg=yellow     guifg=#000033 guibg=#DDDDFF gui=none cterm=none
	augroup END
else
	augroup save_restore_folds                                                 " save and restore folds only in non-diff mode
		autocmd!
		autocmd BufWinEnter * silent! loadview
		autocmd BufWinLeave * silent! mkview
	augroup END
endif

" => Automatization ---------------------------------------------------------------------------------------------- {{{1

augroup SettingsByFileType
	autocmd!
	autocmd FileType *           setlocal textwidth=120 wrapmargin=0
	autocmd FileType qf,help,man setlocal nobuflisted | nnoremap <silent> <buffer> q :bwipeout<CR>
	autocmd FileType Run         setlocal nobuflisted | nnoremap <silent> <buffer> q :bwipeout!<CR>
augroup END

augroup SettingsByBufType
	autocmd!
	autocmd BufEnter * if (winnr('$') == 1 && (&buftype ==# 'quickfix' || &buftype ==# 'loclist')) | bd | endif
	autocmd BufEnter * if (
			\ &buftype ==# 'nofile' ||
			\ &buftype ==# 'loclist') |
			\ nnoremap <silent> <buffer> q :bwipeout<CR> |
		\ endif
augroup END

"augroup save_restore_position
"	autocmd!
"	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
"augroup END

augroup pre_post_process
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
	""" Remove all trailing whitespaces (ALE does this better)
"	autocmd BufWritePre  *        :%s/\s\+$//e
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

augroup AutoGzipForNonstandardExtensions
	autocmd!
"	Enable editing of gzipped files
"	The functions are defined in autoload/gzip.vim
"	Set binary mode before reading the file
"	Use "gzip -d", gunzip isn't always available
	autocmd BufReadPre,FileReadPre     *.dsl.dz,*.dict.dz setlocal bin
	autocmd BufReadPost,FileReadPost   *.dsl.dz,*.dict.dz call     gzip#read("gzip -dn -S .dz")
	autocmd BufWritePost,FileWritePost *.dsl.dz,*.dict.dz call     gzip#write("gzip -S .dz")
	autocmd FileAppendPre              *.dsl.dz,*.dict.dz call     gzip#appre("gzip -dn -S .dz")
	autocmd FileAppendPost             *.dsl.dz,*.dict.dz call     gzip#write("gzip -S .dz")
augroup END

"let ssh_client=$SSH_CLIENT
"if ssh_client != ''
"	" Automatically call OSC52 function on yank to sync register with host clipboard
"	augroup Yank
"		autocmd!
"		autocmd TextYankPost * if v:event.operator ==# 'y' | call xterm#yank_osc52() | endif
"	augroup END
"endif

" => Debugger ---------------------------------------------------------------------------------------------------- {{{1

silent! packadd termdebug

" => Know-How ---------------------------------------------------------------------------------------------------- {{{1

":verbose set tw? wm?
":verbose set formatoptions?
":scriptnames
":help -V                                                                      " Trace all vim open files
":help filetype-overrule
"vim --startuptime vim.log
"vim --cmd 'profile start vimrc.profile' --cmd 'profile! file /home/agrechkin/.config/nvim/init.vim'
