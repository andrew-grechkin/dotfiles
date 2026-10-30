# vim: filetype=zsh foldmethod=marker

# XDG_RUNTIME_DIR might be empty after ssh or su under user
if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    install -m 700 -d "$XDG_RUNTIME_DIR" &>/dev/null
fi

# NOTE: for UI sessions
[[ "${1:-}" =~ startplasma      ]] && return 0
[[ "${1:-}" =~ xdm/sys.xsession ]] && { [[ -r "$HOME/.xprofile" ]] && source "$HOME/.xprofile"; return 0; }

# NOTE: for interactive SSH sessions
if [[ -o interactive && -n "${SHELL:-}" && -z "${TMUX:-}" ]]; then
    # NOTE: best effort to implement environment.d for ssh sessions
    if [[ -z "${ENVIRONMENT_D_LOADED:-}" && -d "$HOME/.config/environment.d" ]]; then
        export ENVIRONMENT_D_LOADED=1

        # echo environment before environment.d parsed && env | sort
        for __init_conf in "$HOME/.config/environment.d"/*.conf(-.N); do
            [[ "${_init_conf:t}" =~ zsh.conf$ ]] && continue
            # read all variables from a file
            source "$__init_conf" && __init_conf_files+=("$__init_conf")
        done

        if [[ -n "${__init_conf_files[*]}" ]]; then
            # export them
            __init_vars=("${(f)$(perl -lnE '/^[[:space:]]*([_[:alpha:]][_[:alnum:]]+?)=.+/ and print $1' "${__init_conf_files[@]}")}")
            export "${__init_vars[@]}"
        fi

        unset __init_conf __init_conf_files __init_vars
    fi

    if __init_umask=$(grep -m1 "^$USER:" /etc/passwd 2>/dev/null | grep -Pom1 'umask=\K\d+' 2>/dev/null); then
        umask "$__init_umask"
        unset __init_umask
    fi

    ZDOTDIR="$XDG_CONFIG_HOME/zsh" exec "$SHELL" -l "$@"
fi

# NOTE: opensuse has a lot of shit in /etc/zshrc so the only option is to disable global configs if this file exists
if [[ "$IS_NAS" == "1" ]] || [[ -r /etc/zshrc && ! -d "/etc/boo""kings" ]]; then
    unsetopt GLOBAL_RCS
fi
