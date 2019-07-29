# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => Automatically grant permissions on shared session ------------------------------------------------------------ {{{1

TMUX_SHARED_SOCKET="/tmp/tmux-shared-socket-$USER"
if [[ -S "$TMUX_SHARED_SOCKET" ]]; then
	chmod go+rw "$TMUX_SHARED_SOCKET"
fi

if [[ -r /etc/motd ]]; then
	cat /etc/motd
fi
