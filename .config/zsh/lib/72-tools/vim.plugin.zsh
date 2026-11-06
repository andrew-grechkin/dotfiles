# vim: filetype=zsh foldmethod=marker

alias lvim='NVIM_APPNAME=LazyVim VIMINIT='' nvim'
alias vman='MANPAGER="nvim +Man! -c \":nnoremap <buffer> q :quitall<CR>\"" man'

if [[ -r "$XDG_CONFIG_HOME/nvim/init.lua" ]]; then
    export VIMINIT='let $MYVIMRC = has("nvim-0.10") ? "$XDG_CONFIG_HOME/nvim/init.lua" : "$XDG_CONFIG_HOME/vim/init.vim" | so $MYVIMRC'
else
    export VIMINIT='let $MYVIMRC = "$XDG_CONFIG_HOME/vim/init.vim" | so $MYVIMRC'
fi
