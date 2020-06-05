# vim: syntax=zsh foldmethod=marker

[[ -n "$ZSH_TRACE" ]] && echo ".config/zsh/.zshenv: $$"

# => enable profiler --------------------------------------------------------------------------------------------- {{{1

#zmodload zsh/zprof

# => zsh init vital helprer functions ---------------------------------------------------------------------------- {{{1

function source-file() {
	for FILE in "$@"; do
		[[ -n "$ZSH_TRACE" ]] && echo "source: $(date) '$FILE'"
		[[ -r "$FILE" ]] && source "$FILE"
	done
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

# => include common environment ---------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/shell/env"
[[ -n "$WINDIR" ]] && source-file "$XDG_CONFIG_HOME/shell/env.msys2"

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# => hide all ZSH configuration related environment variables ---------------------------------------------------- {{{1

typeset -Hg ADOTDIR HISTFILE HISTORY_BASE HYPHEN_INSENSITIVE REPORTTIME ZSH_CACHE_DIR ZSH_COMPDUMP
ADOTDIR=$XDG_CACHE_HOME/antigen
HISTFILE=$XDG_CONFIG_HOME/z_history
HISTORY_BASE=$XDG_CACHE_HOME/per-directory-history
HYPHEN_INSENSITIVE=1
REPORTTIME=10
ZSH_CACHE_DIR=$XDG_CACHE_HOME
ZSH_COMPDUMP=$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}

typeset -AHg DIRSTACK
DIRSTACK['file']="$XDG_CACHE_HOME/z_dirs"
DIRSTACK['size']=20
