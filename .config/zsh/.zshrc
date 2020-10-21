# vim: syntax=zsh foldmethod=marker

[[ -n "$ZSH_TRACE" ]] && echo ".config/zsh/.zshrc: $$"

source-file "$XDG_CONFIG_HOME/shell/rc"
source-file "$XDG_CONFIG_HOME/shell/rc.work"

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

# => PATH prepare ------------------------------------------------------------------------------------------------ {{{1

typeset -U PATH path
[[ -n "$GOPATH"          ]] && [[ -d "$GOPATH"          ]] && path+=("$GOPATH/bin")
[[ -n "$GEM_HOME"        ]] && [[ -d "$GEM_HOME"        ]] && path+=("$GEM_HOME/bin")
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/bin"       "${path[@]}")
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/sbin"      "${path[@]}")
[[ -n "$PERLBREW_PATH"                                  ]] && path=("${(ps/:/)PERLBREW_PATH[@]}" "${path[@]}")
[[ -d "$HOME/.local/bin"                                ]] && path=("$HOME/.local/bin"           "${path[@]}")
[[ -d "$HOME/.local/scripts"                            ]] && path=("$HOME/.local/scripts"       "${path[@]}")
[[ -d "$HOME/.cache/bin"                                ]] && path=("$HOME/.cache/bin"           "${path[@]}")

# => Use zsh help search ----------------------------------------------------------------------------------------- {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# => show profiler ----------------------------------------------------------------------------------------------- {{{1

#zprof
