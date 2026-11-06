# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

() {
    local file
    for file in "$ZDOTDIR"/env/*.zsh(N); do
        builtin source "$file"
    done
}
