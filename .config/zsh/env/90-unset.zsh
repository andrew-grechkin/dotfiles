# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# opensuse has quite a lot of shit in /etc/zshrc so the only option is to disable global configs if this file exists
if [[ "$IS_NAS" == "1" ]] || [[ -r /etc/zshrc && ! -d "/etc/boo""kings" ]]; then
    unsetopt GLOBAL_RCS
fi
