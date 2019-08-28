# vim: syntax=zsh foldmethod=marker

if tty 2>&1 > /dev/null; then
	source-file "$XDG_CONFIG_HOME/my/profile"
	source-file "$XDG_CONFIG_HOME/my/profile.booking"
fi
