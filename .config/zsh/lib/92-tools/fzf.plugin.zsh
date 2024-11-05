# vim: filetype=zsh foldmethod=marker

# => Load fzf (key bindings, completion) -------------------------------------------------------------------------- {{{1

for F in '/usr/share/fzf/key-bindings.zsh' '/usr/share/fzf/shell/key-bindings.zsh' "$XDG_CONFIG_HOME/fzf/key-bindings.zsh" "$XDG_DATA_HOME/nvim/lazy/fzf/shell/key-bindings.zsh"; do
	[[ -r "$F" ]] || continue
	source-file "$F" && break
done

for F in '/usr/share/fzf/completion.zsh' "$XDG_CONFIG_HOME/fzf/completion.zsh" "$XDG_DATA_HOME/nvim/lazy/fzf/shell/completion.zsh"; do
	[[ -r "$F" ]] || continue
	source-file "$F" && break
done

# => sequence trigger (Use \ as the trigger sequence instead of the default **) ----------------------------------- {{{1

#export FZF_COMPLETION_TRIGGER='\'

# => Settings ----------------------------------------------------------------------------------------------------- {{{1

#export FZF_COMPLETION_OPTS='+c -x'

function _fzf_compgen_path() {
	_fzf_compgen_helper "$1" 'f'
}

function _fzf_compgen_dir() {
	_fzf_compgen_helper "$1" 'd'
}

function _fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		cd)           fzf "$@" --preview 'tree -Chp -L 2 {} | head -200' ;;
		export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
		ssh)          fzf "$@" --preview 'dig {}' ;;
		*)            fzf "$@" ;;
	esac
}

# => Setup commands ----------------------------------------------------------------------------------------------- {{{1

export FZF_DEFAULT_COMMAND='_fzf_command_helper'
export FZF_CTRL_T_COMMAND="_fzf_command_helper"
export FZF_ALT_C_COMMAND='_fzf_compgen_helper . d'

# => Setup options ------------------------------------------------------------------------------------------------ {{{1

# export FZF_DEFAULT_BINDS=(
# 	--bind='ctrl-d:half-page-down,ctrl-u:half-page-up'
# 	--bind='ctrl-h:preview-up,ctrl-l:preview-down'
# 	--bind='ctrl-v:toggle-preview,ctrl-w:toggle-preview-wrap,ctrl-s:toggle-sort'
# 	--bind='ctrl-y:execute-silent(echo -n {} | clipcopy)'
# 	--bind='esc:cancel'
# 	--bind='home:top'
# 	--bind='tab:accept,shift-tab:accept'
# )
# export FZF_FILE_BINDS=(
# 	--bind='ctrl-alt-d:execute(rm -i {+} < /dev/tty > /dev/tty)+abort'
# 	--bind='ctrl-b:execute((show-dir {} || binwalk {}) | $PAGER > /dev/tty 2>&1)'
# 	--bind='ctrl-g:execute((show-dir {} || md5sum {}) | $PAGER > /dev/tty 2>&1)'
# 	--bind='ctrl-t:execute((show-dir {} || sha1sum {}) | $PAGER > /dev/tty 2>&1)'
# 	--bind='ctrl-x:execute((show-dir {} || hexdump -C {}) | $PAGER > /dev/tty 2>&1)'
# 	--bind='f3:execute((show-dir {} || show-file {} ) | $PAGER > /dev/tty 2>&1)'
# 	--bind='f4:execute($EDITOR {} < /dev/tty > /dev/tty 2>&1)'
# )
# export FZF_FILE_PREVIEW=(
# 	--preview='{ show-dir {} || show-file {} } 2>&1 | head -n 100'
# )

# export FZF_NO_MULTI_OPTIONS=(
# 	--no-multi
# 	--bind='tab:accept,shift-tab:accept'
# )

# export FZF_MULTI_OPTIONS=(
# 	--multi
# 	--bind='tab:toggle-out,shift-tab:toggle-in'
# )

# export FZF_DEFAULT_OPTS=$(printf " '%s'" ${FZF_NO_MULTI_OPTIONS[@]} ${FZF_DEFAULT_BINDS[@]} ${FZF_FILE_BINDS[@]} ${FZF_FILE_PREVIEW[@]})
# export   FZF_MULTI_OPTS=$(printf " '%s'" ${FZF_MULTI_OPTIONS[@]})

# export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS $FZF_MULTI_OPTS"
export FZF_CTRL_R_OPTS="--bind=esc:abort"
# export FZF_ALT_C_OPTS=""

# export FZF_TMUX=1

# => ssh (overrides the default one) ------------------------------------------------------------------------------ {{{1

function _fzf_complete_ssh() {
	_fzf_complete -- "$@" < <(~/.local/script/ssh-hosts)
}

# => docker ------------------------------------------------------------------------------------------------------- {{{1

function _fzf_complete_docker() {
	case "$1" in
		docker*\ rmi\ * | docker*-f* | docker*\ run\ *)
			_fzf_complete "--reverse $FZF_MULTI_OPTS" "$@" < <(docker-images)
			;;
		docker*start* | docker*stop* | docker*rm* | docker*exec* | docker*kill*)
			_fzf_complete "--reverse $FZF_MULTI_OPTS" "$@" < <(docker-containers)
			;;
		docker\ )
			_fzf_complete "--reverse" "$@" < <(docker-commands)
			;;
	esac
}

function _fzf_complete_docker_post() {
	perl -aE '@F && print($F[0]) && (eof() or print " ")'
}

# => kubectl ------------------------------------------------------------------------------------------------------ {{{1

function _fzf_complete_kubectl() {
	case "$1" in
		kubectl*\ exec\ *\ -c\ )
			_fzf_complete "--reverse" "$@" < <(kubectl-containers)
			;;
		kubectl*\ exec\ *)
			_fzf_complete "--reverse" "$@" < <(kubectl-pods)
			;;
		kubectl\ )
			_fzf_complete "--reverse -n 1" "$@" < <(kubectl-commands)
			;;
	esac
}

function _fzf_complete_kubectl_post() {
	_fzf_complete_docker_post
}

# => git completion ----------------------------------------------------------------------------------------------- {{{1

function fzf-git-branches-widget()       LBUFFER+=$(fzf-git-branches --all | stdin-join-lines)
function fzf-git-files-changed-widget()  LBUFFER+=$(fzf-git-files-changed  | stdin-join-lines)
function fzf-git-files-widget()          LBUFFER+=$(fzf-git-files          | stdin-join-lines)
function fzf-git-hashes-all-widget()     LBUFFER+=$(fzf-git-hashes-all     | stdin-join-lines)
function fzf-git-hashes-widget()         LBUFFER+=$(fzf-git-hashes         | stdin-join-lines)
function fzf-git-remotes-widget()        LBUFFER+=$(fzf-git-remotes        | stdin-join-lines)
function fzf-git-tags-widget()           LBUFFER+=$(fzf-git-tags           | stdin-join-lines)

zle -N fzf-git-branches-widget
zle -N fzf-git-files-changed-widget
zle -N fzf-git-files-widget
zle -N fzf-git-hashes-all-widget
zle -N fzf-git-hashes-widget
zle -N fzf-git-remotes-widget
zle -N fzf-git-tags-widget

bindkey ';;' fzf-git-files-widget
bindkey ';H' fzf-git-hashes-all-widget
bindkey ';h' fzf-git-hashes-widget
bindkey ';j' fzf-git-branches-widget
bindkey ';k' fzf-git-remotes-widget
bindkey ';l' fzf-git-files-changed-widget
bindkey ';t' fzf-git-tags-widget

# => context completion ------------------------------------------------------------------------------------------- {{{1

function fzf-detect-widget() {
	setopt local_options ksh_glob
	case "$LBUFFER" in
		git+( )@(show)*( ))
			RESULT=$(fzf-git-log-all | stdin-join-lines)
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
			RESULT=$(docker-images | fzf --reverse "${FZF_MULTI_OPTIONS[@]}" | _fzf_complete_docker_post)
			;;
		docker+( )start* | docker*stop* | docker*rm* | docker*exec* | docker*kill*)
			RESULT=$(docker-containers | fzf --reverse "${FZF_MULTI_OPTIONS[@]}" | _fzf_complete_docker_post)
			;;
		docker*( ))
			RESULT=$(docker-commands | fzf --reverse | _fzf_complete_docker_post)
			;;
		(kubectl|k)+( )(exec\ *\ -c\ |logs\ *-c\ ))
			RESULT=$(kubectl-containers | fzf --reverse "${FZF_MULTI_OPTIONS[@]}" | _fzf_complete_kubectl_post)
			;;
		(kubectl|k)+( )(exec|logs)\ *)
			RESULT=$(kubectl-pods | fzf --reverse "${FZF_MULTI_OPTIONS[@]}" | _fzf_complete_kubectl_post)
			;;
		(kubectl|k)*( ))
			RESULT=$(kubectl-commands | fzf --reverse -n 1 | _fzf_complete_kubectl_post)
			;;
		(ksync|kfinish|kabort)*)
			RESULT=$(kubectl-releases-active | fzf --reverse "${FZF_MULTI_OPTIONS[@]}" | _fzf_complete_kubectl_post)
			;;
		ssh*( ))
			RESULT=$(ssh-hosts | fzf --reverse -n 1 | _fzf_complete_docker_post)
			;;
		*( )cd+( )*)
			RESULT=$(_fzf_compgen_dir "$(pwd)" | fzf | stdin-join-lines)
			;;
		**( ))
			RESULT=$(_fzf_command_helper | fzf "${FZF_MULTI_OPTIONS[@]}" | stdin-join-lines)
			;;
	esac
	if [[ -n $RESULT ]]; then
		LBUFFER=$(echo "$LBUFFER" | sed -e 's/[[:space:]]+$/ /g')
		LBUFFER+=$RESULT
	fi
}

zle -N fzf-detect-widget

# bind to alt-space
bindkey '^[ ' fzf-detect-widget

# => completion overrides ----------------------------------------------------------------------------------------- {{{1

bindkey '^_' _complete_help

# Call the function to make sure that it is loaded.
# _ssh &>/dev/null

# Save the original function.
# functions[_ssh-orig]=$functions[_ssh]

# Redefine your completion function referencing the original.
# _ssh() {
# 	FZF_COMPLETION_TRIGGER='' _fzf_complete_ssh
# }
