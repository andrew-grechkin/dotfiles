function fix-gpg-tty() {
	### use systemd-gpgagent as ssh-agent (not working correctly in tmux)
	# Set GPG TTY
	export GPG_TTY=$(tty)

	# Refresh gpg-agent tty in case user switches into an X session
	gpg-connect-agent updatestartuptty /bye >/dev/null
}

function encrypt-files() {
	for f in $@; do
		FILENAMEFULL=$(basename "$f")
		gpg --encrypt --output "./${FILENAMEFULL}.gpg" "$f"
	done
}

function decrypt-files() {
#	gpg --decrypt-files $@
	for f in $@; do
		FILENAMEFULL=$(basename "$f")
		gpg --decrypt --output "./${FILENAMEFULL/.gpg}" "$f"
	done
}
