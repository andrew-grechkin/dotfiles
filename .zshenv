# vim: filetype=zsh foldmethod=marker

if [[ "$IS_NAS" == "1" ]]; then
	unsetopt GLOBAL_RCS
fi

[[ -d "$HOME/.config/environment.d" ]] && {
	for FILE in "$HOME/.config/environment.d"/*; do
		source "$FILE" && {
			VARS=("${(f)$(< <(sed -nE '/^[[:space:]]*#/d; s/^[[:space:]]*([[:alpha:]_][[:alnum:]_]+)=.+/\1/p' "$FILE"))}")
			export "${VARS[@]}"
		}
	done
}

if [[ -o login ]]; then
	exec "$SHELL" -l
else
	exec "$SHELL"
fi
