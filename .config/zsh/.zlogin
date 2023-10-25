# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => environment -------------------------------------------------------------------------------------------------- {{{1

export LESSHISTFILE=-

if [[ "$IS_NAS" == "1" ]]; then
	export PAGER="less"
elif [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
	# on kvm use defaults
	true
else
	export HAS_MOUSE='1'
	export LESS='-x4 -iRSw --mouse'
fi

# => Automatically grant permissions on shared session ------------------------------------------------------------ {{{1

TMUX_SHARED_SOCKET="/tmp/tmux-shared-socket-$USER"
if [[ -S "$TMUX_SHARED_SOCKET" ]]; then
	chmod go+rw "$TMUX_SHARED_SOCKET"
fi

# => NAS related -------------------------------------------------------------------------------------------------- {{{1

function nas-clear-cruft() {
	sudo fd -Lus --prune -t d -F '@eaDir' -x sudo rm -rf
}

function nas-fix-permissions() {
	USER="${1:-$USER}"
	USER="$USER" GROUP="$(id -ng $USER)" nice "$SHELL" -c '
		set -e

		sudo chown "${USER}:${GROUP}" -R -- *
		sudo chmod -R a+rX,ug+w,o-w -- *
		sudo fd -u -E "@eaDir" -t d -x chmod g+s

		if [[ -e ".gnupg" ]]; then
			sudo chmod -R u=rwX,go-rwx,g-s "$(realpath .gnupg)"
		fi
		if [[ -e ".ssh" ]]; then
			sudo chmod -R u=rwX,go-rwx,g-s "$(realpath .ssh)"
		fi
	'
}

function nas-unset-executable() {
	fd -u -E '@eaDir' -t x -x chmod a-x
}

# => proxy related ------------------------------------------------------------------------------------------------ {{{1

function disable-proxy() {
	unset all_proxy
	unset http_proxy
	unset https_proxy
	export no_proxy="*"
}

# => local development activation --------------------------------------------------------------------------------- {{{1

# shellcheck source=/dev/null
function activate() {
	FILES=("dev.rc" ".venv/bin/activate")

	if command git rev-parse HEAD &>/dev/null; then
		REPO_ROOT="$(git rev-parse --show-toplevel)"

		FILES+=("${FILES[@]/#/$REPO_ROOT/}")
		FILES+=("$REPO_ROOT/projects/deployments/dev.rc")
	fi

	for FILE in "${FILES[@]}"; do
		if [[ -r "$FILE" ]]; then
			source "$FILE"
			return
		fi
	done

	if [[ -r "poetry.lock" ]]; then
		if command -v poetry &>/dev/null; then
			PYTHON_LOCAL="$(poetry env info -p)"
			source "$PYTHON_LOCAL/bin/activate"
			return
		fi
	fi

	tput bold && tput setaf 1
	echo "Unable to find any activation scripts"
	tput sgr0
}

# => generate CDPATH ---------------------------------------------------------------------------------------------- {{{1

function gen-cdpath() {
	setopt NULL_GLOB
	declare -a DIRS
	for FILE in "$HOME"/git "$HOME"/git/* "/usr/local/git_tree"; do
		[[ -d "${FILE%/}" ]] && DIRS+=("${FILE%/}")
	done

	local IFS=:
	export CDPATH="${DIRS[*]}"
	unset -f gen-cdpath
} &>/dev/null

gen-cdpath

# => -------------------------------------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/shell/login.work"
