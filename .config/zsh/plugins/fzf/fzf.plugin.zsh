# vim: syntax=zsh foldmethod=marker

function join-lines() {
	local item
	while read item; do
		echo -n " ${(q)item}"
	done
}

# => Load fzf (key bindings, completion) ------------------------------------------------------------------------- {{{1

for F in '/usr/share/fzf/key-bindings.zsh' "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"; do
	source-file "$F" && break
done

for F in '/usr/share/fzf/completion.zsh' "$XDG_CONFIG_HOME/fzf/completion.zsh"; do
	source-file "$F" && break
done

# => Settings ---------------------------------------------------------------------------------------------------- {{{1

# Use \ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='\'

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

PREVIEW='
	b() {(file -bi "$1" | grep "charset=binary") &>/dev/null && (hexdump -C "$1" || true)};
	f() {b "$1" || show-file "$1"}
	d() {[[ -d "$1" ]] && (tree -C "$1" || true)};
	p() {stat "$1"; echo -n "  Type: "; file -b "$1"; echo; (d "$1" || f "$1") 2>&1};
	p {} | head -n 100
'
export FZF_DEFAULT_BINDS=(
	--bind 'ctrl-d:page-down'
	--bind 'ctrl-u:page-up'
	--bind 'f1:toggle-preview'
	--bind 'f2:toggle-preview-wrap'
	--bind 'home:top'
	--bind 'ctrl-y:execute-silent(echo {} | xclip -i -sel p -f | xclip -i -sel c)+abort'
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
	--preview="${PREVIEW}"
)
export FZF_DEFAULT_OPTS=$(printf " '%s'" ${FZF_DEFAULT_BINDS[@]} ${FZF_FILE_BINDS[@]} ${FZF_FILE_PREVIEW[@]})
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_TMUX=1

# => ssh (override default one) ---------------------------------------------------------------------------------- {{{1

function _ssh_config_parsed_hosts() {
	local SSH_CONF=(~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config)
	command perl -mList::Util=uniq -nE 'm/[*?%#]/x and next; if (m/^.*host(?:name|\s)+(.*)/i) {push @hosts, split(m/ |,/, $1 =~ s/"//gr)}; END {say for uniq sort @hosts}' "${SSH_CONF[@]}"
}

function _ssh_known_parsed_hosts() {
	local SSH_KNOWN=(~/.ssh/known_hosts ~/.cache/ssh-known-hosts.work)
	command grep -oE '^[[a-z0-9.,:-]+' <(cat "${SSH_KNOWN[@]}") | tr ',' '\n' | tr -d '[' | awk '{print $1 " " $1}'
}

function _ssh_hosts_parsed_hosts() {
	command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0'
}

function _fzf_complete_ssh() {
	_fzf_complete '+m --bind=tab:accept' "$@" < <(
		command cat <(
			_ssh_config_parsed_hosts
			_ssh_known_parsed_hosts
			_ssh_hosts_parsed_hosts
		) | awk '{if (length($2) > 0) {print $2}}' | sort -u
	)
}
# => docker ------------------------------------------------------------------------------------------------------ {{{1

_fzf_complete_docker() {
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

_fzf_complete_docker_post() {
	awk '{print $1}'
}

# => kubectl ----------------------------------------------------------------------------------------------------- {{{1

_fzf_complete_kubectl() {
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

_fzf_complete_kubectl_post() {
	awk '{print $1}'
}

# => git --------------------------------------------------------------------------------------------------------- {{{1

function fzf-git-branches-widget() LBUFFER+=$(git-branches | join-lines)
function fzf-git-files-widget()    LBUFFER+=$(git-files | join-lines)
function fzf-git-hashes-widget()   LBUFFER+=$(git-hashes | join-lines)
function fzf-git-remotes-widget()  LBUFFER+=$(git-remotes | join-lines)
function fzf-git-tags-widget()     LBUFFER+=$(git-tags | join-lines)

zle -N fzf-git-branches-widget
zle -N fzf-git-files-widget
zle -N fzf-git-hashes-widget
zle -N fzf-git-tags-widget

bindkey '^j^h' fzf-git-hashes-widget
bindkey '^j^j' fzf-git-branches-widget
bindkey '^j^y' fzf-git-files-widget
bindkey '^j^u' fzf-git-tags-widget

# => common --------------------------------------------------------------------------------------------------------- {{{1

function fzf-detect-widget() {
	setopt local_options ksh_glob
	case "$LBUFFER" in
		git+( )@(show)*( ))
			LBUFFER+=$(git-hashes | join-lines)
			;;
		git+( )@(remote)+( )@(remove|rename|show)*( ))
			LBUFFER+=$(git-remotes | join-lines)
			;;
		git+( )@(co|checkout|l|log|diff)*( ))
			LBUFFER+=$(git-branches | join-lines)
			;;
		git+( )*@(--|rm)*( ))
			LBUFFER+=$(git-files | join-lines)
			;;
		git+( )@(add)*( ))
			LBUFFER+=$(git-files | join-lines)
			;;
		docker+( )rmi* | docker*-f* | docker*\ run*)
			LBUFFER+=$(docker-images | fzf --multi --reverse | awk '{print $1}' | join-lines)
			;;
		docker+( )start* | docker*stop* | docker*rm* | docker*exec* | docker*kill*)
			LBUFFER+=$(docker-containers | fzf --multi --reverse | awk '{print $1}' | join-lines)
			;;
		docker*( ))
			LBUFFER+=$(docker-commands | fzf --bind=tab:accept --reverse | awk '{print $1}' | join-lines)
			;;
		(kubectl|k)+( )(exec\ *\ -c\ |logs\ *-c\ ))
			LBUFFER+=$(kubectl-containers | fzf --multi --reverse | awk '{print $1}' | join-lines)
			;;
		(kubectl|k)+( )(exec|logs)\ *)
			LBUFFER+=$(kubectl-pods | fzf --multi --reverse | awk '{print $1}' | join-lines)
			;;
		(kubectl|k)*( ))
			LBUFFER+=$(kubectl-commands | fzf -n 1 --reverse --bind=tab:accept | awk '{print $1}' | join-lines)
			;;
		*( )cd+( )*)
			LBUFFER+=$(_fzf_compgen_helper "$(pwd)" 'd' | fzf | join-lines)
			;;
		**( ))
			LBUFFER+=$(_fzf_command_helper | fzf -m | join-lines)
			;;
	esac
}

zle -N fzf-detect-widget

bindkey '^[ ' fzf-detect-widget
