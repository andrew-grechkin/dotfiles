# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

if [[ "$IS_NAS" == "1" ]]; then
	unsetopt GLOBAL_RCS
fi

# => enable profiler ---------------------------------------------------------------------------------------------- {{{1

# setopt SOURCE_TRACE

# zmodload zsh/zprof

# => zsh init vital helprer functions ----------------------------------------------------------------------------- {{{1

function source-file() {
	if [[ -r "$1" ]]; then
		# [[ -w "${1}" ]] && [[ "${1}" -nt "${1}.zwc" ]] && zcompile "$1"
		builtin source "$1"
	else
		true
	fi
}

function _prependvar() {
	local CURRENT_VALUE=${(P)1}
	case ":${CURRENT_VALUE}:" in
		*:"$2":*) ;;
		*) eval "$1=${2}${CURRENT_VALUE:+:$CURRENT_VALUE}" ;;
	esac
}

function _appendvar() {
	local CURRENT_VALUE=${(P)1}
	case ":${CURRENT_VALUE}:" in
		*:"$2":*) ;;
		*) eval "$1=${CURRENT_VALUE:+$CURRENT_VALUE:}$2" ;;
	esac
}

# => make necessary dirs ------------------------------------------------------------------------------------------ {{{1

[[ -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ -e "$XDG_CACHE_HOME"  ]] || mkdir -p "$XDG_CACHE_HOME"
[[ -e "$XDG_DATA_HOME"   ]] || mkdir -p "$XDG_DATA_HOME"

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg ZSH_CACHE_DIR ZSH_COMPDUMP
ZSH_CACHE_DIR=$XDG_CACHE_HOME
ZSH_COMPDUMP=$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}

# tty &>/dev/null && typeset -Hg is_tty=1
# [[ -o INTERACTIVE ]] && typeset -Hg is_tty=1

# => set PATH ----------------------------------------------------------------------------------------------------- {{{1

if [[ "$IS_NAS" == "1" ]]; then
	_prependvar PATH "/volume1/@appstore/ffmpeg/bin"
	[[ -d "/var/packages/arch/bin"      ]] && _prependvar PATH "/var/packages/arch/bin"
	[[ -d "/volume1/local/arch/bin"     ]] && _prependvar PATH "/volume1/local/arch/bin"
	[[ -d "/volume1/local/arch/usr/bin" ]] && _prependvar PATH "/volume1/local/arch/usr/bin"
fi

# => PATH prepare (tail) ------------------------------------------------------------------------------------------ {{{1

typeset -U PATH path
[[ -d "$HOME/.local/bin"                                ]] && path+=("$HOME/.local/bin")
[[ -d "$HOME/.local/script"                             ]] && path+=("$HOME/.local/script")
[[ -d "$HOME/.local/script-private"                     ]] && path+=("$HOME/.local/script-private")
[[ -d "$HOME/.local/script-work"                        ]] && path+=("$HOME/.local/script-work")
[[ -d "$HOME/.local/usr/bin"                            ]] && path+=("$HOME/.local/usr/bin")
[[ -d "$HOME/.cache/bin"                                ]] && path+=("$HOME/.cache/bin")
[[ -d "$HOME/.cache/fzf/bin"                            ]] && path+=("$HOME/.cache/fzf/bin")
[[ -d "$HOME/.cache/go/bin"                             ]] && path+=("$HOME/.cache/go/bin")
[[ -d "$HOME/.local/share/nvim/mason/bin"               ]] && path+=("$HOME/.local/share/nvim/mason/bin")
[[ -d "/volume1/local/arch/bin"                         ]] && path+=("/volume1/local/arch/bin")
[[ -d "/volume1/local/arch/usr/bin"                     ]] && path+=("/volume1/local/arch/usr/bin")
[[ -d "/volume1/local/arch/usr/bin/core_perl"           ]] && path+=("/volume1/local/arch/usr/bin/core_perl")
[[ -d "/volume1/local/arch/usr/bin/site_perl"           ]] && path+=("/volume1/local/arch/usr/bin/core_perl")
[[ -d "/volume1/local/arch/usr/bin/vendor_perl"         ]] && path+=("/volume1/local/arch/usr/bin/vendor_perl")
[[ -n "$GOPATH"                ]] && [[ -d "$GOPATH"                ]] && path+=("$GOPATH/bin")
# [[ -n "$GEM_HOME"              ]] && [[ -d "$GEM_HOME"              ]] && path+=("$GEM_HOME/bin")
[[ -n "$XDG_DATA_HOME/npm/bin" ]] && [[ -d "$XDG_DATA_HOME/npm/bin" ]] && path+=("$XDG_DATA_HOME/npm/bin")

export PATH
