# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

() {
    local file
    for file in "$ZDOTDIR"/3rdparty/**/*.plugin.zsh(N) "$ZDOTDIR"/lib/**/*.zsh(N); do
        builtin source "$file"
    done
}

# => show profiler ------------------------------------------------------------------------------------------------ {{{1

# zprof
