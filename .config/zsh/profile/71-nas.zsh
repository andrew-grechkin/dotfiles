# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

if [[ "$IS_NAS" == "1" ]]; then
    path=("/volume1/@appstore/ffmpeg/bin" "${path[@]}")
    [[ -d "/var/packages/arch/bin"                  ]] && path=("/var/packages/arch/bin"                  "${path[@]}")
    [[ -d "/volume1/local/arch/usr/bin/vendor_perl" ]] && path=("/volume1/local/arch/usr/bin/vendor_perl" "${path[@]}")
    [[ -d "/volume1/local/arch/usr/bin"             ]] && path=("/volume1/local/arch/usr/bin"             "${path[@]}")
    [[ -d "/volume1/local/arch/bin"                 ]] && path=("/volume1/local/arch/bin"                 "${path[@]}")

    export PATH
fi
