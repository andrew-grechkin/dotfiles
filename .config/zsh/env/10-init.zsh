# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => ensure vital env --------------------------------------------------------------------------------------------- {{{1

# NOTE: environment.d is not a cure. Plasma starts login shell in parallel with environment.d and these variables are
# not defined, because of a race condition

[[ -n "${XDG_CACHE_HOME:-}"  ]] || export XDG_CACHE_HOME="$HOME/.cache"
[[ -n "${XDG_CONFIG_HOME:-}" ]] || export XDG_CONFIG_HOME="$HOME/.config"
[[ -n "${XDG_DATA_HOME:-}"   ]] || export XDG_DATA_HOME="$HOME/.local/share"
[[ -n "${XDG_RUNTIME_DIR:-}" ]] || export XDG_RUNTIME_DIR="/run/user/$(id -u)"
[[ -n "${XDG_STATE_HOME:-}"  ]] || export XDG_STATE_HOME="$HOME/.local/state"
[[ -n "${HOSTNAME:-}"        ]] || export HOSTNAME="${HOST:-$(hostname)}"

# => create necessary dirs ---------------------------------------------------------------------------------------- {{{1

[[ -e "$XDG_CACHE_HOME/zsh"  ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
[[ -e "$XDG_CONFIG_HOME"     ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ -e "$XDG_DATA_HOME"       ]] || mkdir -p "$XDG_DATA_HOME"
[[ -e "$XDG_RUNTIME_DIR/zsh" ]] || install -m 700 -d "$XDG_RUNTIME_DIR/zsh" &>/dev/null
[[ -e "$XDG_STATE_HOME"      ]] || mkdir -p "$XDG_STATE_HOME"
