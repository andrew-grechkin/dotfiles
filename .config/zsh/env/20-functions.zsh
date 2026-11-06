# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

function source-file() {
    if [[ -r "$1" ]]; then
        # [[ -w "${1}" ]] && [[ "${1}" -nt "${1}.zwc" ]] && zcompile "$1"
        builtin source "$1"
    fi
}
