# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# debug login shell startup
#if [[ -o login && ! -o interactive ]]; then
#    exec &>"/tmp/login-shell-$$.log"
#    env | sort
#    echo "start: $0 $*"
#    echo "opts: $-"
#    set -x
#fi

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
source "$ZDOTDIR/.zshenv"
