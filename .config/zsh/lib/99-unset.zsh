# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# NOTE: it's better not having these variables set than have them pointing on absent commands
if [[ -n "$EDITOR" ]] && ! (( $+commands[$EDITOR] )); then
    unset EDITOR
fi

if [[ -n "$VISUAL" ]] && ! (( $+commands[$VISUAL] )); then
    unset VISUAL
fi
