# vim: filetype=zsh foldmethod=marker

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

alias       gpg-edit-card='gpg --edit-card'
alias            gpg-edit='gpg --expert --edit-key'
alias   gpg-export-public='gpg --export --armor'
alias     gpg-list-public='gpg --list-keys'
alias     gpg-list-secret='gpg --list-secret-keys'
alias gpg-list-signatures='gpg --list-signatures'
alias         gpg-refresh='gpg --refresh-keys --verbose'

# => functions ---------------------------------------------------------------------------------------------------- {{{1

function fix-gpg-tty() {
	### use systemd-gpgagent as ssh-agent (not working correctly in tmux)
	# Set GPG TTY
	export GPG_TTY=$(tty)

	# Refresh gpg-agent tty in case user switches into an X session
	gpg-connect-agent updatestartuptty /bye >/dev/null
}
