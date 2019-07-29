# vim: syntax=zsh foldmethod=marker

# => zsh init helprer functions ---------------------------------------------------------------------------------- {{{1

function source-file() {
#    echo "source: '$1'"
	[[ -r "$1" ]] && source "$1"
}

function _appendvar_head() {
	local VAR=$1
	local CONTENT=${(P)VAR}
	local APPEND=$2
	case ":${CONTENT}:" in
		*:"$APPEND":*)
			;;
		*)
			CONTENT=$APPEND${CONTENT:+:$CONTENT}
			eval "$VAR=$CONTENT"
	esac
}

function _appendvar_tail() {
	local VAR=$1
	local CONTENT=${(P)VAR}
	local APPEND=$2
	case ":${CONTENT}:" in
		*:"$APPEND":*)
			;;
		*)
			CONTENT=${CONTENT:+$CONTENT:}$APPEND
			eval "$VAR=$CONTENT"
	esac
}

# => include common environment ---------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/my/env"
[[ -n "$WINDIR" ]] && source-file "$XDG_CONFIG_HOME/my/env.msys2"

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
