# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => activate mise shims globally --------------------------------------------------------------------------------- {{{1

(( $+commands[mise] )) && eval "$(mise activate --shims)"
