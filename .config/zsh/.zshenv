# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# workaround for stupid zellij start shell as non-login 🤷
if [[ "$ZELLIJ" == "0" ]] && [[ ! -o LOGIN ]] && [[ -o INTERACTIVE ]] && [[ -z "$LOGIN_SESSION_ENFORCED" ]]; then
	export LOGIN_SESSION_ENFORCED=1
	exec "$SHELL" -l
fi

# opensuse has quite a lot of shit in /etc/zshrc so the only option is to disable global configs if this file exists
if [[ "$IS_NAS" == "1" ]] || [[ -r /etc/zshrc && ! -d "/etc/boo""kings" ]]; then
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

function append_path() {
	for DIR in "$@"; do
		[[ -n "$DIR" ]] && [[ -d "$DIR" ]] && path+=("$DIR")
	done
}

# => environment -------------------------------------------------------------------------------------------------- {{{1

if [[ -z "$LANG" ]]; then
	# load locale.conf in XDG paths.
	# /etc/locale.conf loads and overrides by kernel command line is done by systemd
	if [[ -n "$XDG_CONFIG_HOME" ]] && [[ -r "$XDG_CONFIG_HOME/locale.conf" ]]; then
		. "$XDG_CONFIG_HOME/locale.conf"
	elif [[ -n "$HOME" ]] && [[ -r "$HOME/.config/locale.conf" ]]; then
		. "$HOME/.config/locale.conf"
	elif [[ -r /etc/locale.conf ]]; then
		. /etc/locale.conf
	fi

	# define default LANG to C if not already defined
	LANG="${LANG:-C}"

	# export all locale (7) variables when they exist
	export LANG LC_ADDRESS LC_COLLATE LC_CTYPE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY \
		LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME
fi

# export LANGUAGE="${LANGUAGE:-ru:nl}"

# => make necessary dirs ------------------------------------------------------------------------------------------ {{{1

[[ -e "$XDG_CACHE_HOME"  ]] || mkdir -p "$XDG_CACHE_HOME"
[[ -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ -e "$XDG_DATA_HOME"   ]] || mkdir -p "$XDG_DATA_HOME"
[[ -e "$XDG_STATE_HOME"  ]] || mkdir -p "$XDG_STATE_HOME"

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg ZSH_CACHE_DIR ZSH_COMPDUMP
ZSH_CACHE_DIR=$XDG_CACHE_HOME
ZSH_COMPDUMP=$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}

# tty &>/dev/null && typeset -Hg is_tty=1
# [[ -o INTERACTIVE ]] && typeset -Hg is_tty=1

# => set PATH ----------------------------------------------------------------------------------------------------- {{{1

if [[ "$IS_NAS" == "1" ]]; then
	_prependvar PATH "/volume1/@appstore/ffmpeg/bin"
	[[ -d "/var/packages/arch/bin"                  ]] && _prependvar PATH "/var/packages/arch/bin"
	[[ -d "/volume1/local/arch/usr/bin/vendor_perl" ]] && _prependvar PATH "/volume1/local/arch/usr/bin/vendor_perl"
	[[ -d "/volume1/local/arch/usr/bin"             ]] && _prependvar PATH "/volume1/local/arch/usr/bin"
	[[ -d "/volume1/local/arch/bin"                 ]] && _prependvar PATH "/volume1/local/arch/bin"
fi

# => common with bash (PATH setup) -------------------------------------------------------------------------------- {{{1

typeset -U PATH path

if [[ -n "$BASH_ENV" ]]; then
	source-file "$BASH_ENV"
fi
