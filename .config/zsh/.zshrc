# vim: syntax=zsh foldmethod=marker

source-file "$XDG_CONFIG_HOME/my/rc"

# => Install antigen --------------------------------------------------------------------------------------------- {{{1

function install-antigen() {
	source       "$ZDOTDIR/antigen.zsh"
	antigen init "$ZDOTDIR/antigenrc.zsh"
}

if [[ ! -d ${ADOTDIR} ]]; then
	echo -n "Proceed with installing antigen and plugins (y/n/p)? "
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

[[ -n "$GOPATH"                ]] && _appendvar_head PATH "$GOPATH/bin"
[[ -n "$GEM_HOME"              ]] && _appendvar_head PATH "$GEM_HOME/bin"
[[ -n "$PERLBREW_PATH"         ]] && _appendvar_head PATH "$PERLBREW_PATH"
[[ -d "$HOME/.local/bin"       ]] && _appendvar_head PATH "$HOME/.local/bin"
[[ -d "$HOME/.local/scripts"   ]] && _appendvar_head PATH "$HOME/.local/scripts"
[[ -d "$HOME/.cache/bin"       ]] && _appendvar_head PATH "$HOME/.cache/bin"
export PATH

source-file "$XDG_CONFIG_HOME/my/rc.booking"
