call plug#begin()
	Plug 'Raimondi/delimitMate'
	Plug 'SirVer/ultisnips'
	Plug 'andrew-grechkin/vim-rooter'                                          " Cwd if file is in git repo should be repo root
	Plug 'andrew-grechkin/vim-snippets'
	Plug 'chrisbra/unicode.vim'
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
	Plug 'dense-analysis/ale'                                                  " Async syntax checker
	Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFPrompt','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
	Plug 'janko/vim-test'
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/vim-plug'
	Plug 'majutsushi/tagbar'
	Plug 'mhinz/vim-grepper', {'on': ['Grepper', '<Plug>(GrepperOperator)']}   " Grep integration
	Plug 'mhinz/vim-signify'                                                   " Git status/modifications of the file
	Plug 'nelstrom/vim-visual-star-search'
	Plug 'pearofducks/ansible-vim'
	Plug 'ryanoasis/vim-devicons'
	Plug 'sbdchd/vim-run'
	Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}                       " Visualize the undo tree
	Plug 'suy/vim-context-commentstring'
	Plug 'tpope/vim-abolish'
	Plug 'tpope/vim-commentary'                                                " Commenting helpers
	Plug 'tpope/vim-fugitive'                                                  " Git support
	Plug 'tpope/vim-projectionist'
	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-surround'                                                  " Better surround commands
	Plug 'tpope/vim-unimpaired'                                                " Pairs of helpful commands
	Plug 'vifm/vifm.vim'
	Plug 'vim-airline/vim-airline'                                             " Most informative status line
	Plug 'vim-airline/vim-airline-themes'                                      " Status line themes

	Plug 'folke/which-key.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
	Plug 'nvim-treesitter/playground'
	""" LSP
	Plug 'neovim/nvim-lspconfig'                                               " ~/.config/nvim/after/plugin/nvim-lspconfig.lua
	Plug 'williamboman/nvim-lsp-installer'
	" Plug 'glepnir/lspsaga.nvim'                                              " ~/.config/nvim/after/plugin/nvim-lspsaga.vim
	""" UI
	" Plug folke/lsp-colors.nvim'
	""" completion
	if 1                                                                       " completion
		let g:loaded_completion = 1
		Plug 'f3fora/cmp-spell'
		Plug 'hrsh7th/cmp-buffer'
		Plug 'hrsh7th/cmp-cmdline'
		Plug 'hrsh7th/cmp-nvim-lsp'
		Plug 'hrsh7th/cmp-nvim-lua'
		Plug 'hrsh7th/cmp-path'
		Plug 'hrsh7th/nvim-cmp'
		Plug 'quangnguyen30192/cmp-nvim-tags'
		Plug 'quangnguyen30192/cmp-nvim-ultisnips'
		" Plug 'uga-rosa/cmp-dictionary'
	endif

	if 1                                                                       " work related plugins
"		Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
"		Plug 'fatih/vim-go', {'for': 'go'}
		Plug 'rodjek/vim-puppet'                                               " For Puppet syntax highlighting
"		Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                              " For Facts, Ruby functions, and custom providers
"		Plug '~/.local/share/vim-plug/trackperlvars', {'for': 'perl'}
"		Plug '~/.local/share/vim-plug/perlart',       {'for': 'perl'}
	endif

	""" checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
	""" KDEHOME is always defined on personal machines. I need to do something smarter in future
	if empty($KDEHOME)                                                         " Install these pluggins only at work remote machines
		Plug 'junegunn/fzf', {'dir': '~/.cache/fzf', 'do': './install --bin'}
	else                                                                       " Install these pluggins only on personal machines
"		Plug 'szw/vim-g'                                                       " Search on Google
"		Plug 'inkarkat/vim-localrc'
		Plug 'gianarb/vim-flux'
		Plug 'mgrabovsky/vim-cuesheet'
		Plug 'shumphrey/fugitive-gitlab.vim'                                   " fugitive Gitlab module
		Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                          " Vim plugin for .tmux.conf
		Plug 'tpope/vim-rhubarb'                                               " fugitive Github module
		Plug 'vimwiki/vimwiki'                                                 " Personal wiki
		""" coloring
		Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}
	endif

"	Plug 'hoob3rt/lualine.nvim'
"	Plug 'akinsho/bufferline.nvim'
"	Plug 'kyazdani42/nvim-web-devicons'                                        " lua fork of ryanoasis/vim-devicons

"	Plug 'easymotion/vim-easymotion'                                           " Better move commands
"	Plug 'masukomi/vim-markdown-folding'

	if 0                                                                       " These plugins are disabled
		Plug 'chrisbra/csv.vim'
		Plug 'flazz/vim-colorschemes'                                          " Huge set of color schemes
		Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
		Plug 'itchyny/lightline.vim'
		Plug 'jceb/vim-hier'
		Plug 'mhinz/vim-startify'                                              " startify is slow!
		Plug 'tpope/vim-vinegar'
		Plug 'unblevable/quick-scope'
		Plug 'vim-scripts/ScrollColors', {'on': 'SCROLL'}                      " Scroll through color schemes
		Plug 'vim-vdebug/vdebug'
		Plug 'xolox/vim-easytags'
		Plug 'xolox/vim-misc'
		""" perl autocomplete (not working properly)
		Plug 'chumakd/perlomni.vim'
		Plug 'Shougo/deoplete.nvim'
	endif
call plug#end()
