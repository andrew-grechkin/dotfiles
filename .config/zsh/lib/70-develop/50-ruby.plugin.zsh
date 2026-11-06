# vim: filetype=zsh foldmethod=marker

function () {
    typeset -gUT RUBYLIB rubylib
    rubylib=("$HOME/.local/lib/ruby" ${rubylib[@]})
    export RUBYLIB
}
