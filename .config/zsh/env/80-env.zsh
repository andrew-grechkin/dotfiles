# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

export LESSHISTFILE=-

if [[ -r "$XDG_CONFIG_HOME/nvim/init.lua" ]]; then
    export VIMINIT='let $MYVIMRC = has("nvim-0.10") ? "$XDG_CONFIG_HOME/nvim/init.lua" : "$XDG_CONFIG_HOME/vim/init.vim" | so $MYVIMRC'
else
    export VIMINIT='let $MYVIMRC = "$XDG_CONFIG_HOME/vim/init.vim" | so $MYVIMRC'
fi

unset READNULLCMD
