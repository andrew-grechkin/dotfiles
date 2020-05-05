# vim: syntax=zsh foldmethod=marker

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

[[ -n "$GOPATH"          ]] && [[ -d "$GOPATH"          ]] && _appendvar PATH "$GOPATH/bin"
[[ -n "$GEM_HOME"        ]] && [[ -d "$GEM_HOME"        ]] && _appendvar PATH "$GEM_HOME/bin"
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && _prependvar PATH "$HOMEBREW_PREFIX/bin"
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && _prependvar PATH "$HOMEBREW_PREFIX/sbin"
[[ -n "$PERLBREW_PATH"         ]] && _prependvar PATH "$PERLBREW_PATH"
[[ -d "$HOME/.local/bin"       ]] && _prependvar PATH "$HOME/.local/bin"
[[ -d "$HOME/.local/scripts"   ]] && _prependvar PATH "$HOME/.local/scripts"
[[ -d "$HOME/.cache/bin"       ]] && _prependvar PATH "$HOME/.cache/bin"
export PATH

# => show profiler ----------------------------------------------------------------------------------------------- {{{1

#zprof
