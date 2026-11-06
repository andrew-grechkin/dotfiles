# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

if [[ ! -o login && -r /etc/motd ]]; then
    < /etc/motd
fi
