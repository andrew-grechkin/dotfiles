# vim: filetype=zsh foldmethod=marker

# XDG_RUNTIME_DIR might be empty after ssh or su under user
[[ -z "${XDG_RUNTIME_DIR:-}" ]] && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

if [[ -z "${ENVIRONMENT_D_LOADED:-}" && -d "$HOME/.config/environment.d" ]]; then
    # echo environment before environment.d parsed && env | sort
    local file files=() vars=()
    for file in "$HOME/.config/environment.d"/*.conf(-.N); do
        # read all variables from a file
    [[ "${file:t}" =~ zsh.conf$ ]] && continue
        source "$file" && files+=("$file")
    done

    if [[ -n "${files[*]}" ]]; then
        # export them
        vars=("${(f)$(< <(perl -lnE '/^[[:space:]]*([_[:alpha:]][_[:alnum:]]+?)=.+/ and print $1' "${files[@]}"))}")
        export "${vars[@]}"
    fi
fi

if [[ "${1:-}" =~ startplasma ]] || [[ "${1:-}" =~ xdm/sys.xsession ]]; then
    [[ -r "$HOME/.xprofile" ]] && source "$HOME/.xprofile"
    exec "$@"
fi

if [[ -o INTERACTIVE && -n "${SHELL:-}" ]]; then
    if umask=$(grep -m1 "^$USER:" /etc/passwd | grep -Pom1 'umask=\K\d+') 2>/dev/null; then
        umask "$umask"
    fi
    ZDOTDIR="${XDG_CONFIG_HOME}/zsh" exec "$SHELL" -l "$@"
fi

# opensuse has quite a lot of shit in /etc/zshrc so the only option is to disable global configs if this file exists
if [[ "$IS_NAS" == "1" ]] || [[ -r /etc/zshrc && ! -d "/etc/boo""kings" ]]; then
    unsetopt GLOBAL_RCS
fi
