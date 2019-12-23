# vim: syntax=zsh foldmethod=marker

if tty 2>&1 > /dev/null; then
	source-file "$XDG_CONFIG_HOME/shell/profile"
	source-file "$XDG_CONFIG_HOME/shell/profile.work"
fi
