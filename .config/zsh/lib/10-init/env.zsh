# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

if [[ "$IS_NAS" == "1" ]]; then
    export PAGER="less"
elif [[ "$HOSTNAME" =~ king\.com$ ]]; then
    # on kvm use defaults
    :
else
    export HAS_MOUSE='1'
    export LESS='-x4 -iRw --mouse'
fi

# => -------------------------------------------------------------------------------------------------------------- {{{1

# man: zshmodules
if [[ "$IS_NAS" != "0" ]]; then
    if [[ "$IS_NAS" != "1" ]]; then
        [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
    fi
fi

WORDCHARS="${WORDCHARS/\/}:+"

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg HYPHEN_INSENSITIVE REPORTTIME
HYPHEN_INSENSITIVE=1
REPORTTIME=10
