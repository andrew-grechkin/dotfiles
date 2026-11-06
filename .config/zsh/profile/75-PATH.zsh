# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

[[ -d "$HOME/.local/bin"     ]] && path=("$HOME/.local/bin"     "${path[@]}")
[[ -d "$HOME/.local/usr/bin" ]] && path=("$HOME/.local/usr/bin" "${path[@]}")
[[ -d "$HOME/.local/script"  ]] && path=("$HOME/.local/script"  "${path[@]}")

path=("$HOME/.local/scripts-ext"/*(-FN) "${path[@]}")
path=("$HOME/.local/scripts"/*(-FN)     "${path[@]}")

export PATH
