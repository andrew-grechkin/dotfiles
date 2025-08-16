# vim: filetype=zsh foldmethod=marker

# XDG_RUNTIME_DIR might be empty after ssh or su under user
[[ -z "${XDG_RUNTIME_DIR:-}" ]] && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

[[ -z "${ENVIRONMENT_D_LOADED:-}" && -d "$HOME/.config/environment.d" ]] && {
	# echo environment before environment.d parsed
	# env | sort
	for FILE in "$HOME/.config/environment.d"/*; do
		# read all variables from file and then export them
		source "$FILE" && {
			VARS=("${(f)$(< <(sed -nE '/^[[:space:]]*#/d; s/^[[:space:]]*([[:alpha:]_][[:alnum:]_]+?)=.+/\1/p' "$FILE"))}")
			export "${VARS[@]}"
		}
	done
}

if [[ "${1:-}" =~ startplasma ]] || [[ "${1:-}" =~ xdm/sys.xsession ]]; then
	[[ -r "$HOME/.xprofile" ]] && source "$HOME/.xprofile"
	exec "$@"
elif [[ -o LOGIN && -n "${SHELL:-}" ]]; then
	exec "$SHELL" -l "$@"
fi

# opensuse has quite a lot of shit in /etc/zshrc so the only option is to disable global configs if this file exists
if [[ "$IS_NAS" == "1" ]] || [[ -r /etc/zshrc && ! -d "/etc/boo""kings" ]]; then
	unsetopt GLOBAL_RCS
fi
