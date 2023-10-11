# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => Automatically start tmux on ssh connection. Logout on detach ------------------------------------------------- {{{1

if [[ -z "$TMUX" ]] && ! [[ "${SSH_CLIENT}" =~ /::1/ ]] && ! [[ "${SSH_CLIENT}" =~ /127.0.0/ ]]; then
	exec tmux new-session -s ssh-auto -A
fi

# => Automatically grant permissions on shared session ------------------------------------------------------------ {{{1

TMUX_SHARED_SOCKET="/tmp/tmux-shared-socket-$USER"
if [[ -S "$TMUX_SHARED_SOCKET" ]]; then
	chmod go+rw "$TMUX_SHARED_SOCKET"
fi

# => -------------------------------------------------------------------------------------------------------------- {{{1

# if [[ -z "$TMUX" ]]; then
# 	typeset -Hg dotprofile_executed="login"
# else
# 	typeset -Hg dotprofile_executed="tmux"
# fi

# => SSH agent --------------------------------------------------------------------------------------------------- {{{1

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_TTY" ]]; then
### for remote sessions
	_is_ssh_auth_sock_ok || _try_existing_ssh_auth_sock_term || echo 'No SSH_AUTH_SOCK found'
else
### for local sessions
	### check and reuse existing running ssh agent
	_is_ssh_auth_sock_ok || _try_existing_ssh_auth_sock

	### start ssh-agent if it's not runnig
	#_check_auth_sock || _check_gpg_agent || _check_ssh_agent || _start_ssh_agent

	### SSH make common link to auth socket link
	#if [[ -z "$TMUX" ]]; then
	#	if [[ -n "$SSH_AUTH_SOCK" ]]; then
	#		ln -sf "$SSH_AUTH_SOCK" "$HOME/.cache/SSH_AUTH_SOCK"
	##		export SSH_AUTH_SOCK_ORIG=$SSH_AUTH_SOCK
	#	fi
	#else
	#	export SSH_AUTH_SOCK="$HOME/.cache/SSH_AUTH_SOCK"
	#fi
fi

[[ -n "$is_tty" ]] && {
	source-file "$XDG_CONFIG_HOME/shell/profile.work"
}
