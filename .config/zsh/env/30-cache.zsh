# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg ZSH_CACHE_DIR ZSH_COMPDUMP
ZSH_CACHE_DIR="$XDG_CACHE_HOME"
ZSH_COMPDUMP="$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}"
