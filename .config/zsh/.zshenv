# vim: filetype=zsh foldmethod=marker

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

typeset -Hg ADOTDIR HISTORY_BASE HYPHEN_INSENSITIVE REPORTTIME ZSH_CACHE_DIR ZSH_COMPDUMP
ADOTDIR=$XDG_CACHE_HOME/antigen
HISTORY_BASE=$XDG_CACHE_HOME/per-directory-history
HYPHEN_INSENSITIVE=1
REPORTTIME=10
ZSH_CACHE_DIR=$XDG_CACHE_HOME
ZSH_COMPDUMP=$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}

typeset -AHg DIRSTACK
DIRSTACK['file']="$XDG_CACHE_HOME/z_dirs"
DIRSTACK['size']=20

tty &>/dev/null && typeset -Hg is_tty=1

# => PATH prepare (tail) ----------------------------------------------------------------------------------------- {{{1

typeset -U PATH path
[[ -d "$HOME/.local/bin"                                ]] && path+=("$HOME/.local/bin")
[[ -d "$HOME/.local/scripts"                            ]] && path+=("$HOME/.local/scripts")
[[ -d "$HOME/.local/usr/bin"                            ]] && path+=("$HOME/.local/usr/bin")
[[ -d "$HOME/.cache/bin"                                ]] && path+=("$HOME/.cache/bin")
[[ -d "$HOME/.cache/fzf/bin"                            ]] && path+=("$HOME/.cache/fzf/bin")
[[ -n "$GOPATH"          ]] && [[ -d "$GOPATH"          ]] && path+=("$GOPATH/bin")
[[ -n "$GEM_HOME"        ]] && [[ -d "$GEM_HOME"        ]] && path+=("$GEM_HOME/bin")

export PATH
