# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# [[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/bin"       "${path[@]}")
# [[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/sbin"      "${path[@]}")
# [[ -n "$PERLBREW_PATH"                                  ]] && path=("${(ps/:/)PERLBREW_PATH[@]}" "${path[@]}")
#
# if [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
#     [[ -d "$HOME/.cache/fzf/bin"                        ]] && path=("$HOME/.cache/fzf/bin"  "${path[@]}")
#     [[ -d "$HOME/.local/nvim/bin"                       ]] && path=("$HOME/.local/nvim/bin" "${path[@]}")
# fi
#
# export PATH
