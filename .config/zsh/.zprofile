# vim: syntax=zsh foldmethod=marker

if tty &>/dev/null; then
	source-file "$XDG_CONFIG_HOME/shell/profile"
	source-file "$XDG_CONFIG_HOME/shell/profile.work"
fi
