# vim: syntax=zsh foldmethod=marker

function fix-gpg-tty() {
	### use systemd-gpgagent as ssh-agent (not working correctly in tmux)
	# Set GPG TTY
	export GPG_TTY=$(tty)

	# Refresh gpg-agent tty in case user switches into an X session
	gpg-connect-agent updatestartuptty /bye >/dev/null
}
