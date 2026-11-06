# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

if [[ -z "${LANG:-}" ]]; then
    # load locale.conf in XDG paths
    # /etc/locale.conf loads and overrides by kernel command line is done by systemd
    if [[ -n "$XDG_CONFIG_HOME" && -r "$XDG_CONFIG_HOME/locale.conf" ]]; then
        source "$XDG_CONFIG_HOME/locale.conf"
    elif [[ -r /etc/locale.conf ]]; then
        source /etc/locale.conf
    fi

    # define default LANG to C if not already defined
    : "${LANG:=C}"

    # export all locale (7) variables when they exist
    export LANG LC_ADDRESS LC_COLLATE LC_CTYPE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY
    export LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME
fi

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
    export LC_CTYPE=${LANG%%:*}
fi

# export LANGUAGE="${LANGUAGE:-ru:nl}"
