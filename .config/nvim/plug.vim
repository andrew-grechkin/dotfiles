call plug#begin('~/.cache/vim/plugged')
	Plug 'junegunn/fzf.vim'                                                    " Fuzzy search
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/vim-plug'
	Plug 'tpope/vim-abolish'
	Plug 'tpope/vim-fugitive'                                                  " Git support
	Plug 'tpope/vim-projectionist'
	Plug 'tpope/vim-repeat'                                                    " Repeat everything
	Plug 'tpope/vim-surround'                                                  " Better surround commands
	Plug 'tpope/vim-unimpaired'                                                " Pairs of helpful commands
	Plug 'tpope/vim-commentary'                                                " Commenting helpers
	Plug 'suy/vim-context-commentstring'
"	Plug 'scrooloose/nerdcommenter', {'on': '<Plug>NERDCommenterToggle'}       " Commenting helpers
	Plug 'christoomey/vim-tmux-navigator'                                      " Better tmux integration
	Plug 'mhinz/vim-grepper'                                                   " Grep integration
	Plug 'nelstrom/vim-visual-star-search'
	Plug 'andrew-grechkin/vim-rooter'                                          " Cwd if file is in git repo should be repo root
	Plug 'Raimondi/delimitMate'
	Plug 'chrisbra/unicode.vim'
	Plug 'vifm/vifm.vim'
	Plug 'rodjek/vim-puppet'                                                   " For Puppet syntax highlighting
"	Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}                                  " For Facts, Ruby functions, and custom providers
	Plug 'pearofducks/ansible-vim'
"	Plug '~/.local/share/vim-plug/trackperlvars', {'for': 'perl'}
"	Plug '~/.local/share/vim-plug/perlart',       {'for': 'perl'}
	Plug 'janko/vim-test'
	Plug 'sbdchd/vim-run'
	Plug 'ryanoasis/vim-devicons'
	Plug 'vim-airline/vim-airline'                                             " Most informative status line
	Plug 'vim-airline/vim-airline-themes'                                      " Status line themes
	if has('nvim') || v:version >= 800                                         " These plugins demand modern vim or neovim
		Plug 'dense-analysis/ale'                                              " Async syntax checker
"		Plug 'easymotion/vim-easymotion'                                       " Better move commands
		Plug 'junegunn/vim-peekaboo'                                           " Preview registers
		Plug 'lambdalisue/suda.vim'                                            " run sudo from vim
		Plug 'majutsushi/tagbar'
"		Plug 'masukomi/vim-markdown-folding'
		Plug 'mhinz/vim-signify'                                               " Git status/modifications of the file
		""" snippets
		Plug 'SirVer/ultisnips'
		Plug 'andrew-grechkin/vim-snippets'
	endif
	if has('nvim-0.5')                                                         " Neovim only
"		Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF','<Plug>CtrlSFPrompt','<Plug>CtrlSFCwordPath','<Plug>CtrlSFVwordExec']} " Global search and replace
"		Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}                   " Visualize the undo tree
"		Plug 'fatih/vim-go', {'for': 'go'}
		""" coloring
		Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}
		""" LSP
		Plug 'neovim/nvim-lspconfig'                                           " ~/.config/nvim/after/plugin/nvim-lspconfig.lua
		Plug 'williamboman/nvim-lsp-installer'
		" Plug 'glepnir/lspsaga.nvim'                                            " ~/.config/nvim/after/plugin/nvim-lspsaga.vim
		" Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
		""" UI
		" Plug folke/lsp-colors.nvim'
		""" completion
		if 1
			let g:loaded_completion = 1
			Plug 'f3fora/cmp-spell'
			Plug 'hrsh7th/cmp-buffer'
			Plug 'hrsh7th/cmp-cmdline'
			Plug 'hrsh7th/cmp-nvim-lsp'
			Plug 'hrsh7th/cmp-nvim-lua'
			Plug 'hrsh7th/cmp-path'
			Plug 'quangnguyen30192/cmp-nvim-tags'
			Plug 'quangnguyen30192/cmp-nvim-ultisnips'
			" Plug 'uga-rosa/cmp-dictionary'
			Plug 'hrsh7th/nvim-cmp'
		else
"			Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-libclang'}
			Plug 'Valloric/YouCompleteMe', {'do': './install.py --clangd-completer'}
		endif
		"""
		" Plug 'kyazdani42/nvim-web-devicons'                                    " lua fork of vim-devicons
		" Plug 'hoob3rt/lualine.nvim'
		" Plug 'akinsho/bufferline.nvim'
		Plug 'folke/which-key.nvim'
	endif
	""" checking empty($KDEHOME) here is a weird way to check if this config is used in personal/work environment
	""" KDEHOME is always defined on personal machines. I need to do something smarter in future
	if empty($KDEHOME)                                                         " Install these pluggins only at work remote machines
		Plug 'junegunn/fzf', {'dir': '~/.cache/fzf', 'do': './install --bin'}
	else                                                                       " Install these pluggins only on personal machines
		Plug 'szw/vim-g'                                                       " Search on Google
		" Plug 'inkarkat/vim-localrc'
		Plug 'mgrabovsky/vim-cuesheet'
		Plug 'shumphrey/fugitive-gitlab.vim'                                   " fugitive Gitlab module
		Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}                          " Vim plugin for .tmux.conf
		Plug 'tpope/vim-rhubarb'                                               " fugitive Github module
		Plug 'vimwiki/vimwiki'                                                 " Personal wiki
	endif
" 	if 0                                                                       " These plugins are disabled
" 		Plug 'chrisbra/csv.vim'
" 		Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
" 		Plug 'flazz/vim-colorschemes'                                          " Huge set of color schemes
" 		Plug 'vim-scripts/ScrollColors', {'on': 'SCROLL'}                      " Scroll through color schemes
" 		Plug 'itchyny/lightline.vim'
" 		Plug 'jceb/vim-hier'
" 		Plug 'mhinz/vim-grepper', {'on': ['Grepper', '<Plug>(GrepperOperator)']} " Grep integration
" 		Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}             " Language Server support
" 		Plug 'tpope/vim-vinegar'
" 		Plug 'vim-vdebug/vdebug'
" 		Plug 'xolox/vim-misc'
" 		Plug 'xolox/vim-easytags'
" 		Plug 'jiangmiao/auto-pairs'
"		Plug 'mhinz/vim-startify'                                              " startify is slow!
"		Plug 'unblevable/quick-scope'
" 		""" perl autocomplete (not working properly)
" 		Plug 'chumakd/perlomni.vim'
" 		Plug 'Shougo/deoplete.nvim'
" 	endif
call plug#end()

"packloadall                                                                    " Load all plugins
"silent! helptags ALL                                                           " Load help files for all plugins
