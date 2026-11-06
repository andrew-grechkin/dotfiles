# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => automatically start tmux on ssh connection. Logout on detach ------------------------------------------------- {{{1

if [[ -o interactive && -z "$TMUX" && -z "$ZELLIJ" && -n "$SSH_CLIENT" ]] \
    && ! [[ "${SSH_CLIENT}" =~ /::1/ ]]                                   \
    && ! [[ "${SSH_CLIENT}" =~ /127.0.0/ ]]                               \
    && (( $+commands[tmux] )); then

    exec tmux new-session -s ssh-auto -A
fi
