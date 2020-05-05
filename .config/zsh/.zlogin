# vim: syntax=zsh foldmethod=marker

if tty &>/dev/null; then
	source-file "$XDG_CONFIG_HOME/shell/login"
fi
