# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg ZSH_CACHE_DIR ZSH_COMPDUMP
ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
ZSH_COMPDUMP="$XDG_RUNTIME_DIR/zsh/zcompdump-${ZSH_VERSION}"
