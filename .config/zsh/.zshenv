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
	[[ -r "$1" ]] && {
		# [[ -w "${1}" ]] && [[ "${1}" -nt "${1}.zwc" ]] && zcompile "$1"
		builtin source "$1"
	}
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

typeset -Hg HISTORY_BASE HYPHEN_INSENSITIVE REPORTTIME ZSH_CACHE_DIR ZSH_COMPDUMP
HISTORY_BASE=$XDG_CACHE_HOME/per-directory-history
HYPHEN_INSENSITIVE=1
REPORTTIME=10
ZSH_CACHE_DIR=$XDG_CACHE_HOME
ZSH_COMPDUMP=$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}

typeset -AHg DIRSTACK
DIRSTACK['file']="$XDG_CACHE_HOME/z_dirs"
DIRSTACK['size']=20

tty &>/dev/null && typeset -Hg is_tty=1
