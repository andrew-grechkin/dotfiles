# vim: syntax=zsh foldmethod=marker

function install-linuxbrew() {
	local HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-${HOME}/.cache/linuxbrew}
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
}

function enable-linuxbrew() {
	local HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-${HOME}/.cache/linuxbrew}
	[[ -e "${HOMEBREW_PREFIX}/Homebrew/bin/brew" ]] && eval "$("${HOMEBREW_PREFIX}/Homebrew/bin/brew" shellenv)"
}

enable-linuxbrew
