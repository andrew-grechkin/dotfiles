# vim: filetype=zsh foldmethod=marker

[[ -n "$ZSH_TRACE" ]] && echo ".config/zsh/.zlogin: $$"

[[ -n "$is_tty" ]] && {
	source-file "$XDG_CONFIG_HOME/shell/login"
}
