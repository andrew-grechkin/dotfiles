# vim: filetype=zsh foldmethod=marker

# => functions ---------------------------------------------------------------------------------------------------- {{{1

function export-rubylib() {
    typeset -gUT RUBYLIB rubylib
    rubylib=("$HOME/.local/lib/ruby" ${rubylib[@]})
    export RUBYLIB
}

# => main --------------------------------------------------------------------------------------------------------- {{{1

export-rubylib

unset -f export-rubylib
