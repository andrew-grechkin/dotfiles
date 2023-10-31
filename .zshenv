# vim: filetype=zsh foldmethod=marker

if [[ "$IS_NAS" == "1" ]]; then
	unsetopt GLOBAL_RCS
fi

[[ -d "$HOME/.config/environment.d" ]] && {
	for FILE in "$HOME/.config/environment.d"/*; do
		# read all variables from file and then export them
		source "$FILE" && {
			VARS=("${(f)$(< <(sed -nE '/^[[:space:]]*#/d; s/^[[:space:]]*([[:alpha:]_][[:alnum:]_]+?)=.+/\1/p' "$FILE"))}")
			export "${VARS[@]}"
		}
	done
}

if [[ "${1:-}" =~ startplasma ]]; then
	[[ -r "$HOME/.xprofile" ]] && source "$HOME/.xprofile"
	exec "$@"
elif [[ -o LOGIN ]]; then
	exec "$SHELL" -l
else
	# do nothing
fi
