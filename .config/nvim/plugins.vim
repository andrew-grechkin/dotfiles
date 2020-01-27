call plug#begin()
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/vim-peekaboo'                                               " Preview registers
	Plug 'junegunn/vim-plug'
	Plug 'easymotion/vim-easymotion'                                           " Better move commands
	Plug 'mhinz/vim-grepper',                                                  " Grep integration
	"Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<Plug>(GrepperOperator)'] } " Grep integration
	Plug 'airblade/vim-gitgutter'                                              " Git status/modifications of the file
	Plug 'tpope/vim-abolish'
	Plug 'tpope/vim-fugitive'                                                  " Git support
	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-rhubarb'                                                   " fugitive Github module
	Plug 'tpope/vim-surround'                                                  " Better surround commands
	Plug 'tpope/vim-unimpaired'                                                " Pairs of helpful commands
	Plug 'scrooloose/nerdcommenter', {'on': '<Plug>NERDCommenterToggle'}       " Commenting helpers
	Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                              " Vim plugin for .tmux.conf
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
	Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
	Plug 'flazz/vim-colorschemes'                                              " Huge set of color schemes
	Plug 'vim-airline/vim-airline'                                             " Most informative status line
	Plug 'vim-airline/vim-airline-themes'                                      " Status line themes
	Plug 'mhinz/vim-startify'
	Plug 'andrew-grechkin/vim-rooter'                                          " Cwd if file is in git repo should be repo root
	if v:version >= 800 || has('nvim')
		" These plugins demand modern vim or nvim
		Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFPrompt','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
		Plug 'lambdalisue/suda.vim'                                            " run sudo from vim
		Plug 'w0rp/ale'                                                        " Async syntax checker
		Plug 'majutsushi/tagbar'
		Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}                   " Visualize the undo tree
		Plug 'masukomi/vim-markdown-folding'
		Plug 'SirVer/ultisnips'
		Plug 'honza/vim-snippets'
	endif
"	checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
"	KDEHOME is always defined on personal machines. I need to do something smarter in future
	if empty($KDEHOME)
		" Install these pluggins only at work remote machines
		Plug 'junegunn/fzf', { 'dir': '~/.cache/fzf', 'do': './install --bin' }
		Plug 'rodjek/vim-puppet'                                               " For Puppet syntax highlighting
		Plug 'fatih/vim-go', {'for': 'go'}
		Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                              " For Facts, Ruby functions, and custom providers
		Plug 'shumphrey/fugitive-gitlab.vim'                                   " fugitive Gitlab module
	else
		" Install these pluggins only on personal machines
		Plug 'ryanoasis/vim-devicons'
		Plug 'pearofducks/ansible-vim'
		Plug 'mgrabovsky/vim-cuesheet'
		Plug 'vifm/vifm.vim'
	endif
	if 0
		" These plugins are disabled
		Plug 'tpope/vim-vinegar'
		Plug 'vim-scripts/vimwiki'                                             " Personal wiki
		Plug 'MarcWeber/vim-addon-local-vimrc'
		Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' }
		Plug 'vim-syntastic/syntastic'
		Plug 'itchyny/lightline.vim'
		Plug 'vim-scripts/ScrollColors', {'on': 'SCROLL'}                      " Scroll through color schemes
		Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
		Plug 'vim-vdebug/vdebug'
		Plug 'samoshkin/vim-mergetool'
		Plug 'chrisbra/csv.vim'
		Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}             " Language Server support
		Plug 'jceb/vim-hier'
	endif
call plug#end()
