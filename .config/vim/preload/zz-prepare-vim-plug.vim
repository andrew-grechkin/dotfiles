" let VIM_CREATE_DIR    = ':silent !mkdir -p '. VIM_CONFIG_HOME . '/autoload'
let VIM_PLUG_URL      = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let VIM_PLUG_DOWNLOAD = ':silent !curl -sfLo ' . VIM_CONFIG_HOME . '/autoload/plug.vim --create-dirs ' . VIM_PLUG_URL

if empty(glob(VIM_CONFIG_HOME . '/autoload/plug.vim'))                          " Download and install vim-plug
	" execute VIM_CREATE_DIR
	execute VIM_PLUG_DOWNLOAD
	augroup InstallPlugins
		autocmd!
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	augroup END
endif
