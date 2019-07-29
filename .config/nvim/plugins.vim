call plug#begin()
	Plug 'junegunn/vim-plug'
"	Plug 'junegunn/fzf', { 'dir': '~/.cache/fzf', 'do': './install --bin' }
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/vim-peekaboo'                                               " Preview registers
	Plug 'easymotion/vim-easymotion'                                           " Better move commands
"	Plug 'ervandew/supertab'                                                   " More powerful <tab>
"	Plug 'justinmk/vim-dirvish'                                                " Less buggy netrw alternative
	Plug 'mhinz/vim-grepper'                                                   " Grep integration
"	Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<Plug>(GrepperOperator)'] } " Grep integration
	Plug 'airblade/vim-gitgutter'                                              " Git status/modifications of the file
	Plug 'tpope/vim-fugitive'                                                  " Git support
"	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-surround'                                                  " Better surround commands
"	Plug 'tpope/vim-unimpaired'                                                " Pairs of helpful commands
"	Plug 'tpope/vim-vinegar'
"	Plug 'vim-scripts/vimwiki'                                                 " Personal wiki
"	Plug 'MarcWeber/vim-addon-local-vimrc'
	Plug 'scrooloose/nerdcommenter', {'on': '<Plug>NERDCommenterToggle'}       " Commenting helpers
	Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                              " Vim plugin for .tmux.conf
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
"	Plug 'ctrlpvim/ctrlp.vim'                                                  " Ctrl+p to fuzzy search
	Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"	Plug 'vim-scripts/Gundo', {'on': 'GundoToggle'}                            " Visualize the undo tree
"	Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' }
"	Plug 'vim-syntastic/syntastic'
	Plug 'flazz/vim-colorschemes'                                              " Huge set of color schemes
	Plug 'vim-airline/vim-airline'                                             " Most informative status line
	Plug 'vim-airline/vim-airline-themes'                                      " Status line themes
	Plug 'ryanoasis/vim-devicons'
"	Plug 'itchyny/lightline.vim'
"	Plug 'vim-scripts/ScrollColors', {'on': 'SCROLL'}                          " Scroll through color schemes
"	Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
	Plug 'mhinz/vim-startify'
"	Plug 'vim-vdebug/vdebug'
"	Plug 'samoshkin/vim-mergetool'
"	Plug 'chrisbra/csv.vim'
	Plug 'fatih/vim-go', {'for': 'go'}
	if v:version >= 800 || has('nvim')
		Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
		Plug 'lambdalisue/suda.vim'                                            " run sudo from vim
		Plug 'w0rp/ale'                                                        " Async syntax checker
	endif
call plug#end()
