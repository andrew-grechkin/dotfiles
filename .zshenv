# vim: filetype=zsh foldmethod=marker

# XDG_RUNTIME_DIR might be empty after ssh or su under user
[[ -z "${XDG_RUNTIME_DIR:-}" ]] && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

[[ -z "${ENVIRONMENT_D_LOADED:-}" && -d "$HOME/.config/environment.d" ]] && {
    # echo environment before environment.d parsed && env | sort
    for file in "$HOME/.config/environment.d"/*; do
        # read all variables from a file and then export them
        source "$file" && {
            vars=("${(f)$(< <(perl -lnE '/^[[:space:]]*([_[:alpha:]][_[:alnum:]]+?)=.+/ and print $1' "$file"))}")
            export "${vars[@]}"
        }
    done
}

if [[ "${1:-}" =~ startplasma ]] || [[ "${1:-}" =~ xdm/sys.xsession ]]; then
    [[ -r "$HOME/.xprofile" ]] && source "$HOME/.xprofile"
    exec "$@"
elif [[ -o LOGIN && -n "${SHELL:-}" ]]; then
    if umask=$(grep -m1 "^$USER:" /etc/passwd | grep -Pom1 'umask=\K\d+') 2>/dev/null; then
        umask "$umask"
    fi
    exec "$SHELL" -l "$@"
fi

# opensuse has quite a lot of shit in /etc/zshrc so the only option is to disable global configs if this file exists
if [[ "$IS_NAS" == "1" ]] || [[ -r /etc/zshrc && ! -d "/etc/boo""kings" ]]; then
    unsetopt GLOBAL_RCS
fi
