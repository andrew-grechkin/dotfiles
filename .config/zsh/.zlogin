# vim: syntax=zsh foldmethod=marker

[[ -n "$ZSH_TRACE" ]] && echo ".config/zsh/.zlogin: $$"

if tty &>/dev/null; then
	source-file "$XDG_CONFIG_HOME/shell/login"
fi
