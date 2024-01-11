call plug#begin('~/.local/share/vim/plugged')
	Plug 'Raimondi/delimitMate'
	Plug 'christoomey/vim-tmux-navigator'                                          " Better tmux integration
	Plug 'junegunn/fzf', {'dir': '~/.cache/fzf', 'do': './install --bin'}
	Plug 'junegunn/fzf.vim'                                                        " Fuzzy search
	Plug 'junegunn/vim-peekaboo'
	Plug 'junegunn/vim-plug'
	Plug 'andrew-grechkin/vim-grepper'                                             " Grep integration
	Plug 'nelstrom/vim-visual-star-search'
	Plug 'sbdchd/vim-run'
	Plug 'suy/vim-context-commentstring'
	Plug 'tpope/vim-commentary'                                                    " Commenting helpers
	Plug 'tpope/vim-repeat'                                                        " Repeat everything
	Plug 'tpope/vim-surround'                                                      " Better surround commands
	Plug 'vifm/vifm.vim'

	if 1
		Plug 'tpope/vim-fugitive'                                                  " Git support
"		Plug 'mhinz/vim-signify'                                                   " Git status/modifications of the file
	endif

	if 1
		Plug 'vim-airline/vim-airline'                                             " Most informative status line
		Plug 'vim-airline/vim-airline-themes'                                      " Status line themes
		Plug 'ryanoasis/vim-devicons'
	endif

	if has('nvim-0.5') || v:version >= 800                                         " These plugins demand modern vim or neovim
		Plug 'dense-analysis/ale'                                                  " Async syntax checker

		if 1                                                                       " work related plugins
			Plug 'rodjek/vim-puppet'                                               " For Puppet syntax highlighting
		endif
	endif
call plug#end()
