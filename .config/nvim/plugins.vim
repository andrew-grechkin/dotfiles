call plug#begin('~/.cache/vim/plugged')
	Plug 'junegunn/vim-plug'
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/vim-peekaboo'                                               " Preview registers
	Plug 'tpope/vim-abolish'
	Plug 'tpope/vim-fugitive'                                                  " Git support
	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-surround'                                                  " Better surround commands
	Plug 'tpope/vim-unimpaired'                                                " Pairs of helpful commands
	Plug 'airblade/vim-gitgutter'                                              " Git status/modifications of the file
	Plug 'easymotion/vim-easymotion'                                           " Better move commands
	Plug 'mhinz/vim-grepper'                                                   " Grep integration
	Plug 'scrooloose/nerdcommenter', {'on': '<Plug>NERDCommenterToggle'}       " Commenting helpers
	Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
	Plug 'mhinz/vim-startify'
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
	Plug 'andrew-grechkin/vim-rooter'                                          " Cwd if file is in git repo should be repo root
	" Colors support
	Plug 'flazz/vim-colorschemes'                                              " Huge set of color schemes
	Plug 'vim-airline/vim-airline'                                             " Most informative status line
	Plug 'vim-airline/vim-airline-themes'                                      " Status line themes
	if v:version >= 800 || has('nvim')
		" These plugins demand modern vim or neovim
		Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFPrompt','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
		Plug 'lambdalisue/suda.vim'                                            " run sudo from vim
		Plug 'majutsushi/tagbar'
		Plug 'vimwiki/vimwiki'
		Plug 'masukomi/vim-markdown-folding'
		Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}                   " Visualize the undo tree
		Plug 'w0rp/ale'                                                        " Async syntax checker
	endif
	if has('nvim')
		" These plugins demand neovim
		Plug 'janko/vim-test'
		" Snippets support
		Plug 'ervandew/supertab'
		Plug 'SirVer/ultisnips'
		Plug 'andrew-grechkin/vim-snippets'
	endif
"	checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
"	KDEHOME is always defined on personal machines. I need to do something smarter in future
	if empty($KDEHOME)
		" Install these pluggins only at work remote machines
		Plug 'fatih/vim-go', {'for': 'go'}
		Plug 'junegunn/fzf', {'dir': '~/.cache/fzf', 'do': './install --bin'}
		Plug 'rodjek/vim-puppet'                                               " For Puppet syntax highlighting
		Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                              " For Facts, Ruby functions, and custom providers
	else
		" Install these pluggins only on personal machines
		Plug 'tpope/vim-rhubarb'                                               " fugitive Github module
		Plug 'shumphrey/fugitive-gitlab.vim'                                   " fugitive Gitlab module
		Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-libclang'}
		Plug 'mgrabovsky/vim-cuesheet'
		Plug 'pearofducks/ansible-vim'
		Plug 'ryanoasis/vim-devicons'
		Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                          " Vim plugin for .tmux.conf
		Plug 'vifm/vifm.vim'
	endif
	if 0
		" These plugins are disabled
		Plug 'MarcWeber/vim-addon-local-vimrc'
		Plug 'chrisbra/csv.vim'
		Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
		Plug 'itchyny/lightline.vim'
		Plug 'jceb/vim-hier'
		Plug 'mhinz/vim-grepper', {'on': ['Grepper', '<Plug>(GrepperOperator)']} " Grep integration
		Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}             " Language Server support
		Plug 'samoshkin/vim-mergetool'
		Plug 'tpope/vim-vinegar'
		Plug 'vim-scripts/ScrollColors', {'on': 'SCROLL'}                      " Scroll through color schemes
		Plug 'vim-scripts/vimwiki'                                             " Personal wiki
		Plug 'vim-syntastic/syntastic'
		Plug 'vim-vdebug/vdebug'
		Plug 'xolox/vim-misc'
		Plug 'xolox/vim-easytags'
	endif
call plug#end()
