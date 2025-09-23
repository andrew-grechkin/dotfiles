() {
    if [[ -d "${XDG_CONFIG_HOME:=$HOME/.config}/git/config.d" ]]; then

        # use delta only if it's installed on the system
        if (( $+commands[delta] )); then
            cat << 'EO_GIT_DELTA_CONF' > "$XDG_CONFIG_HOME/git/config.d/delta.dynamic"
# vim: filetype=gitconfig

[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only --features=interactive

[pager]
    blame  = delta
    diff   = delta
    log    = delta
    reflog = delta
    sh     = delta
    show   = delta
EO_GIT_DELTA_CONF
        fi

        # stop polluting .git dirs with sockets and use XDG_RUNTIME_DIR for that
        local socket_dir="${XDG_RUNTIME_DIR:-/tmp}/git"
        mkdir -p "$socket_dir" &>/dev/null

        cat << EO_GIT_FSMONITOR_CONF > "$XDG_CONFIG_HOME/git/config.d/fsmonitor.dynamic"
# vim: filetype=gitconfig

[fsmonitor]
    socketDir = $socket_dir
EO_GIT_FSMONITOR_CONF
    fi
}

# vim: filetype=sh foldmethod=marker
