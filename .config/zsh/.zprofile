# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => Automatically start tmux on ssh connection. Logout on detach ------------------------------------------------- {{{1

if [[ "$XDG_CURRENT_DESKTOP" != "ubuntu:GNOME" ]] \
		&& [[ -z "$TMUX" ]]                       \
		&& [[ -z "$ZELLIJ" ]]                     \
		&& ! [[ "${SSH_CLIENT}" =~ /::1/ ]]       \
		&& ! [[ "${SSH_CLIENT}" =~ /127.0.0/ ]]   \
		&& [[ -x "$(command -v tmux)" ]]; then
	exec tmux new-session -s ssh-auto -A
fi

# => SSH agent check and start ------------------------------------------------------------------------------------ {{{1

#SSH_AGENTS=(
#	"${XDG_RUNTIME_DIR}/keyring/ssh"           # Gnome keyring agent
#	"${XDG_RUNTIME_DIR}/S.ssh-agent"           # OpenSSH agent
#	"${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" # Gnupg ssh agent
#)
#
#function _is_ssh_auth_sock_ok() {
#	[[ -n "$SSH_AUTH_SOCK" ]] && [[ -S "$SSH_AUTH_SOCK" ]]
#}
#
#function _try_existing_ssh_auth_sock_term() {
#	test -S "$AGENT" && export SSH_AUTH_SOCK="${SSH_AGENTS[1]}" && return 0
#	return 2
#}
#
#function _try_existing_ssh_auth_sock() {
#	for AGENT in "${SSH_AGENTS[@]}"; do
#		test -S "$AGENT" && export SSH_AUTH_SOCK="$AGENT" && return 0
#	done
#	return 2
#}
#
#function _check_gpg_agent() {
#	source-file "$XDG_CACHE_HOME/gpg-agent.rc" && _check_auth_sock
#}
#
#function _check_ssh_agent() {
#	source-file "$XDG_CACHE_HOME/ssh-agent.rc" && _check_auth_sock && [[ -n "$SSH_AGENT_PID" && -e "/proc/$SSH_AGENT_PID" ]]
#}
#
#function _start_ssh_agent() {
#	local SSHAGENT='/usr/bin/ssh-agent'
#	local SSHAGENTARGS=(-s)
#
#	if [[ -x "$SSHAGENT" ]]; then
#		# eval `$SSHAGENT $SSHAGENTARGS`
#		# trap "kill $SSH_AGENT_PID" 0
#		# shellcheck disable=2091
#		$("$SSHAGENT" "${SSHAGENTARGS[@]}" >"$XDG_CACHE_HOME/ssh-agent.rc")
#		source-file "$XDG_CACHE_HOME/ssh-agent.rc"
#	fi
#
#	# add ssh keys if empty
#	# RESULT=$(ssh-add -l 2>/dev/null | grep '.ssh/id_')
#	# if [[ "0" = "${#RESULT}" ]]; then
#	# ssh-add
#	# fi
#}
#
#if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_TTY" ]]; then
#### for remote sessions
#	_is_ssh_auth_sock_ok || _try_existing_ssh_auth_sock_term || echo 'No SSH_AUTH_SOCK found'
#else
#### for local sessions
#	### check and reuse existing running ssh agent
#	_is_ssh_auth_sock_ok || _try_existing_ssh_auth_sock
#
#	### start ssh-agent if it's not runnig
#	#_check_auth_sock || _check_gpg_agent || _check_ssh_agent || _start_ssh_agent
#
#	### SSH make common link to auth socket link
#	#if [[ -z "$TMUX" ]]; then
#	#	if [[ -n "$SSH_AUTH_SOCK" ]]; then
#	#		ln -sf "$SSH_AUTH_SOCK" "$HOME/.cache/SSH_AUTH_SOCK"
#	##		export SSH_AUTH_SOCK_ORIG=$SSH_AUTH_SOCK
#	#	fi
#	#else
#	#	export SSH_AUTH_SOCK="$HOME/.cache/SSH_AUTH_SOCK"
#	#fi
#fi
