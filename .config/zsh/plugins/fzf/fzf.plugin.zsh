# vim: syntax=zsh foldmethod=marker
# set ft=zsh

# => Load fzf (key bindings, completion) ------------------------------------------------------------------------- {{{1

for F in '/usr/share/fzf/key-bindings.zsh' "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"; do
	source-file "$F" && break
done

for F in '/usr/share/fzf/completion.zsh' "$XDG_CONFIG_HOME/fzf/completion.zsh"; do
	source-file "$F" && break
done

# => Settings ---------------------------------------------------------------------------------------------------- {{{1

# Options to fzf command
#export FZF_COMPLETION_OPTS='+c -x'

function _fzf_compgen_path() {
	_fzf_compgen_helper "$1" 'f'
}

function _fzf_compgen_dir() {
	_fzf_compgen_helper "$1" 'd'
}

# => Setup commands ---------------------------------------------------------------------------------------------- {{{1

export FZF_DEFAULT_COMMAND='_fzf_command_helper'
export FZF_CTRL_T_COMMAND="_fzf_command_helper"
export FZF_ALT_C_COMMAND='_fzf_compgen_helper $(pwd) d'

# => Setup options ----------------------------------------------------------------------------------------------- {{{1

export FZF_DEFAULT_BINDS=(
	--bind 'ctrl-d:page-down'
	--bind 'ctrl-u:page-up'
	--bind 'f1:toggle-preview'
	--bind 'f2:toggle-preview-wrap'
	--bind 'home:top'
	--bind 'ctrl-y:execute-silent(echo -n {} | clipcopy)+abort'
)
export FZF_FILE_BINDS=(
	--bind 'f3:execute((show-dir {} || show-file {} ) | $PAGER > /dev/tty 2>&1)'
	--bind 'f4:execute($EDITOR {} < /dev/tty > /dev/tty 2>&1)'
	--bind 'ctrl-h:execute((show-dir {} || hexdump -C {}) | $PAGER > /dev/tty 2>&1)'
	--bind 'ctrl-b:execute((show-dir {} || binwalk {}) | $PAGER > /dev/tty 2>&1)'
	--bind 'ctrl-t:execute((show-dir {} || sha1sum {}) | $PAGER > /dev/tty 2>&1)'
	--bind 'ctrl-g:execute((show-dir {} || md5sum {}) | $PAGER > /dev/tty 2>&1)'
)
export FZF_FILE_PREVIEW=(
	--preview-window=right:78:hidden
	--preview="{ show-dir {} || show-file {} } 2>&1 | head -n 100"
)
export FZF_DEFAULT_OPTS=$(printf " '%s'" ${FZF_DEFAULT_BINDS[@]} ${FZF_FILE_BINDS[@]} ${FZF_FILE_PREVIEW[@]})
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_TMUX=1

# => sequence trigger (Use \ as the trigger sequence instead of the default **) ---------------------------------- {{{1

export FZF_COMPLETION_TRIGGER='\'

# => ssh (overrides the default one) ----------------------------------------------------------------------------- {{{1

function _fzf_complete_ssh() {
	_fzf_complete '+m --bind=tab:accept' "$@" < <(ssh-hosts)
}

# => docker ------------------------------------------------------------------------------------------------------ {{{1

function _fzf_complete_docker() {
	case "$1" in
		docker*\ rmi\ * | docker*-f* | docker*\ run\ *)
			_fzf_complete "--reverse -m" "$@" < <(docker-images)
			;;
		docker*start* | docker*stop* | docker*rm* | docker*exec* | docker*kill*)
			_fzf_complete "--reverse -m" "$@" < <(docker-containers)
			;;
		docker\ )
			_fzf_complete "--reverse --bind=tab:accept" "$@" < <(docker-commands)
			;;
	esac
}

function _fzf_complete_docker_post() {
	awk '{print $1}'
}

# => kubectl ----------------------------------------------------------------------------------------------------- {{{1

function _fzf_complete_kubectl() {
	case "$1" in
		kubectl*\ exec\ *\ -c\ )
			_fzf_complete "--reverse --bind=tab:accept" "$@" < <(kubectl-containers)
			;;
		kubectl*\ exec\ *)
			_fzf_complete "--reverse --bind=tab:accept" "$@" < <(kubectl-pods)
			;;
		kubectl\ )
			_fzf_complete "--reverse --bind=tab:accept -n 1" "$@" < <(kubectl-commands)
			;;
	esac
}

function _fzf_complete_kubectl_post() {
	awk '{print $1}'
}

# => git completion ---------------------------------------------------------------------------------------------- {{{1

function fzf-git-branches-widget()       LBUFFER+=$(fzf-git-branches --all | stdin-join-lines)
function fzf-git-files-widget()          LBUFFER+=$(fzf-git-files          | stdin-join-lines)
function fzf-git-hashes-widget()         LBUFFER+=$(fzf-git-hashes         | stdin-join-lines)
function fzf-git-remotes-widget()        LBUFFER+=$(fzf-git-remotes        | stdin-join-lines)
function fzf-git-tags-widget()           LBUFFER+=$(fzf-git-tags           | stdin-join-lines)

zle -N fzf-git-branches-widget
zle -N fzf-git-files-widget
zle -N fzf-git-hashes-widget
zle -N fzf-git-tags-widget

bindkey '^j^h' fzf-git-hashes-widget
bindkey '^j^j' fzf-git-branches-widget
bindkey '^j^y' fzf-git-files-widget
bindkey '^j^u' fzf-git-tags-widget

# => context completion ------------------------------------------------------------------------------------------ {{{1

function fzf-detect-widget() {
	setopt local_options ksh_glob
	case "$LBUFFER" in
		git+( )@(show)*( ))
			RESULT=$(fzf-git-hashes | stdin-join-lines)
			;;
		git+( )@(remote)+( )@(remove|rename|show)*( ))
			RESULT=$(fzf-git-remotes | stdin-join-lines)
			;;
		git+( )@(co|checkout|l|log|diff)*( ))
			RESULT=$(fzf-git-branches --all | stdin-join-lines)
			;;
		git+( )@(br*|br*-D)*( ))
			RESULT=$(fzf-git-branches | stdin-join-lines)
			;;
		git+( )*@(--|rm)*( ))
			RESULT=$(fzf-git-files | stdin-join-lines)
			;;
		git+( )@(add)*( ))
			RESULT=$(fzf-git-files | stdin-join-lines)
			;;
		docker+( )rmi* | docker*-f* | docker*\ run*)
			RESULT=$(docker-images | fzf --multi --reverse | awk '{print $1}' | stdin-join-lines)
			;;
		docker+( )start* | docker*stop* | docker*rm* | docker*exec* | docker*kill*)
			RESULT=$(docker-containers | fzf --multi --reverse | awk '{print $1}' | stdin-join-lines)
			;;
		docker*( ))
			RESULT=$(docker-commands | fzf --bind=tab:accept --reverse | awk '{print $1}' | stdin-join-lines)
			;;
		(kubectl|k)+( )(exec\ *\ -c\ |logs\ *-c\ ))
			RESULT=$(kubectl-containers | fzf --multi --reverse | awk '{print $1}' | stdin-join-lines)
			;;
		(kubectl|k)+( )(exec|logs)\ *)
			RESULT=$(kubectl-pods | fzf --multi --reverse | awk '{print $1}' | stdin-join-lines)
			;;
		(kubectl|k)*( ))
			RESULT=$(kubectl-commands | fzf -n 1 --reverse --bind=tab:accept | awk '{print $1}' | stdin-join-lines)
			;;
		ssh*( ))
			RESULT=$(ssh-hosts | fzf -n 1 --reverse --bind=tab:accept | awk '{print $1}' | stdin-join-lines)
			;;
		*( )cd+( )*)
			RESULT=$(_fzf_compgen_dir "$(pwd)" | fzf | stdin-join-lines)
			;;
		**( ))
			RESULT=$(_fzf_command_helper | fzf -m | stdin-join-lines)
			;;
	esac
	if [[ -n $RESULT ]]; then
		LBUFFER=$(echo "$LBUFFER" | sed -e 's/[[:space:]]*$/ /g')
		LBUFFER+=$RESULT
	fi
}

zle -N fzf-detect-widget

# bind to alt-space
bindkey '^[ ' fzf-detect-widget

# => completion overrides ---------------------------------------------------------------------------------------- {{{1

bindkey '^_' _complete_help

# Call the function to make sure that it is loaded.
# _ssh &>/dev/null

# Save the original function.
# functions[_ssh-orig]=$functions[_ssh]

# Redefine your completion function referencing the original.
# _ssh() {
# 	FZF_COMPLETION_TRIGGER='' _fzf_complete_ssh
# }
