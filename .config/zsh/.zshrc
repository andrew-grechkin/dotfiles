# vim: filetype=zsh foldmethod=marker

source-file "$XDG_CONFIG_HOME/shell/rc"
source-file "$XDG_CONFIG_HOME/shell/rc.work"

export HISTFILE=$XDG_CONFIG_HOME/z_history

# => PATH prepare (tail) ----------------------------------------------------------------------------------------- {{{1

typeset -U PATH path
[[ -d "$HOME/.local/bin"                                ]] && path+=("$HOME/.local/bin")
[[ -d "$HOME/.local/script"                             ]] && path+=("$HOME/.local/script")
[[ -d "$HOME/.local/private-script"                     ]] && path+=("$HOME/.local/private-script")
[[ -d "$HOME/.local/usr/bin"                            ]] && path+=("$HOME/.local/usr/bin")
[[ -d "$HOME/.cache/bin"                                ]] && path+=("$HOME/.cache/bin")
[[ -d "$HOME/.cache/fzf/bin"                            ]] && path+=("$HOME/.cache/fzf/bin")
[[ -d "/volume1/local/arch/bin"                         ]] && path+=("/volume1/local/arch/bin")
[[ -d "/volume1/local/arch/usr/bin"                     ]] && path+=("/volume1/local/arch/usr/bin")
[[ -d "/volume1/local/arch/usr/bin/core_perl"           ]] && path+=("/volume1/local/arch/usr/bin/core_perl")
[[ -d "/volume1/local/arch/usr/bin/site_perl"           ]] && path+=("/volume1/local/arch/usr/bin/core_perl")
[[ -d "/volume1/local/arch/usr/bin/vendor_perl"         ]] && path+=("/volume1/local/arch/usr/bin/vendor_perl")
[[ -n "$GOPATH"                ]] && [[ -d "$GOPATH"                ]] && path+=("$GOPATH/bin")
[[ -n "$GEM_HOME"              ]] && [[ -d "$GEM_HOME"              ]] && path+=("$GEM_HOME/bin")
[[ -n "$XDG_DATA_HOME/npm/bin" ]] && [[ -d "$XDG_DATA_HOME/npm/bin" ]] && path+=("$XDG_DATA_HOME/npm/bin")

export PATH

# => Install antigen --------------------------------------------------------------------------------------------- {{{1

function install-antigen() {
	source       "$ZDOTDIR/antigen.zsh"
	antigen init "$ZDOTDIR/antigenrc.zsh"
}

if [[ ! -d "$ADOTDIR" ]]; then
	echo -n 'Proceed with installing antigen and plugins (y/n/p)? '
	read choice
	case "$choice" in
		y|Y )
			umask 022
			install-antigen
			;;
		p|P )
			enable-proxy
			umask 022
			install-antigen
			;;
		* )
			;;
	esac
else
	install-antigen
fi

# => PATH prepare (head) ----------------------------------------------------------------------------------------- {{{1

[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/bin"        "${path[@]}")
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/sbin"       "${path[@]}")
[[ -n "$PERLBREW_PATH"                                  ]] && path=("${(ps/:/)PERLBREW_PATH[@]}"  "${path[@]}")
[[ -d "$HOME/.local/bin"                                ]] && path=("$HOME/.local/bin"            "${path[@]}")
[[ -d "$HOME/.local/script"                             ]] && path=("$HOME/.local/script"         "${path[@]}")
[[ -d "$HOME/.local/private-script"                     ]] && path=("$HOME/.local/private-script" "${path[@]}")
[[ -d "$HOME/.cache/bin"                                ]] && path=("$HOME/.cache/bin"            "${path[@]}")

export PATH

WORDCHARS=${WORDCHARS/\/}

# => Use zsh help search ----------------------------------------------------------------------------------------- {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# => show profiler ----------------------------------------------------------------------------------------------- {{{1

# zprof
