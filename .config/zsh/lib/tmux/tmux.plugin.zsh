# vim: filetype=zsh foldmethod=marker

# => correct ssh auth for tmux sessions --------------------------------------------------------------------------- {{{1

function fix_ssh_agent() {
	[[ -n "$TMUX" ]] && eval $(command tmux showenv -s SSH_AUTH_SOCK)
}

# => fix ssh agent path on remote servers automatically ----------------------------------------------------------- {{{1

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]] || [[ -n "$SSH_CONNECTION" ]]; then
	add-zsh-hook preexec fix_ssh_agent
fi
