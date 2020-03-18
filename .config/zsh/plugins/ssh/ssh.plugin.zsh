# vim: syntax=zsh foldmethod=marker

# => functions --------------------------------------------------------------------------------------------------- {{{1

function ssh-use-openssh-agent() {
	systemctl --user start ssh-agent.service
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/S.ssh-agent"
}

function ssh-use-gnome-agent() {
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/keyring/ssh"
}

function ssh-use-gnupg-agent() {
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
}
