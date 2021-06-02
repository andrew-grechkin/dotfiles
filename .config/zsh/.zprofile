# vim: filetype=zsh foldmethod=marker

[[ -n "$is_tty" ]] && {
	source-file "$XDG_CONFIG_HOME/shell/profile"
	source-file "$XDG_CONFIG_HOME/shell/profile.work"
}
