# vim: syntax=zsh foldmethod=marker

# => exports ----------------------------------------------------------------------------------------------------- {{{1

export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$XDG_DATA_HOME/linuxbrew}

# => functions --------------------------------------------------------------------------------------------------- {{{1

function install-linuxbrew() {
	#sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	umask 022
	mkdir -p "$HOMEBREW_PREFIX"
	"$HOME/.local/bin/install-linuxbrew"
}

function enable-linuxbrew() {
	[[ -e "${HOMEBREW_PREFIX}/bin/brew" ]] && eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
	[[ -e "${HOMEBREW_PREFIX}/bin/brew" ]] && FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
}

# => main -------------------------------------------------------------------------------------------------------- {{{1

enable-linuxbrew
