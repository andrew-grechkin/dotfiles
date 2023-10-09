# vim: filetype=zsh foldmethod=marker

[[ -d "$HOME/.config/environment.d" ]] && {
	for FILE in "$HOME/.config/environment.d"/*; do
		source "$FILE" && {
			VARS=("${(f)$(< <(sed -nE '/^[[:space:]]*#/d; s/^[[:space:]]*([[:alpha:]_][[:alnum:]_]+)=.+/\1/p' "$FILE"))}")
			export "${VARS[@]}"
		}
	done
}

[[ -z "$ZSH_INITED" ]] && {
	export ZSH_INITED=1

	[[ -r "$XDG_CONFIG_HOME/zsh/.zshenv" ]] && source "$XDG_CONFIG_HOME/zsh/.zshenv"
}
