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

" => Variables --------------------------------------------------------------------------------------------------- {{{1

let VIM_CONFIG_HOME = '$HOME/.config/nvim'
let PRIVATE_DOMAIN  = 'book' . 'ing'

if has('nvim')
	let VIM_CACHE_HOME = '$HOME/.config/nvim'
else
	let VIM_CACHE_HOME = '$HOME/.cache/vim'
endif
let VIM_CONFIG_FILE = resolve(expand($MYVIMRC))

" => Sane defaults ----------------------------------------------------------------------------------------------- {{{1

if has('nvim')
	set inccommand=split
	command! W :execute ':w suda://%'
else
	set nocompatible                                                           " Disable Vi compatibility

	" move all configs out of $HOME
	let rtp=&runtimepath
	set runtimepath=~/.cache/vim
	let &runtimepath.=','.rtp.',~/.cache/vim/after'
	set viminfo+=n~/.cache/vim/info
	silent! set undodir=~/.cache/vim/undo                                      " Set undodir explicitly for vim

"	set belloff=all                                                            " Disable the bell
"	set cscopeverbose                                                          " Verbose cscope output
"	set complete-=i                                                            " Don't scan current on included files for completion
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

" => Pre-load ---------------------------------------------------------------------------------------------------- {{{1

let VIM_PLUG_URL        = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let VIM_CREATE_DIR      = ':silent !mkdir -p '. VIM_CACHE_HOME . '/autoload'
let VIM_PLUG_DOWNLOAD   = ':silent !curl -sfLo ' . VIM_CACHE_HOME . '/autoload/plug.vim ' . VIM_PLUG_URL

if empty(glob(VIM_CACHE_HOME . '/autoload/plug.vim'))                         " Download and install vim-plug
	execute VIM_CREATE_DIR
	execute VIM_PLUG_DOWNLOAD
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" => General ----------------------------------------------------------------------------------------------------- {{{1

let mapleader = "\<Space>"                                                     " Map leader key

" Set to auto read when a file is changed from the outside
set autoread | autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * silent! checktime

"set autochdir
set autowrite                                                                  " Write the content of the file automatically if you call :make
set ffs=unix,dos,mac                                                           " Use Unix as the standard file type
set history=10000                                                              " Longest possible command history
set magic
set nobackup
set noswapfile
set nowritebackup
set path=.,**,/usr/include/**
set tags+=tags;                                                                " Look for a tags file recursively in parent directories
set pumheight=8                                                                " Maximum height of autocomplete popup window

silent! set undofile                                                           " Save persistent undo    " Enable persistent undo


" => Encodings --------------------------------------------------------------------------------------------------- {{{1

setglobal fileencodings=ucs-bom,utf-8,default,cp1251
setglobal encoding=utf-8                                                       " Set utf8 as standard encoding

augroup SetDefaultEncoding
	autocmd!
	autocmd BufNewFile,BufRead  * try
	autocmd BufNewFile,BufRead  *     set encoding=utf-8
	autocmd BufNewFile,BufRead  * endtry
augroup END

augroup SetDefaultBom
	autocmd!
	autocmd BufNewFile *.txt try
	autocmd BufNewFile *.txt     set bomb                                      " Set BOM
	autocmd BufNewFile *.txt endtry
augroup END

" => vim-plug plugins (~/.config/nvim/plugins.vim) --------------------------------------------------------------- {{{1

if !empty(glob(VIM_CONFIG_HOME . '/plugins.' . PRIVATE_DOMAIN . '.vim'))
	exec 'source ' . VIM_CONFIG_HOME . '/plugins.' . PRIVATE_DOMAIN . '.vim'
else
	exec 'source ' . VIM_CONFIG_HOME . '/plugins.vim'
endif

"packloadall                                                                    " Load all plugins
"silent! helptags ALL                                                           " Load help files for all plugins

" => UI ---------------------------------------------------------------------------------------------------------- {{{1

set scrolloff=5                                                                " Set 5 lines to the cursor - when moving vertically using j/k

set wildmenu                                                                   " Enhanced command line completion
"set wildmode=longest:full
set wildignorecase
set wildignore+=*.o,*~,*.pyc,*.so,*.swp,*.zip,*.exe                            " Ignore compiled files
set wildignore+=*/tmp/*                                                        " MacOSX/Linux
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

syntax enable                                                                  " Enable syntax highlighting

":silent! colorscheme last256
:silent! colorscheme molokai
":silent! colorscheme woju

set cursorcolumn                                                               " Highlight current column
set cursorline

" => Editor ------------------------------------------------------------------------------------------------------ {{{1

filetype plugin indent on                                                      " Mandatory for modern plugins

set foldcolumn=2
set foldmethod=syntax
set foldnestmax=2

set list                                                                       " Show special characters
set listchars=tab:↹\ ,trail:␣,extends:>,precedes:<,nbsp:+                      " Visual form of special characters
"set listchars+=eol:↵                                                          " Visible end of line

set showmatch                                                                  " Show matching brackets when text indicator is over them
set matchpairs+=<:>,«:»

set whichwrap+=<,>,h,l

set display+=lastline                                                          " Prettier display of long lines of text

set virtualedit=block

" => Spell ------------------------------------------------------------------------------------------------------- {{{1
" man: spell

set spelllang=en,nl,ru

" => Text, tab and indent related -------------------------------------------------------------------------------- {{{1

silent! set breakindent
set colorcolumn=120                                                            " Linebreak on 120 characters
let &showbreak = '↳⋙⋙⋙'                                                        " Pretty soft break character

set autoindent                                                                 " Copy indent from the previous line
set smartindent

set noexpandtab                                                                " Never use spaces instead of tabs
set smarttab                                                                   " Tab setting aware <Tab> key
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4

set formatoptions=tcqj                                                         " More intuitive autoformatting

"set nowrap                                                                     " No wrap lines
"set linebreak                                                                  " Soft word wrap

" => Copy & paste ------------------------------------------------------------------------------------------------ {{{1

set clipboard=unnamed,unnamedplus                                              " Copy into system clipboard (*, +) registers

"vnoremap <C-c>                         "*y :let @+=@*<CR>
vmap <C-c>                             y
vmap <C-x>                             c<ESC>
vmap <C-v>                             "0c<ESC>p
"imap <C-v>                             <C-r><C-o>+

" disable indent while inserting from buffer
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
	set pastetoggle=<Esc>[201~
	set paste
	return ""
endfunction

" => Custom commands --------------------------------------------------------------------------------------------- {{{1

" => Keys remap -------------------------------------------------------------------------------------------------- {{{1

":noremap <F12> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Fast quit
"		nnoremap <leader>q             :quitall<CR>

" Fast split navigation
silent! nnoremap <leader>'             :belowright vsplit<CR>
silent! nnoremap <leader>"             :belowright split<CR>
silent! tnoremap <leader>'             :belowright vsplit<CR>
silent! tnoremap <leader>"             :belowright split<CR>

" Double quote selection
"		vnoremap <leader>"             c"<c-r>""<ESC>

silent! tnoremap <leader><Esc>         <C-\><C-N>
silent! tnoremap <A-h>                 <C-\><C-N><C-w><Left>
silent! tnoremap <A-j>                 <C-\><C-N><C-w><Down>
silent! tnoremap <A-k>                 <C-\><C-N><C-w><Up>
silent! tnoremap <A-l>                 <C-\><C-N><C-w><Right>
silent! tnoremap <C-h>                 <C-\><C-N><C-w><Left>
silent! tnoremap <C-j>                 <C-\><C-N><C-w><Down>
silent! tnoremap <C-k>                 <C-\><C-N><C-w><Up>
silent! tnoremap <C-l>                 <C-\><C-N><C-w><Right>
		inoremap <A-h>                 <C-\><C-N><C-w><Left>
		inoremap <A-j>                 <C-\><C-N><C-w><Down>
		inoremap <A-k>                 <C-\><C-N><C-w><Up>
		inoremap <A-l>                 <C-\><C-N><C-w><Right>
		noremap  <A-h>                 <C-w><Left>
		noremap  <A-j>                 <C-w><Down>
		noremap  <A-k>                 <C-w><Up>
		noremap  <A-l>                 <C-w><Right>

" fast buffers
		nnoremap <leader>bh            :bprevious<CR>
		nnoremap <leader>bl            :bnext<CR>
		nnoremap <leader>b0            :blast<CR>
		nnoremap <leader>b1            :bfirst<CR>
		nnoremap <leader>b2            :b2<CR>
		nnoremap <leader>b3            :b3<CR>
		nnoremap <leader>b4            :b4<CR>
		nnoremap <leader>b5            :b5<CR>
		nnoremap <leader>b6            :b6<CR>
		nnoremap <leader>b7            :b7<CR>
		nnoremap <leader>b8            :b8<CR>
		nnoremap <leader>b9            :b9<CR>

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
		nnoremap <leader><leader>d     "_d

" < and > dont loose selection when changing indentation
		vnoremap >                     >gv
		vnoremap <                     <gv

" Clear current search highlighting
		nnoremap <leader><leader>l     :nohlsearch<CR>

" Open terminal
		nnoremap <leader>m             :belowright 10split term://zsh<CR>

" => Bookmarks --------------------------------------------------------------------------------------------------- {{{1

		nnoremap <leader><leader>v     :tabedit <C-R>=VIM_CONFIG_FILE<CR><CR>
		nnoremap <leader><leader>z     :tabedit ~/.zshenv<CR>

" => Search for selected text, forwards or backwards ------------------------------------------------------------- {{{1

vnoremap <silent> * :<C-U>
	\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
	\gvy/<C-R><C-R>=substitute(
	\escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
	\gV:call setreg('"', old_reg, old_regtype)<CR>

vnoremap <silent> # :<C-U>
	\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
	\gvy?<C-R><C-R>=substitute(
	\escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
	\gV:call setreg('"', old_reg, old_regtype)<CR>

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
		nnoremap <leader>n             ]c
		nnoremap <leader>p             [c
		nnoremap <leader>u             :diffupdate<CR>
		nnoremap <leader>a             :call AlgoToggle()<CR>
		nnoremap <leader>i             :call IwhiteToggle()<CR>

		nnoremap <Left>                <C-W><Left>
		nnoremap <Down>                ]czz
		nnoremap <Up>                  [czz
		nnoremap <Right>               <C-w><Right>

"		hi DiffAdd    ctermfg=233 ctermbg=LightGreen guifg=#003300 guibg=#DDFFDD gui=none cterm=none
"		hi DiffChange ctermbg=white  guibg=#ececec gui=none   cterm=none
"		hi DiffText   ctermfg=233  ctermbg=yellow  guifg=#000033 guibg=#DDDDFF gui=none cterm=none

		function! IwhiteToggle()
			if &diffopt =~ 'iwhite'
				set diffopt-=iwhite
			else
				set diffopt+=iwhite
			endif
		endfunction

		function! AlgoToggle()
			if &diffopt =~ 'algorithm:myers'
				set diffopt-=algorithm:myers
				set diffopt+=algorithm:patience
			elseif &diffopt =~ 'algorithm:patience'
				set diffopt-=algorithm:patience
				set diffopt+=algorithm:minimal
			elseif &diffopt =~ 'algorithm:minimal'
				set diffopt-=algorithm:minimal
				set diffopt+=algorithm:histogram
			elseif &diffopt =~ 'algorithm:histogram'
				set diffopt-=algorithm:histogram
				set diffopt+=algorithm:myers
			else
				set diffopt+=algorithm:patience
			endif
		endfunction
	augroup END
else
	augroup save_restore_folds                                                 " save and restore folds only in non-diff mode
		autocmd!
		autocmd BufWinEnter * silent! loadview
		autocmd BufWinLeave * silent! mkview
	augroup END
endif

" => Debugger ---------------------------------------------------------------------------------------------------- {{{1

silent! packadd termdebug

" => Automatization ---------------------------------------------------------------------------------------------- {{{1

augroup autoclose_quickfix_if_last
	autocmd!
	autocmd BufEnter * if (winnr('$') == 1 && (&buftype ==# 'quickfix' || &buftype ==# 'loclist')) | bd | endif
augroup END

augroup Qf
	autocmd!
	autocmd FileType qf set nobuflisted
augroup END

"augroup save_restore_position
"	autocmd!
"	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
"augroup END

augroup pre_post_process
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
	" Regenerate tags when saving Python files
	autocmd BufWritePost *.py     silent! !ctags -R &
	" Remove all trailing whitespaces (ALE does this better)
"	autocmd BufWritePre  *        :%s/\s\+$//e                                                                         " Remove trailing spaces on save
	autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

"let ssh_client=$SSH_CLIENT
"if ssh_client != ''
"	" Sends default register to terminal TTY using OSC 52 escape sequence (not supported by all terminals yet)
"	function! s:Osc52Yank()
"		let buffer=system('base64 -w0', @0)
"		let buffer=substitute(buffer, "\n$", "", "")
"		let buffer='\e]52;c;'.buffer.'\x07'
"		silent exec "!echo -ne ".shellescape(buffer)." > ".shellescape("/dev/pts/0")
"	endfunction
"
"	" Automatically call OSC52 function on yank to sync register with host clipboard
"	augroup Yank
"		autocmd!
"		autocmd TextYankPost * if v:event.operator ==# 'y' | call s:Osc52Yank() | endif
"	augroup END
"endif

augroup AutoGzipForNonstandardExtensions
	autocmd!
"	Enable editing of gzipped files.
"	The functions are defined in autoload/gzip.vim.
"	Set binary mode before reading the file.
"	Use "gzip -d", gunzip isn't always available.
	autocmd BufReadPre,FileReadPre     *.dsl.dz,*.dict.dz setlocal bin
	autocmd BufReadPost,FileReadPost   *.dsl.dz,*.dict.dz call     gzip#read("gzip -dn -S .dz")
	autocmd BufWritePost,FileWritePost *.dsl.dz,*.dict.dz call     gzip#write("gzip -S .dz")
	autocmd FileAppendPre              *.dsl.dz,*.dict.dz call     gzip#appre("gzip -dn -S .dz")
	autocmd FileAppendPost             *.dsl.dz,*.dict.dz call     gzip#write("gzip -S .dz")
augroup END

" => Filetype ---------------------------------------------------------------------------------------------------- {{{1

augroup SettingsByFileType
	autocmd!
	autocmd FileType *      setlocal textwidth=120 wrapmargin=0
	autocmd Filetype json   setlocal foldmethod=syntax expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4 foldnestmax=30
	autocmd Filetype python setlocal foldmethod=indent expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4
	autocmd Filetype vim    setlocal foldmethod=marker
	autocmd Filetype yaml   setlocal foldmethod=syntax expandtab smarttab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" => Filetype: perl ---------------------------------------------------------------------------------------------- {{{1
" man: ft-perl-syntax

let perl_include_pod                     = 0
let perl_fold                            = 1
let perl_nofold_packages                 = 1

augroup SettingsByFileTypePerl
	autocmd!
	autocmd BufNewFile,BufRead *.t   setfiletype perl
	autocmd BufNewFile,BufRead *.pod setfiletype pod
	autocmd BufNewFile,BufRead *.itn setfiletype itn
	autocmd Filetype perl setlocal foldmethod=syntax expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4
	autocmd FileType perl setlocal keywordprg=perldoc
	autocmd FileType perl set formatprg=perltidy
	autocmd Filetype perl setlocal re=1                                                                                " Use old verion of syntax highlight regexp which look like working much faster (to check use syntime on -> syntime report)
	autocmd FileType perl nmap     <silent> tt <Plug>(ale_fix)
"	autocmd FileType perl nnoremap <silent> tt :%!perltidy -q<CR>
	autocmd FileType perl vnoremap <silent> tt :!perltidy -q<CR>
augroup END

augroup SettingsByFileTypeTypescript
	autocmd!
	autocmd FileType typescript set      formatprg=prettier
	autocmd Filetype typescript setlocal foldmethod=syntax expandtab smarttab tabstop=2 shiftwidth=2 softtabstop=2
	autocmd FileType typescript nmap     <silent> tt <Plug>(ale_fix)
augroup END

" => Plugin: airline --------------------------------------------------------------------------------------------- {{{1

let g:airline#extensions#ale#enabled     = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts            = 0
let g:airline_theme                      = "luna"

" => Plugin: ale ------------------------------------------------------------------------------------------------- {{{1

let g:ale_fix_on_save               = 1                                        " fix files when you save them
let g:ale_fix_on_save_ignore        = {
\   'perl':       ['perltidy'],
\   'typescript': ['tsfmt'],
\}
let g:ale_fixers                    = {
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\   'perl':       ['remove_trailing_lines', 'trim_whitespace', 'perltidy'],
\   'typescript': ['remove_trailing_lines', 'trim_whitespace', 'tsfmt'],
\}

"let g:ale_linters_explicit          = 1
let g:ale_linters                   = {
\   'perl':       ['perl', 'perlcritic'],
\   'typescript': ['tslint'],
\}
"\   'cpp': ['ccls', 'clang', 'clangcheck', 'clangd', 'clangtidy', 'clazy', 'cppcheck', 'cpplint', 'cquery', 'flawfinder', 'gcc'],

let g:ale_sign_error                = '✘'
let g:ale_sign_warning              = '❇'
let g:ale_set_loclist               = 1
let g:ale_set_quickfix              = 0
let g:ale_open_list                 = 1
let g:ale_keep_list_window_open     = 0
let g:ale_list_window_size          = 5

" ale_cpp
let g:ale_cpp_gcc_options           = '-std=c++17 -Wall -I $HOME/git/private/cpp/lib/basis/include -I $HOME/git/private/cpp/examples/sparse/src/include'
let g:ale_cpp_clang_options         = '-std=c++17 -Wall -I $HOME/git/private/cpp/lib/basis/include -I $HOME/git/private/cpp/examples/sparse/src/include'
let g:ale_cpp_clangd_options        = '-std=c++17 -Wall -I $HOME/git/private/cpp/lib/basis/include -I $HOME/git/private/cpp/examples/sparse/src/include'
" ale_perl
let g:ale_perl_perl_executable      = 'perl'
let g:ale_perl_perl_options         = '-cw -Ilib'
let g:ale_perl_perlcritic_showrules = 1

" necessary for UltiSnips
let g:ale_lint_on_enter             = 0
let g:ale_lint_on_filetype_changed  = 0
let g:ale_lint_on_text_changed      = 0
let g:ale_lint_on_insert_leave      = 0

" => Plugin: fugitive -------------------------------------------------------------------------------------------- {{{1

let g:fugitive_gitlab_domains = ['https://gitlab.' . PRIVATE_DOMAIN . '.com']

" => Plugin: NERDTree -------------------------------------------------------------------------------------------- {{{1

let NERDTreeShowHidden        = 1
let NERDTreeCaseSensitiveSort = 1
let NERDTreeShowBookmarks     = 1                                              " Display bookmarks by default
let NERDTreeHijackNetrw       = 0
let NERDTreeQuitOnOpen        = 1

augroup PluginNERDTree
	autocmd!
	" Enable NERDTree on Vim startup
"	autocmd VimEnter * NERDTree
	" Autoclose NERDTree if it's the only open window left
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

noremap <leader><leader>n              :NERDTreeToggle<CR>

" => Plugin: vim-nerdtree-syntax-highlight ----------------------------------------------------------------------- {{{1

"let g:NERDTreeHighlightCursorline            = 0
"let g:NERDTreeLimitedSyntax                  = 1
"let g:NERDTreeSyntaxDisableDefaultExtensions = 1
"let g:NERDTreeDisableExactMatchHighlight     = 1
"let g:NERDTreeDisablePatternMatchHighlight   = 1
"let g:NERDTreeSyntaxEnabledExtensions        = ['c', 'h', 'c++', 'hpp', 'go', 'pm', 'pl']

" => Plugin: NERDComment ----------------------------------------------------------------------------------------- {{{1

let g:NERDCommentEmptyLines      = 1                                           " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCustomDelimiters       = { 'c': { 'left': '/**','right': '*/' } }    " Add your own custom formats or override the defaults
"let g:NERDDefaultAlign           = 'start'                                     " Comment at the beginning of the line instead of following code indentation
let g:NERDRemoveExtraSpaces      = 1
let g:NERDSpaceDelims            = 0                                           " Add spaces after comment delimiters by default
let g:NERDToggleCheckAllLines    = 1                                           " Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDTrimTrailingWhitespace = 1                                           " Enable trimming of trailing whitespace when uncommenting

" map comment to ctrl-/
map <C-_>                              <Plug>NERDCommenterToggle

" => Plugin: netrw ----------------------------------------------------------------------------------------------- {{{1

"let g:loaded_netrwPlugin = 1                                                   " Prevent netrw from loading
let g:netrw_banner       = 1
"let g:netrw_cursor       = 1
let g:netrw_liststyle    = 3
"let g:netrw_list_hide    = netrw_gitignore#Hide().'.*\.swp$'
"let g:netrw_preview      = 1
"let g:netrw_sizestyle    = 'H'
"let g:netrw_usetab       = 1
let g:netrw_winsize      = 25

"noremap <leader>n :Lexplore<CR>

"autocmd BufEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" | q | endif

" => Plugin: fzf ------------------------------------------------------------------------------------------------- {{{1

function! s:find_git_root()
	return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

function! s:find_current_dir()
	return expand('%:p:h')
endfunction

"command! FilesProject    execute 'Files' s:find_git_root()
"command! FilesCurrentDir execute 'Files' s:find_current_dir()
command! FilesCurrentDir  execute 'Files' getcwd()
command! FilesProject     execute 'Files' s:find_git_root()

noremap  <C-p>                         :FilesCurrentDir<CR>
noremap  <C-t>                         :FilesProject<CR>
noremap  <leader><leader>b             :Buffers<CR>

" => Plugin: tagbar ---------------------------------------------------------------------------------------------- {{{1

nmap     <leader><leader>'             :TagbarToggle<CR>

" => Plugin: UltiSnips ------------------------------------------------------------------------------------------- {{{1

" Trigger configuration. Using <tab> here together with YouCompleteMe works because of 'supertab' plugin
let g:UltiSnipsExpandTrigger       ='<tab>'
let g:UltiSnipsListSnippets        ='<c-tab>'
let g:UltiSnipsJumpForwardTrigger  ='<tab>'
let g:UltiSnipsJumpBackwardTrigger ='<s-tab>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit           ='vertical'

" => Plugin: vim-easy-align -------------------------------------------------------------------------------------- {{{1

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga                                <Plug>(EasyAlign)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga                                <Plug>(EasyAlign)

" => Plugin: CtrlSF ---------------------------------------------------------------------------------------------- {{{1

let g:ctrlsf_auto_focus = {
	\ "at" : "done",
	\ "duration_less_than": 2000
	\ }
"let g:ctrlsf_debug_mode         = 1
let g:ctrlsf_default_root       = 'project+wf'
"let g:ctrlsf_default_view_mode  = 'compact'
let g:ctrlsf_extra_backend_args = {
	\ 'ag': '--hidden --nofollow',
	\ 'rg': '--hidden',
	\ }
let g:ctrlsf_extra_root_markers = ['.git', '.hg', '.svn', '.cache']
let g:ctrlsf_follow_symlinks    = 0
let g:ctrlsf_ignore_dir         = ['.git', 'bower_components', 'node_modules']
let g:ctrlsf_parse_speed        = 100
let g:ctrlsf_position           = 'bottom'

nmap     <leader>f                     <Plug>CtrlSFPrompt
vmap     <leader>f                     <Plug>CtrlSFVwordExec

" => Plugin: vim-grepper ----------------------------------------------------------------------------------------- {{{1

silent! runtime plugin/grepper.vim                                             " initialize g:grepper with default values
silent! let g:grepper.highlight   = 1
silent! let g:grepper.jump        = 0
silent! let g:grepper.quickfix    = 1
silent! let g:grepper.dir         = 'cwd'
silent! let g:grepper.repo        = ['.git', '.hg', '.svn', '.cache']
silent! let g:grepper.stop        = 255
silent! let g:grepper.tools       = ['git', 'ag', 'rg', 'grep', 'ack', 'ack-grep']
silent! let g:grepper.ag.grepprg .= ' --hidden'
silent! let g:grepper.rg.grepprg .= ' --hidden --smart-case'

" Start Grepper prompt
nnoremap <leader>g                     :Grepper -dir cwd<CR>
nnoremap <leader><leader>g             :Grepper -dir repo<CR>
" Search for the current word
nnoremap <leader>*                     :Grepper -cword -noprompt<CR>
" Search for the current selection or {motion} (see text-objects)
nmap     gs                            <Plug>(GrepperOperator)
xmap     gs                            <Plug>(GrepperOperator)
" Search current selection (alias for gs in visual mode)
vmap     <leader>g                     <Plug>(GrepperOperator)

" => Plugin: vim-go ---------------------------------------------------------------------------------------------- {{{1

"" first setup steps:
""	:GoInstallBinaries
"
"let g:go_fmt_command                 = "goimports"
"let g:go_fmt_fail_silently           = 1
"let g:go_fmt_autosave                = 1
"let g:go_fmt_experimental            = 1
"let g:go_highlight_types             = 1
"let g:go_highlight_fields            = 1
"let g:go_highlight_functions         = 1
"let g:go_highlight_function_calls    = 1
"let g:go_highlight_operators         = 1
"let g:go_highlight_extra_types       = 1
"let g:go_highlight_build_constraints = 1
"let g:go_highlight_structs           = 1
"let g:go_highlight_methods           = 1
"
""let g:go_play_open_browser           = 0
""let g:loaded_syntastic_go_gofmt_checker = 0
"
"" run :GoBuild or :GoTestCompile based on the go file
"function! s:build_go_files()
"	let l:file = expand('%')
"	if l:file =~# '^\f\+_test\.go$'
"		call go#test#Test(0, 1)
"	elseif l:file =~# '^\f\+\.go$'
"		call go#cmd#Build(0)
"	endif
"endfunction
"
"augroup SettingsByFileTypeGo
"	autocmd!
"	autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
""	autocmd BufWritePost       *.go normal! zv
"	autocmd FileType go nnoremap <leader>b :<C-u>call <SID>build_go_files()<CR>
"	autocmd FileType go nnoremap <leader>e :GoRename<CR>
"	autocmd FileType go nmap     <leader>r <Plug>(go-run)
"	autocmd FileType go nmap     <leader>c <Plug>(go-coverage-toggle)
"	autocmd FileType go nmap     <leader>i <Plug>(go-info)
"augroup END

" => Plugin: vim-mergetool --------------------------------------------------------------------------------------- {{{1

"let g:mergetool_layout = 'mr'
"let g:mergetool_prefer_revision = 'local'

" => Plugin: vim-plug -------------------------------------------------------------------------------------------- {{{1

let g:plug_timeout = 300                                                       " Increase vim-plug timeout for YouCompleteMe

nnoremap <leader><leader>u             :PlugUpdate<CR>

" => Plugin: vim-rooter ------------------------------------------------------------------------------------------ {{{1

let g:rooter_patterns     = ['.config/', 'lib/', '.git', '.git/']
let g:rooter_silent_chdir = 1

" => Plugin: vim-test -------------------------------------------------------------------------------------------- {{{1

let test#strategy = "neovim"
let test#perl#prove#executable = 'yath test --qvf'
let g:test#perl#prove#file_pattern = '\v^x?t/.*\.t$'

nmap     <silent> <leader><leader>h    :let $T2_WORKFLOW = line(".") \| :TestFile<CR>
nmap     <silent> <leader><leader>f    :let $T2_WORKFLOW = ""        \| :TestFile<CR>

" => Plugin: vimwiki --------------------------------------------------------------------------------------------- {{{1

let g:vimwiki_list = [
	\{'path': '~/.local/share/wiki',       'syntax': 'markdown', 'ext': '.mdwiki'},
	\{'path': 'wiki',                      'syntax': 'markdown', 'ext': '.mdwiki'}
\]

" => Plugin: YouCompleteMe --------------------------------------------------------------------------------------- {{{1

"let g:ycm_global_ycm_extra_conf = '~/.config/shell/ycm_extra_conf.py'          " Where to search for .ycm_extra_conf.py if not found
"let g:ycm_confirm_extra_conf                            = 0

"let g:ycm_show_diagnostics_ui                           = 0 " default 1
"let g:ycm_register_as_syntastic_checker                 = 0 " default 1

let g:ycm_error_symbol                                  = '✘'
let g:ycm_warning_symbol                                = '❇'
"let g:ycm_always_populate_location_list                 = 1 " default 0

let g:ycm_complete_in_comments                          = 1
let g:ycm_goto_buffer_command                           = 'new-or-existing-tab'
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files           = 1 " default 0
"let g:ycm_seed_identifiers_with_syntax                  = 1

" necessary for UltiSnips
let g:ycm_key_list_select_completion                    = ['<C-n>', '<Down>', '<M-Space>']
let g:ycm_key_list_previous_completion                  = ['<C-p>', '<Up>']

"nnoremap <leader>g :YcmCompleter GoTo<CR>
""nnoremap <F9>      :YcmDiags <CR>
""nnoremap <F11>     :YcmForceCompileAndDiagnostics <CR>

" => Plugin: supertab -------------------------------------------------------------------------------------------- {{{1

let g:SuperTabDefaultCompletionType                     = '<C-n>'

" => Plugin: startify -------------------------------------------------------------------------------------------- {{{1

let g:startify_change_to_dir = 0

" => Plugin: vdebug ---------------------------------------------------------------------------------------------- {{{1

if !exists('g:vdebug_options')
	let g:vdebug_options = {}
endif

let g:vdebug_options.server              = 'localhost'
let g:vdebug_options.debug_window_level  = 0
"let g:vdebug_options["socket_type"]      = 'unix'
"let g:vdebug_options["unix_path"]        = '/run/user/1027/dbgp.sock'
"let g:vdebug_options["unix_permissions"] = 0777
let g:vdebug_options.break_on_open       = 0
let g:vdebug_options.watch_window_style  = 'compact'                           " This can be 'compact' or 'expanded'.

let g:vdebug_keymap = {
\	"run" :               "<F5>",
\	"run_to_cursor" :     "<F9>",
\	"step_over" :         "<F2>",
\	"step_into" :         "<F3>",
\	"step_out" :          "<F4>",
\	"close" :             "<F6>",
\	"detach" :            "<F7>",
\	"set_breakpoint" :    "<F10>",
\	"get_context" :       "<F11>",
\	"eval_under_cursor" : "<F12>",
\	"eval_visual" :       "<leader>e",
\}

"let g:vdebug_features = {}
" This determines the maximum number of hash or array values available to you in the watch window. Hopefully this is enough?
"let g:vdebug_features['max_children']    = 512
" This determines the maximum number of bytes that will be sent to the debugger
" While ~1MB of data really shouldn't cause any problem in this day and age, YMMV?
"let g:vdebug_features['max_data']        = 1000000

" => Company-specific -------------------------------------------------------------------------------------------- {{{1

if !empty(glob(VIM_CONFIG_HOME . '/' . PRIVATE_DOMAIN . '.vim'))
	exec 'source ' . VIM_CONFIG_HOME . '/' . PRIVATE_DOMAIN . '.vim'
endif

" => Know-How ---------------------------------------------------------------------------------------------------- {{{1

":verbose set tw? wm?
":verbose set formatoptions?
":scriptnames
":help -V                                                                      " Trace all vim open files
":help filetype-overrule
"vim --startuptime vim.log
"vim --cmd 'profile start vimrc.profile' --cmd 'profile! file /home/agrechkin/.config/nvim/init.vim'
