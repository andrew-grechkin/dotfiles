" https://github.com/rockerBOO/awesome-neovim

call plug#begin()
	Plug 'Raimondi/delimitMate'
	Plug 'SirVer/ultisnips'
	Plug 'andrew-grechkin/vim-rooter'                                          " Cwd if file is in git repo should be repo root
	Plug 'andrew-grechkin/vim-snippets'
	Plug 'chrisbra/unicode.vim'
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
	Plug 'dense-analysis/ale'                                                  " Async syntax checker
	Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFPrompt','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
	Plug 'folke/which-key.nvim'
	Plug 'jghauser/mkdir.nvim'
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/vim-plug'
	Plug 'mhinz/vim-grepper'                                                   " Grep integration
	Plug 'mhinz/vim-signify'                                                   " Git status/modifications of the file
	Plug 'nelstrom/vim-visual-star-search'
	Plug 'sbdchd/vim-run'
	Plug 'suy/vim-context-commentstring'
	Plug 'tpope/vim-commentary'                                                " Commenting helpers
	Plug 'tpope/vim-fugitive'                                                  " Git support
	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-surround'                                                  " Better surround commands
	Plug 'vifm/vifm.vim'

	if 1
		Plug 'vim-airline/vim-airline'                                         " Most informative status line
		Plug 'vim-airline/vim-airline-themes'                                  " Status line themes
		Plug 'ryanoasis/vim-devicons'
	else
		Plug 'nvim-lualine/lualine.nvim'
		Plug 'akinsho/bufferline.nvim'
		Plug 'kyazdani42/nvim-web-devicons'                                    " lua fork of ryanoasis/vim-devicons
	endif


	Plug 'nvim-lua/plenary.nvim'                                               " async library many plugins depend on
	if has('nvim-0.9')                                                         " Neovim with lua only
		Plug 'nvim-telescope/telescope.nvim'
	else
		Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
	endif
	Plug 'RRethy/vim-illuminate'                                               " highlight selected word

	""" LSP
	Plug 'neovim/nvim-lspconfig'                                               " ~/.config/nvim/after/plugin/30-nvim-lspconfig.lua
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
	Plug 'ray-x/lsp_signature.nvim'                                            " signature hints
	" Plug 'glepnir/lspsaga.nvim'                                              " ~/.config/nvim/after/plugin/nvim-lspsaga.vim

	""" UI
	Plug 'lukas-reineke/indent-blankline.nvim'

	""" debug
	if 1
		Plug 'mfussenegger/nvim-dap'
		Plug 'mfussenegger/nvim-dap-python'
		Plug 'jay-babu/mason-nvim-dap.nvim'
		Plug 'jbyuki/one-small-step-for-vimkind'
		Plug 'nvim-telescope/telescope-dap.nvim'
		Plug 'rcarriga/nvim-dap-ui'
		Plug 'theHamsta/nvim-dap-virtual-text'
	endif

	""" test
	if 1                                                                       " completion
		Plug 'janko/vim-test'
		Plug 'nvim-neotest/neotest'
		Plug 'nvim-neotest/neotest-plenary'
		Plug 'nvim-neotest/neotest-python'
		Plug 'nvim-neotest/neotest-vim-test'
	endif

	if 1                                                                       " completion
		let g:loaded_completion = 1
		Plug 'andersevenrud/cmp-tmux'
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
		Plug 'lukas-reineke/cmp-rg'
	endif

	if 1                                                                       " work related plugins
"		Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
"		Plug 'fatih/vim-go', {'for': 'go'}
		Plug 'pearofducks/ansible-vim'
		Plug 'rodjek/vim-puppet'                                               " For Puppet syntax highlighting
		Plug 'towolf/vim-helm'
"		Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                              " For Facts, Ruby functions, and custom providers
"		Plug '~/.local/share/vim-plug/trackperlvars', {'for': 'perl'}
"		Plug '~/.local/share/vim-plug/perlart',       {'for': 'perl'}
	endif

	""" checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
	""" KDEHOME is always defined on personal machines. I need to do something smarter in future
	if empty($KDEHOME)                                                         " Install these pluggins only at work remote machines
		Plug 'junegunn/fzf', {'dir': '~/.cache/fzf', 'do': './install --bin'}
	else                                                                       " Install these pluggins only on personal machines
		Plug 'potamides/pantran.nvim'
		Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
		Plug 'nvim-treesitter/playground'
"		Plug 'szw/vim-g'                                                       " Search on Google
"		Plug 'inkarkat/vim-localrc'
		Plug 'ellisonleao/glow.nvim'                                           " Preview markdown code directly in your neovim terminal"
		Plug 'gianarb/vim-flux'
		Plug 'mgrabovsky/vim-cuesheet'
		Plug 'shumphrey/fugitive-gitlab.vim'                                   " fugitive Gitlab module
		Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                          " Vim plugin for .tmux.conf
		Plug 'tpope/vim-rhubarb'                                               " fugitive Github module
		Plug 'vimwiki/vimwiki'                                                 " Personal wiki
		""" coloring
		Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}                " highlight colors
	endif

"	Plug 'easymotion/vim-easymotion'                                           " Better move commands

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
