# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

if [[ "$IS_NAS" == "1" ]]; then
	unsetopt GLOBAL_RCS
fi

# => enable profiler ---------------------------------------------------------------------------------------------- {{{1

# setopt SOURCE_TRACE

# zmodload zsh/zprof

# => zsh init vital helprer functions ----------------------------------------------------------------------------- {{{1

function source-file() {
#	for FILE in "$@"; do
#		[[ -r "$FILE" ]] && source "$FILE"
#	done
	[[ -r "$1" ]] && {
		# [[ -w "${1}" ]] && [[ "${1}" -nt "${1}.zwc" ]] && zcompile "$1"
		builtin source "$1"
	}
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

# => include common environment ----------------------------------------------------------------------------------- {{{1

export HOSTNAME="${HOSTNAME:-$(hostname)}"

if [[ -d "/volume1/local/arch/usr" ]]; then
	export PAGER="less"
elif [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
	# on kvm use defaults
	true
else
	export HAS_MOUSE='1'
	export LESS='-x4 -iRSw --mouse'
fi

# => make necessary dirs ------------------------------------------------------------------------------------------ {{{1

[[ -e "$XDG_CONFIG_HOME" ]] || mkdir -p "$XDG_CONFIG_HOME"
[[ -e "$XDG_CACHE_HOME"  ]] || mkdir -p "$XDG_CACHE_HOME"
[[ -e "$XDG_DATA_HOME"   ]] || mkdir -p "$XDG_DATA_HOME"

# => NAS related -------------------------------------------------------------------------------------------------- {{{1

function nas-clear-cruft() {
	sudo fd -Lus --prune -t d -F '@eaDir' -x sudo rm -rf
}

function nas-fix-permissions() {
	sudo chown "${USER}:users" -R -- *
	sudo chmod -R a+rX,ug+w,o-w -- *
	fd -u -E '@eaDir' -t d -x chmod g+s
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

# => SSH agent ---------------------------------------------------------------------------------------------------- {{{1

SSH_AGENTS=(
	"${XDG_RUNTIME_DIR}/keyring/ssh" # Gnome keyring agent
	"${XDG_RUNTIME_DIR}/S.ssh-agent" # OpenSSH agent
	"${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" # Gnupg ssh agent
)

function _is_ssh_auth_sock_ok() {
	[[ -n "$SSH_AUTH_SOCK" ]] && [[ -S "$SSH_AUTH_SOCK" ]]
}

function _try_existing_ssh_auth_sock_term() {
	test -S "$AGENT" && export SSH_AUTH_SOCK="${SSH_AGENTS[1]}" && return 0
	return 2
}

function _try_existing_ssh_auth_sock() {
	for AGENT in "${SSH_AGENTS[@]}"; do
		test -S "$AGENT" && export SSH_AUTH_SOCK="$AGENT" && return 0
	done
	return 2
}

function _check_gpg_agent() {
	[[ -n "$WINDIR" ]] && return 42
	source-file "$XDG_CACHE_HOME/gpg-agent.rc" && _check_auth_sock
}

function _check_ssh_agent() {
	source-file "$XDG_CACHE_HOME/ssh-agent.rc" && _check_auth_sock && [[ -n "$SSH_AGENT_PID" && -e "/proc/$SSH_AGENT_PID" ]]
}

function _start_ssh_agent() {
	local SSHAGENT='/usr/bin/ssh-agent'
	local SSHAGENTARGS=(-s)

	if [[ -x "$SSHAGENT" ]]; then
		# eval `$SSHAGENT $SSHAGENTARGS`
		# trap "kill $SSH_AGENT_PID" 0
		# shellcheck disable=2091
		$("$SSHAGENT" "${SSHAGENTARGS[@]}" >"$XDG_CACHE_HOME/ssh-agent.rc")
		source-file "$XDG_CACHE_HOME/ssh-agent.rc"
	fi

	# add ssh keys if empty
	# RESULT=$(ssh-add -l 2>/dev/null | grep '.ssh/id_')
	# if [[ "0" = "${#RESULT}" ]]; then
	# ssh-add
	# fi
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
	for FILE in "$HOME"/* "$HOME"/git/* "/usr/local/git_tree"; do
		[[ -d "${FILE%/}" ]] && DIRS+=("${FILE%/}")
	done

	local IFS=:
	export CDPATH="${DIRS[*]}"
	unset -f gen-cdpath
} &>/dev/null

gen-cdpath

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg HISTORY_BASE HYPHEN_INSENSITIVE REPORTTIME ZSH_CACHE_DIR ZSH_COMPDUMP
HISTORY_BASE=$XDG_CACHE_HOME/per-directory-history
HYPHEN_INSENSITIVE=1
REPORTTIME=10
ZSH_CACHE_DIR=$XDG_CACHE_HOME
ZSH_COMPDUMP=$XDG_CACHE_HOME/zcompdump-${ZSH_VERSION}

typeset -AHg DIRSTACK
DIRSTACK['file']="$XDG_CACHE_HOME/z_dirs"
DIRSTACK['size']=20

tty &>/dev/null && typeset -Hg is_tty=1
