# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# debug login shell startup
if [[ ! -o interactive ]]; then
    exec &>"/tmp/login-shell-$$.log"
    env | sort
    echo "start: $0 $*"
    echo "opts: $-"
    set -x
fi

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
source "$ZDOTDIR/.zshenv"

# make sure ubuntu plasma (which annoyingly executed not as login shell on login) sources profile
if [[ "${1:-}" =~ startplasma-x11 ]] || [[ "${1:-}" =~ xdm/sys.xsession ]]; then
    [[ ! -o login && ! -o interactive && -r "$ZDOTDIR/.zprofile" ]] && source "$ZDOTDIR/.zprofile"
fi

if [[ ! -o interactive ]]; then
    set +x
    env | sort
fi
